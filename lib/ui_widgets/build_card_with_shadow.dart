import 'package:flutter/material.dart';

Widget buildCard(Widget body, {double innerPadding = 16, color}) {
  /*
  return Card(
    margin: EdgeInsets.zero,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: EdgeInsets.all(innerPadding),
      child: Row(
        children: <Widget>[
          body,
        ],
      ),
    ),
  );
  */

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: color ?? Colors.grey.withOpacity(.2),
        blurRadius: 16,
      )
    ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.all(innerPadding),
          child: Row(
            children: <Widget>[
              body,
            ],
          ),
        ),
      ),
    ),
  );
}
