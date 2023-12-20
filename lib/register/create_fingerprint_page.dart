import 'package:cme/app.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class FingerPrintPage extends StatefulWidget {
  @override
  _FingerPrintPageState createState() => _FingerPrintPageState();
}

class _FingerPrintPageState extends State<FingerPrintPage> {
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      context: context,
      body: buildBody(context),
      title: "Unlock App",
    );
  }

  Widget buildBody(BuildContext context) {
    return PageView(
      children: [
        Column(
          children: [
            boldText("Please use Finger ID to unlock", size: 20),
            verticalSpace(),
            lightText(
              "Place your finger on figerprint sensor",
              color: Colors.grey,
            ),
            verticalSpace(),
            Image.asset(
              "assets/f1.png",
              height: 200,
              width: 200,
            ),
            Text(
              "0%",
              style: TextStyle(
                  fontFamily: "ROBOTO",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            lightText("Scanning", color: Colors.grey),
          ],
        ),
        Column(
          children: [
            boldText("Please use Finger ID to unlock", size: 20),
            verticalSpace(),
            lightText(
              "Place your finger on figerprint sensor",
              color: Colors.grey,
            ),
            verticalSpace(),
            Image.asset(
              "assets/f2.png",
              height: 200,
              width: 200,
            ),
            Text(
              "100%",
              style: TextStyle(
                  fontFamily: "ROBOTO",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            lightText("Scanning", color: Colors.grey),
          ],
        ),
        Column(
          children: [
            boldText("Please use Face ID to unlock", size: 20),
            verticalSpace(),
            Text(
              "Place put face in front of camera to unlock app",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.grey.withOpacity(.5),
                fontSize: 18,
              ),
              // color: Colors.grey,
            ),
            verticalSpace(),
            Image.asset(
              "assets/f3.png",
              height: 200,
              width: 200,
            ),
            Text(
              "100%",
              style: TextStyle(
                  fontFamily: "ROBOTO",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            lightText("Scanning", color: Colors.grey),
          ],
        ),
      ],
    );
  }
}
