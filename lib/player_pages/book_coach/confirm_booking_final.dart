import 'dart:convert';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/create_booking_response.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/booking.dart';
import 'package:cme/payment/payment-service.dart';
import 'package:cme/player_pages/book_coach/confirmation_page.dart';
import 'package:cme/player_pages/book_coach/review_booking_time.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ConfirmBookingFinal extends StatefulWidget {
  final double totalAmount;
  final Userdetails coachDetails;
  final List<BookingDates> bookingDates;
  final bool isPhysical;
  final List<Userdetails> otherUsers;
  final UserModel? userModel;
  final Paymentcard? card;
  final locationdata;
  final BioSubDetail? currentDetails;
  final Giftcard? giftcard;

  const ConfirmBookingFinal({
    Key? key,
    required this.totalAmount,
    required this.currentDetails,
    required this.locationdata,
    required this.coachDetails,
    required this.bookingDates,
    required this.isPhysical,
    required this.otherUsers,
    required this.userModel,
    required this.card,
    required this.giftcard,
  }) : super(key: key);
  @override
  _ConfirmBookingFinalState createState() => _ConfirmBookingFinalState();
}

class _ConfirmBookingFinalState extends State<ConfirmBookingFinal> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  late Userdetails coachDetails;
  List<BookingDates>? bookingDates;
  Giftcard? giftcard;

  int? cardId = 0;
  int totalSessions = 0;
  double totalPrice = 0;
  double finalTotalPrice = 0;
  double promoValue = 0;
  double? giftCardValue = 0;
  CardFieldInputDetails? _card;
  String _paymentIntent = "";
  double computeFinalTotal() {
    return totalPrice - promoValue - giftCardValue!;
  }

  @override
  void initState() {
    super.initState();
    giftcard = widget.giftcard;
    if (giftcard != null) {
      giftCardValue = giftcard!.balance / 1.0;
      cardId = giftcard!.id;
    }
    StripeService.init();

    coachDetails = widget.coachDetails;
    bookingDates = widget.bookingDates;
    totalSessions = 0;

    totalSessions = 0;
    for (var item in bookingDates!) {
      totalSessions += item.bookingTimes!.length;
    }
    totalPrice = widget.totalAmount;
    // Future<String?> initPaymentSheet(String authToken, amount, userId, context) async {


    initPaymentSheet();
  //   StripeService.initPaymentSheet(
  //       widget.userModel?.getAuthToken() ?? "",
  //       '${(computeFinalTotal() * 100).toInt()}',
  //       widget.userModel?.getUserDetails()!.id,
  //     context
  //   ).then((value) => {  _paymentIntent = value ?? ""        });
  //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "Book Coach",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        dot(3),
        verticalSpace(height: 23),
        buildCard(Expanded(
          child: Row(
            children: <Widget>[
              CircularNetworkImage(
                imageUrl: photoUrl + coachDetails.profilePic!,
              ),
              horizontalSpace(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${coachDetails.name}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  verticalSpace(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SmoothStarRating(
                        starCount: 5,
                        rating:
                            double.tryParse("${coachDetails.profile?.rating ?? 0}") ??
                                0,
                        color: Color.fromRGBO(182, 9, 27, 1),
                        borderColor: Color.fromRGBO(182, 9, 27, 1),
                        size: 14,
                      ),
                      // Icon(
                      //   Icons.star,
                      //   color: Color.fromRGBO(182, 9, 27, 1),
                      //   size: 14,
                      // ),
                      horizontalSpace(),
                      Text(
                        "${coachDetails.profile?.rating ?? 0}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Text(
                    "Range: ${calculateDistanceBtw(widget.userModel!.getUserDetails()!, coachDetails)}", // "Range: ${coachDetails.profile.radius}km", //107km", //TODO("CALCULATE RANGE")
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(182, 9, 27, 1)),
                  ),
                ],
              )
            ],
          ),
        )),
        verticalSpace(height: 16),
        buildCard(Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/calendar.png",
                width: 15,
                height: 15,
              ),
              horizontalSpace(),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Session Time",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      verticalSpace(),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            bookingDates!.length,
                            (index) {
                              var date = bookingDates![index];
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    date.bookingTimes!.length,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${dateToString(date.date)} ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontFamily: App.font_name2,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${bookingTimeRange(date.bookingTimes![index])}", //

                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: App.font_name2,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    182, 9, 27, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ))
                    ]),
              )
            ],
          ),
        )),
        verticalSpace(),
        buildCard(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Promo Code"),
                ),
              ),
            ),
            innerPadding: 0),
        verticalSpace(height: 16),
        buildCard(Expanded(
          child: Column(
            children: <Widget>[
              iconTextText("assets/a7.png", "Session Price",
                  "£${(widget.currentDetails!.bioPrice).toStringAsFixed(2)}"),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/voucher.png", "Session", "$totalSessions"),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              Row(
                children: <Widget>[
                  Text(
                    "Sub total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  horizontalSpace(),
                  Text(
                    "£${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: App.font_name2,
                    ),
                  ),
                ],
              ),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/coupon.png", "Promo Discount",
                  "-£${promoValue.toStringAsFixed(2)}",
                  color: red),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/a8.png", "Gift Card",
                  "-£${giftCardValue!.toStringAsFixed(2)}",
                  color: red),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              Row(
                children: <Widget>[
                  boldText(
                    "Total",
                    size: 16,
                  ),
                  Spacer(),
                  horizontalSpace(),
                  rBoldText("£${computeFinalTotal().toStringAsFixed(2)}",
                      size: 16),
                ],
              ),
            ],
          ),
        )),
        verticalSpace(height: 16),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                color: Color.fromRGBO(182, 9, 27, 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Edit Booking",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(182, 9, 27, 1)),
                  ),
                ],
              ),
            ),
          ),
        ),
        verticalSpace(height: 16),

        // CardFormField(
        //   enablePostalCode:false,
        //
        //   onCardChanged: (card) {
        //     print(card);
        //    _card = card;
        //   },
        // ),
        proceedButton(
          text: "Book Now",
          onPressed: () async {
            print("book now tapped");
            if (giftcard == null) {
              try {
                // 3. display the payment sheet.
                await Stripe.instance.presentPaymentSheet();


                  CreateBookingResponse c;

                    var ref = _paymentIntent;
                    // print("Stripe reff: $ref");
                  var  bookingref = await createBooking(ref);
                 //   bookingSuccess = "\n${c.message}";
                  if (bookingref.status ?? false) {
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    pushRoute(
                        context,
                        BookingConfirmationPage(
                          userModel: widget.userModel,
                          booking: bookingref,
                          coachDetails: widget.coachDetails,
                          bookingDates: bookingDates,
                          locationdata: widget.locationdata,
                        ));
                  }
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

               } else {
              var r =
                  await createBooking("Gift card sent by ${giftcard!.buyerid}");
              showSnack(context, r.message);
              if (r.status!) {
                // Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                pushRoute(
                    context,
                    BookingConfirmationPage(
                      userModel: widget.userModel,
                      booking: r,
                      coachDetails: widget.coachDetails,
                      bookingDates: bookingDates,
                      locationdata: widget.locationdata,
                    ));
              }
            }
          },
        ),
      ],
    );
  }

  // payViaExistingCard(BuildContext context, Paymentcard card) async {
  //   ProgressDialog dialog = new ProgressDialog(context, isDismissible: false);
  //   dialog.style(message: 'Processing...');
  //   await dialog.show();
  //
  //   // var c = cards[selectedCardIndex];
  //   cardId = card.id;
  //   final CreditCard stripeCard = CreditCard(
  //     number: '${card.cardkey}',
  //     expMonth: int.parse("${card.expiryDate.split("/").first}"),
  //     expYear: int.parse("${card.expiryDate.split("/").last}"),
  //   );
  //   var response = await StripeService.payViaExistingCard(
  //     amount: '${(computeFinalTotal() * 100).toInt()}',
  //     currency: 'EUR',
  //     card: stripeCard,
  //   );
  //   var bookingSuccess = "\nUnable Create Booking";
  //   var message = "";
  //   CreateBookingResponse c;
  //   if (response.success) {
  //     var l = response.message.split("--");
  //     message = l.first;
  //     var ref = l.last.trim();
  //     // print("Stripe reff: $ref");
  //     c = await createBooking(ref);
  //     bookingSuccess = "\n${c.message}";
  //   } else {
  //     message = response.message;
  //   }
  //   await dialog.hide();
  //   // Scaffold.of(context)
  //
  //   // print("response........$message");
  //   _key.currentState
  //       .showSnackBar(SnackBar(
  //         content: Text("$message$bookingSuccess"),
  //         duration: new Duration(milliseconds: 1200),
  //       ))
  //       .closed
  //       .then((_) {
  //     // print("completed........");
  //     // Navigator.pop(context);
  //   });
  //   if (c.status) {
  //     // Navigator.pop(context);
  //     // Navigator.pop(context);
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     pushRoute(
  //         context,
  //         BookingConfirmationPage(
  //           userModel: widget.userModel,
  //           booking: c,
  //           coachDetails: widget.coachDetails,
  //           bookingDates: bookingDates,
  //           locationdata: widget.locationdata,
  //         ));
  //   }
  // }

  Future<CreateBookingResponse> createBooking(ref) async {
    try {
      List dates = [];
      for (var item in bookingDates!) {
        var d = dateToString2(item.date);
        for (var i in item.bookingTimes!) {
          var ii = DateFormat.Hm().format(i);
          //"${i.hour}:${i.minute}";
          var m = {"dates": "$d", "time": "$ii"};
          dates.add(m);
        }
      }

      List otherUserPhones = [];

      for (var item in widget.otherUsers) {
        var m = {
          "phone": "${item.phone}",
        };
        otherUserPhones.add(m);
      }

      var locData = widget.locationdata;
      print("location....... $locData");

      CreateBookingResponse c = await createBookingPlayer(
        widget.userModel!.getAuthToken(),
        isGiftCard: giftcard != null,
        b: CreateBookingClass(
          bookingDates: jsonEncode(dates),
          otherUsers: jsonEncode(otherUserPhones),
          coachId: widget.coachDetails.id,
          sessionMode: widget.isPhysical ? 1 : 0, //Physical  = 1, virtual = 0
          price: "$totalPrice", //"${computeFinalTotal()}",
          paymentCardId: "$cardId",
          latOfBooking: locData[2],
          longOfBoking: locData[1],
          locationOfBooking: locData[0],
          paymentRefrence: "$ref",
        ),
      );

      return c;
    } catch (e) {
      print("error....$e");
      return CreateBookingResponse(
          status: false, message: "Error occured in Create Booking");
    }
  }



  Future<void> initPaymentSheet() async {
    if(computeFinalTotal() <= 0 ) return;
    try {

      // 1. create payment intent on the server
      final data = await StripeService.getPaymentSheet(
          token:widget.userModel!.getAuthToken(),
          amount: '${(computeFinalTotal() * 100).toInt()}', //finalTotalPrice
          currency: "GBP", //finalTotalPrice
          userId: widget.userModel!.getUserDetails()!.id.toString()
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
}
