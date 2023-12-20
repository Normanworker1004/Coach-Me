import 'package:flutter/material.dart';

Widget filterIcon({color = Colors.white}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        "assets/filter_white.png",
        width: 20,
        color: color,
      ),
    ),
  );
}
