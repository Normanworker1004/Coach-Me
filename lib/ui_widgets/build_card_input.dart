import 'package:cme/app.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:flutter/material.dart';

Widget buildInputField(
  String title, {
  bool hideTitle: false,
  TextEditingController? controller,
  int maxLines: 1,
  prefix,
  bool numbersOnly = false
}) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: !hideTitle,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              // verticalSpace(height:4 ),
              TextField(
                maxLines: maxLines,
                controller: controller,
                keyboardType:  numbersOnly ? TextInputType.number : null,
                style: TextStyle(fontFamily: App.font_name2),
                decoration: InputDecoration(
                  prefix: prefix,
                  border: InputBorder.none,
                  hintText: title,
                ),
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}
