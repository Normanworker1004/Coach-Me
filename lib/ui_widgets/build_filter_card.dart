import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget buildFilterCard(text, image, {isSelected = false, width = 86.0}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    child: Card(
      color: isSelected ? blue : white,
      child: Container(
        width: width,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image, //"assets/ball.jpg",
              height: 40,
              width: 34,
              fit: BoxFit.fill,
            ),
            verticalSpace(height: 5),
            Text(
              text,
              maxLines: 1,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontFamily: App.font_name,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildFilterCardColored({
  required text,
  required image,
  bgColor,
  imageColor,
  textColor = Colors.black,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    child: Container(
      width: 110,
      height: 90,
      decoration: BoxDecoration(
        // color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.05),
            blurRadius: 4,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Card(
            color: bgColor,
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    image,
                    // height: 40,
                    width: 36,
                    fit: BoxFit.fill,
                    color: imageColor,
                  ),
                  verticalSpace(),
                  Text(
                    text,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: App.font_name,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
