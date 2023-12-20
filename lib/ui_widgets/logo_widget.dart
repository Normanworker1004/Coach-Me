import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

Widget buildWhiteLogo({
  double textSize: 64,
  double imageWidth: 59,
  double imageHeight: 68,
  Color? imageColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      boldText("Coach", color: white, size: textSize),
      rBoldText("&", color: white, size: textSize),
      Flexible(
        child: Image.asset(
          "assets/logo_solo.png",
          color: imageColor,
          width: imageWidth,
          alignment: Alignment.bottomCenter,
          height: imageHeight,
          fit: BoxFit.fitHeight,
        ),
      ),
      boldText("e", color: white, size: textSize),
    ],
  );
}

Widget buildLetsMakeItLogo({
  double textSize: 32,
  double imageWidth: 59,
  double imageHeight: 68,
  Color? imageColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      boldText("lets make it happen!", color:   Color.fromRGBO(182, 9, 27, 1),  size: textSize),
     ],
  );
}
