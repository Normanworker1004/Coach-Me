import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/payment/payment-service.dart';
import 'package:cme/player_pages/book_coach/review_booking_time.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../model/boot_camp_join_response.dart';
import '../../network/player/join_bootcamp.dart';
import '../../utils/navigate_effect.dart';
import 'join_boot_confirmation_page.dart';


class PlayerBootCampConfirmPage extends StatefulWidget {
  final BootCampDetails bootCampDetails;
  final UserModel? userModel;
  final dynamic totalPrice;
  final List<Userdetails> otherUsers;
  // final Paymentcard card;
  final Giftcard? giftcard;

  const PlayerBootCampConfirmPage({
    Key? key,
    required this.bootCampDetails,
    required this.userModel,
    required this.otherUsers,
    required this.totalPrice,
    required this.giftcard,
    // required this.card,
  }) : super(key: key);
  @override
  _PlayerBootCampConfirmPageState createState() =>
      _PlayerBootCampConfirmPageState();
}

class _PlayerBootCampConfirmPageState extends State<PlayerBootCampConfirmPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  late BootCampDetails bootCampDetails;
  UserModel? userModel;
  Giftcard? giftcard;

  Profiledetails? coachProfile;
  Userdetails? coachDetails;
  int? cardId = 0;
  String _paymentIntent = "";

  int totalSession = 0;
  double totalPrice = 0;
  double finalTotalPrice = 0;
  double promoValue = 0;
  double giftCardValue = 0;

  double computeFinalTotal() {
    return totalPrice - promoValue - giftCardValue;
  }


  @override
  void initState() {
    super.initState();
    super.initState();
    giftcard = widget.giftcard;
    if (giftcard != null) {
      giftCardValue = giftcard!.balance / 1.0;
      cardId = giftcard!.id;
    }

    StripeService.init();

    userModel = widget.userModel;
    bootCampDetails = widget.bootCampDetails;

    coachProfile = bootCampDetails.coachProfile;
    coachDetails = bootCampDetails.coachDetails;
    totalSession = bootCampDetails.bootcamptime!.length;

    totalPrice = totalSession * (bootCampDetails.price ?? 0.0) ;
    initPaymentSheet();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "Book Bootcamp",
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
                imageUrl: "${photoUrl + coachDetails!.profilePic!}",
              ),
              horizontalSpace(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${coachDetails!.name}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  verticalSpace(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Color.fromRGBO(182, 9, 27, 1),
                        size: 14,
                      ),
                      horizontalSpace(),
                      Text(
                        "${coachProfile?.rating ?? 0}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Text(
                    "Range: ${coachProfile?.radius ?? 0}km", //107km", //TODO("CALCULATE RANGE")
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
        buildCard(
          Expanded(
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
                          bootCampDetails.bootcamptime!.length,
                          (index) {
                            var date = bootCampDetails.bootcamptime![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${toDate(bootCampDetails.bootCampDate)} ", //"${dateToString(date.time)} ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontFamily: App.font_name2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${date.time!.replaceAll("PM", "")} PM", //
                                      // "04:15 PM - 05:00pm",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: App.font_name2,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(182, 9, 27, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
                  "£${bootCampDetails.price}"),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/voucher.png", "Session", "$totalSession"),
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
                    "£$totalPrice",
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
              iconTextText(
                  "assets/coupon.png", "Promo Discount", "-£$promoValue",
                  color: red),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/a8.png", "Gift Card", "-£$giftCardValue",
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
                  rBoldText("£${computeFinalTotal()}", size: 16),
                ],
              ),
            ],
          ),
        )),
        verticalSpace(height: 16),
        proceedButton(
          text: "Book Now",
          onPressed: () async {
          //  payViaExistingCard(context, widget.card);
          if (giftcard == null) {
            try {
                var bookingSuccess = "\nUnable Create Booking";

              // 3. display the payment sheet.
              await Stripe.instance.presentPaymentSheet();
              BootCampJoinResponse c;
                var ref =  _paymentIntent;
                 c = await joinBootCamp(
                  widget.userModel?.getAuthToken(),
                  coachName: "${coachDetails?.name}",
                  bootCampId: "${widget.bootCampDetails.id}",
                  amount: "${computeFinalTotal()}",
                  cardId: "",
                  paymentRef: "$ref",
                );
                bookingSuccess = "\n${c.message}";

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment succesfully completed'),
                    ),);

              if (c.status ?? false) {
                // Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                pushRoute(
                    context,
                    JoinBootCampConfirmationPage(
                      userModel: widget.userModel!,
                      bootCampDetails: widget.bootCampDetails,
                    ));
              }
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

          }
           },
        ),
      ],
    );
  }

  payViaExistingCard(BuildContext context, Paymentcard card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Processing...');
    await dialog.show();

    // var c = cards[selectedCardIndex];
    // final CreditCard stripeCard = CreditCard(
    //   number: '${card.cardkey}',
    //   expMonth: int.parse("${card.expiryDate.split("/").first}"),
    //   expYear: int.parse("${card.expiryDate.split("/").last}"),
    // );
    // var response = await StripeService.createPaymentIntent(amount, currency)
    // final paymentMethod =
    // await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());

    //
    // var response = await StripeService.payViaExistingCard(
    //   amount: '${(computeFinalTotal() * 100).toInt()}',
    //   currency: 'EUR',
    //   card: stripeCard,
    // );
    // var bookingSuccess = "\nUnable Create Booking";
    // var message = "";
    // BootCampJoinResponse c;
    // if (response.success) {
    //   var l = response.message.split("--");
    //   message = l.first;
    //   var ref = l.last.trim();
    //   // print("Stripe reff: $ref");
    //   c = await joinBootCamp(
    //     widget.userModel.getAuthToken(),
    //     coachName: "${coachDetails.name}",
    //     bootCampId: "${widget.bootCampDetails.id}",
    //     amount: "${computeFinalTotal()}",
    //     cardId: widget.card.id,
    //     paymentRef: "$ref",
    //   );
    //   bookingSuccess = "\n${c.message}";
    // } else {
    //   message = response.message;
    // }
    // await dialog.hide();
    // _key.currentState
    //     .showSnackBar(SnackBar(
    //       content: Text("$message$bookingSuccess"),
    //       duration: new Duration(milliseconds: 1200),
    //     ))
    //     .closed
    //     .then((_) {});
    // if (c.status) {
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   pushRoute(
    //       context,
    //       JoinBootCampConfirmationPage(
    //         userModel: widget.userModel,
    //         bootCampDetails: widget.bootCampDetails,
    //       ));
    // }
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
