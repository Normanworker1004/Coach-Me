import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget boldText(
  text, {
  double size = 16,
  Color? color = Colors.black,
  TextAlign textAlign = TextAlign.left,
  FontWeight weight = FontWeight.bold,
  TextOverflow textOverflow = TextOverflow.visible
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: textOverflow,
    style: TextStyle(
      fontWeight: weight,
      fontSize: size,
      // fontFamily: App.font_name,
      fontFamily: "$text".contains("4") ? App.font_name2 : App.font_name,

      color: color,
    ),
  );
}

Widget rBoldText(text, {double size = 16, Color color = Colors.black}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size,
      fontFamily: App.font_name2,
      color: color,
    ),
  );
}

Widget mediumText(
  text, {
  double size = 16,
  Color color = Colors.black,
  TextAlign? textAlign,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size,
      // fontFamily: App.font_name,
      fontFamily: "$text".contains("4") ? App.font_name2 : App.font_name,

      color: color,
    ),
  );
}

Widget rMediumText(
  text, {
  double size = 16,
  Color color = Colors.black,
  maxLines,
  textAlign,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size,
      fontFamily: App.font_name2,
      color: color,
    ),
  );
}

Widget lightText(
  text, {
  double size = 12,
  Color? color = Colors.black,
  maxLines,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: size,
      color: color,
      // fontFamily: App.font_name,
      fontFamily: "$text".contains("4") ? App.font_name2 : App.font_name,
    ),
  );
}

Widget rLightText(
  text, {
  double size = 12,
  Color color = Colors.black,
  maxLines,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: size,
      color: color,
      fontFamily: App.font_name2,
    ),
  );
}

Widget buildColumnTexts(String t1, String t2) {
  return Column(
    children: <Widget>[
      Text(
        t1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "$t1".contains("4") ? App.font_name2 : App.font_name,
        ),
      ),
      Text(
        t2,
        style: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 12,
          fontFamily: "$t2".contains("4") ? App.font_name2 : App.font_name,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

Widget priceText(price) {
  var style1 =
      TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w100);
  var style2 = TextStyle(
    fontFamily: "$price".contains("4") ? App.font_name2 : App.font_name,
    fontSize: 16,
    color: Color.fromRGBO(182, 9, 27, 1),
  );
  return Column(
    children: <Widget>[
      Text(
        "Starting at",
        style: style1,
      ),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(
            "£$price",
            style: style2,
          ),
          Text(
            " / session",
            style: style1,
          )
        ],
      )
    ],
  );
}

Widget fixtureTitleText(String text,
    {double size = 16, Color color = Colors.black}) {
  if (text.length > 5) text = text.substring(0, 4) + '.';
  return Text(
    text.toUpperCase(),
    textAlign: TextAlign.center,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size,
      // fontFamily: App.font_name,
      fontFamily: "$text".contains("4") ? App.font_name2 : App.font_name,

      color: color,
    ),
  );
}
