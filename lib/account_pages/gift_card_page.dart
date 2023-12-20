import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/network/coach/card_request.dart';
import 'package:cme/payment/payment-service.dart';
import 'package:cme/payment/payment_add_card_page.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/payment/payment_method.dart' as p;
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/logo_widget.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:stripe_payment/stripe_payment.dart';
import 'package:cme/player_pages/book_coach/booking_payment_add_card_page.dart'
    as input;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../model/general_response.dart';
import '../network/player/giftcard_request.dart';
import '../ui_widgets/register_widgets/phone_number_input.dart';

class GiftCardPage extends StatefulWidget {
  final UserModel userModel;

  const GiftCardPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _GiftCardPageState createState() => _GiftCardPageState();
}

class _GiftCardPageState extends State<GiftCardPage> {
  double sliderValue = 300;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      key: scaffoldKey,
      body: buildBaseScaffold(
        body: buildBody(context),
        context: context,
        title: "Gift Card",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(children: [
      SendGiftCard(
        userModel: widget.userModel,
        scaffoldKey: scaffoldKey,
      ),
      // buildAsk(),
      verticalSpace(height: 64),
    ]);
  }

  Widget buildAsk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        verticalSpace(height: 64),
        Center(child: boldText("Ask For Gift Card", size: 32)),
        verticalSpace(height: 16),
        boldText("Select Amount", size: 20),
        verticalSpace(height: 6),
        SizedBox(
          width: double.infinity,
          child: CupertinoSlider(
            min: 0,
            max: 500,
            value: sliderValue,
            // label: "£$sliderValue",
            activeColor: Colors.grey.withOpacity(0.5),
            // inactiveColor: Colors.grey.withOpacity(0.7),
            onChanged: (v) {
              setState(() {
                sliderValue = v.roundToDouble();
              });
            },
          ),
        ),
        Row(
          children: <Widget>[
            boldText("£0", size: 20),
            Expanded(
              child: Center(
                child: boldText(
                  "£$sliderValue",
                  size: 20,
                  color: deepBlue,
                ),
              ),
            ),
            boldText("£500", size: 20),
          ],
        ),
        verticalSpace(height: 32),
        buildInputField("Sender Full Name"),
        verticalSpace(),
        buildInputField("Sender Email Address"),
        verticalSpace(height: 16),
        proceedButton(text: "Send Request", onPressed: () {}),
      ],
    );
  }
}

class SendGiftCard extends StatefulWidget {
  final UserModel userModel;
  final scaffoldKey;

  SendGiftCard({
    Key? key,
    required this.userModel,
    required this.scaffoldKey,
  }) : super(key: key);
  @override
  _SendGiftCardState createState() => _SendGiftCardState();
}

class _SendGiftCardState extends State<SendGiftCard> {
  double sliderValue = 300;

  late UserModel userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  Paymentcard? card;
   String _paymentIntent = "";

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildCardOnTop(),
        verticalSpace(height: 16),
        boldText("Select Amount", size: 20),
        SizedBox(
          width: double.infinity,
          child: CupertinoSlider(
            min: 0,
            max: 500,
            value: sliderValue,
            activeColor: Colors.grey.withOpacity(0.5),
            onChanged: (v) {
              setState(() {
                sliderValue = v.roundToDouble();
              });
            },
          ),
        ),
        Row(
          children: <Widget>[
            boldText("£0", size: 20),
            Expanded(
              child: Center(
                child: rBoldText("£$sliderValue", size: 20, color: deepBlue),
              ),
            ),
            boldText("£500", size: 20),
          ],
        ),
        verticalSpace(height: 32),
        input.buildInputWidget(
          "Recipient Full Name",
          nameController,
          (c) {
            setState(() {});
          },
        ),
        verticalSpace(),

        phoneNumberInput(
               (String p, String internationalizedPhoneNumber,
              String isoCode) {
             setState(() {
              phoneController = TextEditingController(
                  text: internationalizedPhoneNumber);
            });
            print("number: ${phoneController.text}");
          },
            addPadding: false,
            label: "Recipient phone number"
        ),
        verticalSpace(),
        // input.buildInputWidget(
        //   "Recipient e-mail",
        //   emailController,
        //       (c) {
        //     setState(() {});
        //   },
        // ),
        // verticalSpace(),
        verticalSpace(height: 32),
        // Row(
        //   children: <Widget>[
        //     boldText("Payment Method"),
        //     Spacer(),
        //     // Container(
        //     //   decoration: BoxDecoration(
        //     //       border: Border.all(color: deepBlue),
        //     //       borderRadius: BorderRadius.circular(16)),
        //     //   child: Padding(
        //     //     padding: const EdgeInsets.all(8.0),
        //     //     child: Wrap(
        //     //       children: <Widget>[
        //     //         Icon(
        //     //           CupertinoIcons.pen,
        //     //           size: 12,
        //     //           color: Colors.blue[900],
        //     //         ),
        //     //         horizontalSpace(),
        //     //         lightText(
        //     //           "Edit Method",
        //     //           color: Colors.blue[900],
        //     //         ),
        //     //       ],
        //     //     ),
        //     //   ),
        //     // )
        //   ],
        // ),
        // verticalSpace(),
        // FutureBuilder<FetchCardsResponse>(
        //   future: fetchCards(userModel.getAuthToken()),
        //   builder: (context, snapshot) {
        //     if (snapshot == null) {
        //       return Center(child: Text("Unable to load Payment Methods"));
        //     } else {
        //       if (snapshot.data == null) {
        //         return Center(child: CupertinoActivityIndicator());
        //       } else {
        //         FetchCardsResponse f = snapshot.data!;
        //         List<Paymentcard> cards =
        //             f.message == null ? [] : f.message!.paymentcard!;
        //         if (cards.isEmpty) {
        //           return Container(
        //             width: double.infinity,
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 GestureDetector(
        //                     onTap: () async {
        //                       await pushRoute(context, PaymnetAddCardPage());
        //                       if (cards.isNotEmpty) {
        //                         card = cards[0];
        //                       }
        //                       setState(() {});
        //                     },
        //                     child: Icon(
        //                       Icons.add,
        //                       size: 64,
        //                     )),
        //                 mediumText("Add Card")
        //               ],
        //             ),
        //           );
        //         } else {
        //           card = cards[0];
        //           return buildCard(
        //             Expanded(
        //               child: p.buildPaymentCardBody(
        //                 name: card!.nameOnCard,
        //                 cardNumber: card!.cardkey!,
        //               ),
        //             ),
        //             innerPadding: 0,
        //           );
        //         }
        //       }
        //     }
        //   },
        // ),
        verticalSpace(height: 24),
        proceedButton(
          text: "Send Gift Card",
          onPressed: (nameController.text.length > 2 && phoneController.text.length > 2 )?   () {
                  payGiftCard(context);
                 }
                : null,
        ),
      ],
    );
  }

  Widget buildCardOnTop() {
    return Center(
      child: Container(
        height: 200,
        width: 310,
         decoration: BoxDecoration(
          // color: Colors.brown,
          image: DecorationImage(image: AssetImage("assets/giftcard.png")),
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  boldText(
                    "Gift Card",
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
              verticalSpace(),
              Row(
                children: <Widget>[
                  Spacer(),
                  rLightText(
                    "£$sliderValue",
                    color: Colors.white,
                    size: 26,
                  ),
                ],
              ),
              verticalSpace(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  horizontalSpace(),
                  Flexible(
                    child: buildWhiteLogo(
                      imageHeight: 28,
                      imageWidth: 30,
                      textSize: 24,
                      imageColor: white,
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  payGiftCard(BuildContext context) async{
      ProgressDialog dialog = new ProgressDialog(context, isDismissible: false);
      dialog.style(message: 'Processing gift card...');
      await dialog.show();

      var bookingSuccess = "\nUnable to send Gift Card";
      var message = "";

    await initPaymentSheet() ;
    var canSendGiftCard = await canSendGiftCardToUser(userModel.getAuthToken(),  phone: "${phoneController.text}");

    if(canSendGiftCard){


        try {
          // 3. display the payment sheet.
          await Stripe.instance.presentPaymentSheet();
          GeneralResponse2 c;
          var ref = _paymentIntent;
          // print("Stripe reff: $ref");
          c = await sendGiftCard(userModel.getAuthToken(),
              phone: "${phoneController.text}",
              price: "$sliderValue",
              paymentCardId: "",
              paymentRefrence: "$ref");
          bookingSuccess = "\n${c.message}";



          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment succesfully completed'),
            ),
          );
        } on Exception catch (e) {
          if (e is StripeException) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error from Stripe: ${e.error.localizedMessage}'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unforeseen error: ${e}'),
              ),
            );
          }
        }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Can\'t find user with this phone number.'),
        ),
      );

    }
      await dialog.hide();
  }
  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await StripeService.getPaymentSheet(
          token:widget.userModel.getAuthToken(),
          amount: '${(sliderValue * 100).toInt()}', //finalTotalPrice
          currency: "GBP", //finalTotalPrice
          userId: widget.userModel.getUserDetails()!.id.toString()
      );
      if(data != null) {
        print("got some data ${data}");
        _paymentIntent = data.paymentIntent ?? "";
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
      setState(() {
        // _ready = true;

      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }


  // payViaExistingCard(BuildContext context, Paymentcard card) async {
  //   ProgressDialog dialog = new ProgressDialog(context, isDismissible: false);
  //   dialog.style(message: 'Processing gift card...');
  //   await dialog.show();
  //
  //   // var c = cards[selectedCardIndex];
  //   // stripe.Card card = stripe.Card(
  //   //    expMonth: int.parse("${card.expiryDate.split("/").first}"),
  //   //
  //   // )
  //   final CreditCard stripeCard = CreditCard(
  //     number: '${card.cardkey}',
  //     expMonth: int.parse("${card.expiryDate.split("/").first}"),
  //     expYear: int.parse("${card.expiryDate.split("/").last}"),
  //   );
  //   var response = await StripeService.payViaExistingCard(
  //     amount: '${(sliderValue * 100).toInt()}',
  //     currency: 'EUR',
  //     card: stripeCard,
  //   );
  //   var bookingSuccess = "\nUnable to send Gift Card";
  //   var message = "";
  //   GeneralResponse2 c;
  //   if (response.success) {
  //     var l = response.message.split("--");
  //     message = l.first;
  //     var ref = l.last.trim();
  //     // print("Stripe reff: $ref");
  //     c = await sendGiftCard(userModel.getAuthToken(),
  //         phone: "${phoneController.text}",
  //         price: "$sliderValue",
  //         paymentCardId: "${card.id}",
  //         paymentRefrence: "$ref");
  //     bookingSuccess = "\n${c.message}";
  //   } else {
  //     message = response.message;
  //   }
  //   await dialog.hide();
  //   showSnack(widget.scaffoldKey, "$message\n$bookingSuccess");
  // }
}
