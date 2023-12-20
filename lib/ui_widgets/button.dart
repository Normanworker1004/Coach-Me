import 'package:flutter/material.dart';

Widget proceedButton(
    {isLoading = false,
    required String text,
    required onPressed,
    color = const Color.fromRGBO(182, 9, 27, 1)}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(color: Colors.white),
        primary: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isLoading
                ? CircularProgressIndicator()
                : Text(text,
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}

Widget borderProceedButton(
    {required text, required onPressed, required color}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: color,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
