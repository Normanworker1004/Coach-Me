import 'dart:async';
import 'dart:convert';
import 'package:cme/network/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../model/create_payment_sheet.dart';
import '../network/coach/request.dart';

class StripeTransactionResponse {
  String? message;
  bool? success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = stripeSecretKey; //'your_api_secret';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    Stripe.publishableKey = stripePublicKey;
    Stripe.merchantIdentifier = "Test";
  }

  // static Future<StripeTransactionResponse> payViaExistingCard(
  //     {String amount, String currency, CreditCard card}) async {
  //   try {
  //
  //   //  var paymentMethod = await StripePayment.createPaymentMethod(  PaymentMethodRequest(card: card));
  //     var paymentMethodData = PaymentMethodData(billingDetails: BillingDetails());
  //     var paymentMethod = await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(paymentMethodData: paymentMethodData));
  //
  //     var paymentIntent =
  //         await StripeService.createPaymentIntent(amount, currency);
  //     var response = await Stripe.instance.confirmPayment(  paymentIntent['client_secret'],
  //         PaymentMethodParams.card()
  //         paymentMethodId: paymentMethod.id );
  //
  //     if (response.status == 'succeeded') {
  //       return  StripeTransactionResponse(
  //           message: 'Transaction successful -- ${response.paymentIntentId}',
  //           success: true);
  //     } else {
  //       return StripeTransactionResponse(
  //           message: 'Transaction failed', success: false);
  //     }
  //   } on PlatformException catch (err) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (err) {
  //     print("paymenr...error....$err");
  //     return StripeTransactionResponse(
  //         message: 'Transaction failed: ${err.toString()}', success: false);
  //   }
  // }

  // static Future<StripeTransactionResponse> payWithNewCard(
  //     {String? amount, String? currency}) async {
  //   try {
  //       var paymentMethodData = PaymentMethodData(billingDetails: BillingDetails());
  //     var paymentMethod = await Stripe.instance.createPaymentMethod(params:PaymentMethodParams.card(paymentMethodData: paymentMethodData), );
  //
  //     var paymentIntent =
  //         await (StripeService.createPaymentIntent(amount, currency) as FutureOr<Map<String, dynamic>>);
  //
  //       var response =   await Stripe.instance.confirmPayment(paymentIntentClientSecret:paymentIntent['client_secret'], data:PaymentMethodParams.card(paymentMethodData: paymentMethodData));
  //
  //     // var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
  //     //     clientSecret: paymentIntent['client_secret'],
  //     //     paymentMethodId: paymentMethod.id));
  //
  //     // response.status
  //     if (response.status == 'succeeded') {
  //       return  StripeTransactionResponse(
  //           message: 'Transaction successful', success: true);
  //     } else {
  //       return  StripeTransactionResponse(
  //           message: 'Transaction failed', success: false);
  //     }
  //   } on PlatformException catch (err) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (err) {
  //     return StripeTransactionResponse(
  //         message: 'Transaction failed: ${err.toString()}', success: false);
  //   }
  // }

  static getPlatformExceptionErrorResult(err) {
    var r = '$err'.split(",")[1].trim();
    print('.....$err....$r');
    String message = '$r'; //'Something went wrong\n';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return  StripeTransactionResponse(
        message: "Payment Failed\n$message", success: false);
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String? amount, String? currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl),
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      // print('err charging user: ${err.toString()}');
    }
    return null;
  }

  static Future<CreatePaymentSheet?> getPaymentSheet({
      token, String? amount, String? currency, String? userId}) async {
    var url = baseUrl + "api/payment-sheet";

    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'userid':userId
      };
      http.Response r = await http
          .post(
        Uri.parse(url),
        headers: {
          "x-access-token": token,
         },
        body: body,
      ) .catchError((e) {
        print("error....$e");
      });
      var v = CreatePaymentSheet.fromJson(jsonDecode(r.body));

      return v;

    } catch (err) {
      // print('err charging user: ${err.toString()}');
    }
    return null;
  }



  static  Future<String?> initPaymentSheet(String authToken, amount, userId, context) async {
    String? paymentIntent  ;
    try {
      // 1. create payment intent on the server
      final data = await StripeService.getPaymentSheet(
          token:authToken,
          amount: '${(amount * 100).toInt()}', //finalTotalPrice
          currency: "GBP", //finalTotalPrice
          userId: userId
      );
      if(data != null) {
        print("got some data ${data}");
        paymentIntent = data.paymentIntent ?? "";
        // 2. initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Enable custom flow
            //customFlow: true,
            // Main params
            merchantDisplayName: 'Coach & Me',
            paymentIntentClientSecret: data.paymentIntent,
            // Customer keys
            customerEphemeralKeySecret: data.ephemeralKey,
            customerId: data.customer,
            // Extra options
            //  applePay: true,
            // googlePay: true,
            style: ThemeMode.dark,
          ),
        );
      }
      return paymentIntent;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return null;
     }
  }
}

