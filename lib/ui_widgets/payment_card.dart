import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget buildPaymentCardBody() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: <Widget>[
        Image.asset(
          "assets/paypal.png",
          width: 64,
        ),
        horizontalSpace(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Paypal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            verticalSpace(),
            Text("xxxx - xxxx - xxxx - 8973")
          ],
        ))
      ],
    ),
  );
}
