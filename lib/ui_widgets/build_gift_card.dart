import 'package:cme/app.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

Widget buildGiftCard(Giftcard gc, {bool showRedeem: true}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: buildCard(
      Expanded(
        child: Row(
          children: [
            Image.asset(
              "assets/gift-card.png",
              height: 40,
              width: 56,
            ),
            horizontalSpace(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Redeem Gift Card",
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                      children: [
                        TextSpan(text: "£${gc.balance}"),
                        TextSpan(text: " discount on your session booking"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                rBoldText(
                  "£${gc.balance}",
                ),
                Visibility(
                  visible: showRedeem,
                  child: Container(
                    width: 81,
                    height: 22,
                    child: Center(
                        child: mediumText("Redeem It", size: 14, color: white)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(226, 3, 3, 1),
                          Color.fromRGBO(182, 9, 27, 1)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
