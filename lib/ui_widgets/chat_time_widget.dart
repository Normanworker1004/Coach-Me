import 'package:flutter/material.dart';

class ChatDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Today, 00:00pm",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
}
