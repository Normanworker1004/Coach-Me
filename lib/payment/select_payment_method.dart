import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/network/coach/card_request.dart';
import 'package:cme/payment/payment_add_card_page.dart';
import 'package:cme/payment/payment_edit_card_page.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectPaymentMethod extends StatefulWidget {
  @override
  _SelectPaymentMethodState createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  late UserModel userModel;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, w, model) {
        userModel = model;
        return Scaffold(
          key: _key,
          body: buildBaseScaffold(
            context: context,
            body: buildBody(context),
            title: "Payment Method",
            rightIconWidget: InkWell(
                onTap: () async {
                  await pushRoute(context, PaymnetAddCardPage());
                  setState(() {});
                },
                child: Image.asset(
                  "assets/add_border.png",
                  height: 24,
                  width: 25,
                )),
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder<FetchCardsResponse>(
        future: fetchCards(userModel.getAuthToken()),
        builder: (context, snapshot) {
          if (snapshot == null) {
            return Center(child: Text("Unable to load Payment Methods"));
          } else {
            if (snapshot.data == null) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              FetchCardsResponse f = snapshot.data!;
              List<Paymentcard> cards =
                  f.message == null ? [] : f.message!.paymentcard!;
              return cards.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await pushRoute(context, PaymnetAddCardPage());
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add,
                                size: 64,
                              )),
                          mediumText("Add Card")
                        ],
                      ),
                    )
                  : ListView(
                      children: <Widget>[
                        Wrap(
                          children: List.generate(
                            cards.length,
                            (index) => Column(
                              children: [
                                buildCard(
                                  Expanded(
                                    child:
                                    Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        // All actions are defined in the children parameter.
                                        children:   [
                                          // A SlidableAction can have an icon and/or a label.
                                          SlidableAction(
                                            onPressed: (context) async {
                                                  await pushRoute(
                                                      context,
                                                      PaymnetEditCardPage(
                                                      card: cards[index],
                                                  ),
                                            );
                                            setState(() {});
                                            },
                                            backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                                            foregroundColor: Colors.black,
                                            label: 'Edit',
                                            // icon:
                                            // ImageIcon(
                                            //   AssetImage( "assets/edit_red.png")
                                            //  ),
                                          ),
                                          SlidableAction(
                                            onPressed: (context) async {
                                              Paymentcard c = cards[index];
                                              setState(() {
                                                cards.removeAt(index);
                                              });

                                              showSnack(context, "Deleting card...");
                                              var r = await deletePaymentCard(
                                                userModel.getAuthToken(),
                                                id: "${c.id}",
                                              );

                                              showSnack(context, r.message);

                                              setState(() {});
                                            },
                                            backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                                            foregroundColor: Colors.black,
                                          //  label: 'Delete',
                                             icon:Icon(Icons.delete).icon ,
                                            // ImageIcon(
                                            //   AssetImage( "assets/trash.png")
                                            //  ),
                                          ),
                                        ],
                                      ),
                                      child:buildPaymentCardBody(
                                        // imgUrl: items[index % items.length].icon,
                                        name: cards[index].nameOnCard,
                                        cardNumber: cards[index].cardkey!,
                                      ),
                                    ),


                                  ),
                                  innerPadding: 0,
                                ),
                                verticalSpace(height: 16),
                              ],
                            ),
                          ),
                        ),
                        verticalSpace(height: 16),
                      ],
                    );
            }
          }
        });
  }
}

Widget buildPaymentCardBody({
  imgUrl = "assets/paypal.png",
  name = "Paypal",
  String cardNumber = "4242424242125689",
}) {
  var type = checkCreditCardTypeInf0(cardNumber.replaceAll("-", ""));
  cardNumber =
      "xxxx - xxxx - xxxx - " + cardNumber.substring(cardNumber.length - 4);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: <Widget>[
        Image.asset(
          type[0],
          width: 64,
        ),
        horizontalSpace(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              type[1],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              cardNumber,
              style: TextStyle(
                fontSize: 13,
                fontFamily: App.font_name2,
              ),
            )
          ],
        ))
      ],
    ),
  );
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

List<String> checkCreditCardTypeInf0(String visa) {
  var type = detectCCType(visa.replaceAll("-", ""));
  switch (type) {
    case CreditCardType.amex:
      return ["assets/pay3.png", "America Express"];
      break;
    case CreditCardType.discover:
      return ["assets/pay2.png", "Discover"];
      break;
    case CreditCardType.mastercard:
      return ["assets/pay1.png", "Master Card"];
      break;
    case CreditCardType.visa:
      return ["assets/pay2.png", "Visa"];
      break;
    default:
      return ["assets/pay2.png", "Unknown"];
  }
}
