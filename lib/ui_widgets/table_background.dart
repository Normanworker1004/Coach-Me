import 'package:flutter/material.dart';

class TableBackGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/table_bg.png",
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.cover,
    );
  }
}
