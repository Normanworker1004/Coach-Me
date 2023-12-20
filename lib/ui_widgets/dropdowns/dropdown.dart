import 'package:cme/app.dart';
import 'package:flutter/material.dart';

Widget buildDropDown(label, selectedTime, List list, onChanged,
    {labelColor = Colors.white}) {
  return Row(
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 16, color: labelColor, fontWeight: FontWeight.w500),
      ),
      Spacer(),
      DropdownButton(
          icon: null,
          underline: SizedBox(),
          hint: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              selectedTime,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: white,
              ),
            ),
          ),
          value: selectedTime,
          items: List.generate(list.length, (index) {
            var v = list[index];
            return DropdownMenuItem(
              value: v,
              child: Text(
                v,
                style: selectedTime == v
                    ? Style.selectTimeTextStyle2
                    : Style.selectTimeTextStyle,
              ),
            );
          }),
          onChanged: onChanged

          // (v) {
          //   setState(() {
          //     selectedTime = v;
          //   });
          // }

          )
    ],
  );
}

Widget buildDropDownNoLabel(selectedTime, List list, onChanged,
    {labelColor = Colors.white}) {
  return ButtonTheme(
    alignedDropdown: true,
    child: DropdownButton(
        icon: null,
        // itemHeight: 20,
        isExpanded: true,
        elevation: 0,
        underline: SizedBox(height: 0, width: 0),
        hint: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Text(
            selectedTime,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: white,
            ),
          ),
        ),
        value: selectedTime,
        items: List.generate(list.length, (index) {
          var v = list[index];
          return DropdownMenuItem(
            value: v,
            child: Text(
              v,
              style: selectedTime == v
                  ? Style.selectTimeTextStyle
                  : Style.selectTimeTextStyle,
            ),
          );
        }),
        onChanged: onChanged

        // (v) {
        //   setState(() {
        //     selectedTime = v;
        //   });
        // }

        ),
  );
}
