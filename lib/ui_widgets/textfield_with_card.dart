import 'package:flutter/material.dart';

Widget buildCardedTextField({
  TextEditingController? controller,
  String? hintText,
  color,
  textColor: Colors.grey,
  onChange,
  onSubmitted,
  focusNode,
  onTap,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Card(
      color: color,
      margin: EdgeInsets.all(0),
      // shape: StadiumBorder(),
      child: TextField(
        onTap: onTap,
        focusNode: focusNode,
        onChanged: onChange,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: textColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor,
          ),
        ),
      ),
    ),
  );
}

Widget buildSearchTextField({
  TextEditingController? controller,
  String? hintText,
  color,
  textColor = Colors.grey,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Card(
      color: color,
      margin: EdgeInsets.all(0),
      // shape: StadiumBorder(),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: textColor),
          // alignLabelWithHint: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor,
          ),
        ),
      ),
    ),
  );
}
