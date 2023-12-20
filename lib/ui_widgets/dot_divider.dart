import 'package:flutter/material.dart';

Widget  buildDivider() {
    return Text(
      "......................................."
      ".............................................."
      "............................................."
      "..............................................."
      ".................................................",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey, letterSpacing: 1.5),
    );
  }