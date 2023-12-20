import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/card_request.dart';
import 'package:cme/payment/payment_add_card_page.dart';
import 'package:cme/payment/payment_method.dart';
import 'package:cme/player_pages/book_coach/confirm_booking_final.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/build_gift_card.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class BookingPaymentMethod extends StatefulWidget {
  final double totalAmount;
  final Userdetails coachDetails;
  final List<BookingDates> bookingDates;
  final bool isPhysical;
  final List<Userdetails> otherUsers;
  final UserModel? userModel;
  final locationdata;
  final BioSubDetail? currentDetails;

  const BookingPaymentMethod({
    Key? key,
    required this.totalAmount,
    required this.locationdata,
    required this.coachDetails,
    required this.bookingDates,
    required this.isPhysical,
    required this.currentDetails,
    required this.otherUsers,
    required this.userModel,
  }) : super(key: key);
  @override
  _BookingPaymentMethodState createState() => _BookingPaymentMethodState();
}

class _BookingPaymentMethodState extends State<BookingPaymentMethod> {
  UserModel? userModel;
  List<Paymentcard>? cards = [];
  List<Giftcard>? giftCards = [];
  int? selectedCardIndex;
  int? selectedGiftCardIndex;

  double? bookingTotalAmount;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    bookingTotalAmount = widget.totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        // rightIconWidget: InkWell(
        //     onTap: () async {
        //       await pushRoute(context, PaymnetAddCardPage());
        //       setState(() {});
        //     },
        //     child: Image.asset(
        //       "assets/add_border.png",
        //       height: 24,
        //       width: 25,
        //     )),
        context: context,
        body: buildBody(context),
        title: "Gift cards",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 64.0),
          child: ListView(
            children: <Widget>[
              dot(2),
              verticalSpace(height: 23),
              FutureBuilder<FetchCardsResponse>(
                  future: fetchCards(userModel!.getAuthToken()),
                  builder: (context, snapshot) {
                    if (snapshot == null) {
                      return Center(
                          child: Text("Unable to load Payment Methods"));
                    } else {
                      if (snapshot.data == null) {
                        return Center(child: CupertinoActivityIndicator());
                      } else {
                        print("...refreshing...");
                        FetchCardsResponse f = snapshot.data!;
                         giftCards = f.message!.giftcard;

                        // if(giftCards == null || giftCards?.length == 0){
                        //    print("PRINTCARTDISNUUKKK");
                        //    pushReplacement(
                        //      context,
                        //      ConfirmBookingFinal(
                        //        currentDetails: widget.currentDetails,
                        //        locationdata: widget.locationdata,
                        //        totalAmount: widget.totalAmount,
                        //        coachDetails: widget.coachDetails,
                        //        bookingDates: widget.bookingDates,
                        //        isPhysical: widget.isPhysical,
                        //        otherUsers: widget.otherUsers,
                        //        userModel: widget.userModel,
                        //        card: null ,
                        //        giftcard: null,
                        //      ),
                        //    );
                        //  }
                        return Column(
                          children: [
                              giftCards!.isEmpty
                                ? Container(
                                child: Text("You have not gift cards yet."),
                              )
                                : Wrap(
                                    children: List.generate(
                                      cards!.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCardIndex = index;
                                            selectedGiftCardIndex = null;
                                          });
                                        },
                                        child: selectedCardIndex == index
                                            ? buildCheckile(
                                                buildPaymentCardBody(
                                                  name: cards![index].nameOnCard,
                                                  cardNumber:
                                                      cards![index].cardkey!,
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16.0),
                                                child: buildCard(
                                                  Expanded(
                                                    child: buildPaymentCardBody(
                                                      name: cards![index]
                                                          .nameOnCard,
                                                      cardNumber:
                                                          cards![index].cardkey!,
                                                    ),
                                                  ),
                                                  innerPadding: 0,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                            Column(
                              children: List.generate(
                                giftCards!.length,
                                (index) {
                                  var g = giftCards![index];
                                  return InkWell(
                                    onTap: () {
                                      if ((g.balance / 1.0) >
                                          bookingTotalAmount) {
                                        setState(() {
                                          selectedGiftCardIndex = index;
                                          selectedCardIndex = null;
                                        });
                                      } else {
                                        showSnack(context,
                                            "Gift Card not sufficient not sufficient to pay");
                                      }
                                    },
                                    child: selectedGiftCardIndex == index
                                        ? buildCheckile(buildGiftCard(g))
                                        : buildGiftCard(g),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                    }
                  })
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: proceedButton(
            text: "Next",
            onPressed:  () {
              print("SELECTED GIFTCARD INDEX ? ${selectedGiftCardIndex} ");

                    pushRoute(
                      context,
                      ConfirmBookingFinal(
                        currentDetails: widget.currentDetails,
                        locationdata: widget.locationdata,
                        totalAmount: widget.totalAmount,
                        coachDetails: widget.coachDetails,
                        bookingDates: widget.bookingDates,
                        isPhysical: widget.isPhysical,
                        otherUsers: widget.otherUsers,
                        userModel: widget.userModel,
                        card: null ,
                        giftcard: selectedGiftCardIndex == null
                            ? null
                            : giftCards![selectedGiftCardIndex!],
                      ),
                    );
                  },
          ),
        )
      ],
    );
  }
}



Widget buildCheckile(body) {
  return Column(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 100,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(182, 9, 27, 1),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: body),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Card(
                margin: EdgeInsets.all(0),
                shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: Color.fromRGBO(182, 9, 27, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      verticalSpace()
    ],
  );
}
