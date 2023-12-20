import 'package:flutter/material.dart';

Widget buildDots(bool type) {
  return type
      ? Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Color.fromRGBO(227, 185, 189, 1),
          ),
        )
      : Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(182, 9, 27, 1),
          ),
        );
}

Widget dot(int index) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => Padding(
          padding: const EdgeInsets.only(left: 9.0),
          child: buildDots(index != i),
        ),
      ));
}

Widget dot2(int index) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(left: 9.0),
          child: buildDots(index != i),
        ),
      ));
}
