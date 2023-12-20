import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget buildInputField(
  text,
  controller, {
  inputType: TextInputType.text,
  isPassword: false,
  onChanged,
  inputTextWeight = FontWeight.w500,
  inputTextColor = const Color(0xCC555555),
}) =>
    Container(
      padding: EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: TextFormField(
                onChanged: onChanged,
                obscureText: isPassword,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                keyboardType: inputType,
                style: TextStyle(
                    fontWeight: inputTextWeight,
                    fontFamily: App.font_name,
                    color: inputTextColor),
              ),
            )
          ],
        ),
      ),
    );

Widget buildRegisterInputWidget({required Widget childWidget, required String topLabel}){
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Material(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              topLabel,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: App.font_name,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child:childWidget,
          )
        ],
      ),
    ),
  );
}


Widget buildRegisterInputField(
        {required TextEditingController controller,
        required String topLabel}){

  var childWidget  = TextFormField(
    controller: controller,
    decoration: InputDecoration(
      border: InputBorder.none,
    ),
    keyboardType: TextInputType.text,
    style: TextStyle(
        fontWeight: FontWeight.w100,
        fontFamily: App.font_name2,
        color: Colors.black),
  );

  return buildRegisterInputWidget(childWidget: childWidget, topLabel: topLabel);
}