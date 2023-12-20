import 'package:cme/app.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/player_pages/bootcamp/boot_confirm_page.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/utils/navigate_effect.dart';
import "package:flutter/material.dart";

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/network/coach/card_request.dart';
import 'package:cme/payment/payment_add_card_page.dart';
import 'package:cme/payment/payment_method.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';

import '../../ui_widgets/build_gift_card.dart';
import '../../utils/show_snack.dart';

class PlayerBootCampPaymentPage extends StatefulWidget {
  final BootCampDetails bootCampDetails;
  final UserModel? userModel;
  final dynamic totalPrice;
  final List<Userdetails> otherUsers;

  const PlayerBootCampPaymentPage({
    Key? key,
    required this.bootCampDetails,
    required this.userModel,
    required this.otherUsers,
    required this.totalPrice,
  }) : super(key: key);
  @override
  _PlayerBootCampPaymentPageState createState() =>
      _PlayerBootCampPaymentPageState();
}

class _PlayerBootCampPaymentPageState extends State<PlayerBootCampPaymentPage> {
  UserModel? userModel;
  List<Giftcard>? giftCards = [];
  int? selectedGiftCardIndex;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
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
        title: "Payment Methods",
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
              dot2(1),
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
                        FetchCardsResponse f = snapshot.data!;
                        // cards = f.message == null ? [] : f.message!.paymentcard;
                        print("...refreshing...");
                         giftCards = f.message!.giftcard;
                         return Column(
                          children: [
                            giftCards!.isEmpty
                                ? Container(
                              child: Text("You have not gift cards yet."),
                            )
                                : Container(),
                             Column(
                              children: List.generate(
                                giftCards!.length,
                                    (index) {
                                  var g = giftCards![index];
                                  return InkWell(
                                    onTap: () {
                                      if ((g.balance / 1.0) >
                                          widget.totalPrice) {
                                        setState(() {
                                          selectedGiftCardIndex = index;
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
                        //     :
                        // Wrap(
                        //         children: List.generate(
                        //           cards!.length,
                        //           (index) => GestureDetector(
                        //             onTap: () {
                        //               setState(() {
                        //                 selectedCardIndex = index;
                        //               });
                        //             },
                        //             child: selectedCardIndex == index
                        //                 ? buildCheckile(
                        //                     buildPaymentCardBody(
                        //                       name: cards![index].nameOnCard,
                        //                       cardNumber: cards![index].cardkey!,
                        //                     ),
                        //                   )
                        //                 : Padding(
                        //                     padding: const EdgeInsets.only(
                        //                         bottom: 16.0),
                        //                     child: buildCard(
                        //                       Expanded(
                        //                         child: buildPaymentCardBody(
                        //                           name: cards![index].nameOnCard,
                        //                           cardNumber:
                        //                               cards![index].cardkey!,
                        //                         ),
                        //                       ),
                        //                       innerPadding: 0,
                        //                     ),
                        //                   ),
                        //           ),
                        //         ),
                        //       );
                      }
                    }
                  })
              /* Wrap(
                children: List.generate(
                  4,
                  (index) => index == 0
                      ? buildCheckile(buildPaymentCardBody(items[index]))
                      : buildPaymentCard(items[index]),
                ),
              ),
              buildGiftCard(),

              */
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: proceedButton(
            text: "Next",
            onPressed: () {
              // payViaExistingCard(context);
              pushRoute(
                context,
                PlayerBootCampConfirmPage(
                  bootCampDetails: widget.bootCampDetails,
                  userModel: widget.userModel,
                  otherUsers: widget.otherUsers,
                  totalPrice: widget.totalPrice,
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
