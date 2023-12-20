import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget iconTitle(String icon, title, color, {String? fontName}) {
  return Row(
    children: <Widget>[
      Image.asset(
        icon,
        width: 10,
        height: 10,
        color: color,
      ),
      horizontalSpace(width: 4),
      Text(
        title,
        style: TextStyle(
          color: color,
          fontFamily: "$title".contains("4") ? App.font_name2 : App.font_name,
          fontSize: "$title".contains("4") ? 9 : 10,
          fontWeight: FontWeight.w100,
        ),
      ),
    ],
  );
}

Widget iconTitleExpanded(String icon, title, color, {String? fontName}) {
  return Row(
    children: <Widget>[
      Image.asset(
        icon,
        width: 10,
        height: 10,
        color: color,
      ),
      horizontalSpace(width: 4),
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(
            color: color,
            fontFamily: "$title".contains("4") ? App.font_name2 : App.font_name,
            fontSize: "$title".contains("4") ? 9 : 10,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    ],
  );
}

Widget iconTitle2(String icon, title, color, {String? fontName}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        icon,
        width: 12,
        height: 12,
        color: color,
      ),
      horizontalSpace(width: 4),
      Flexible(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: "$title".contains("4") ? 14 : 16,
            fontWeight: FontWeight.w100,
            fontFamily: "$title".contains("4") ? App.font_name2 : App.font_name,
          ),
        ),
      ),
    ],
  );
}
