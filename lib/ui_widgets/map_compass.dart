import 'package:flutter/material.dart';

Widget compassIcon({color: const Color.fromRGBO(182, 9, 27, 1)}) {
  return Image.asset(
    "assets/compass.png",
    fit: BoxFit.fill,
    color: color,
    height: 20,
    width: 20,
  );
}
