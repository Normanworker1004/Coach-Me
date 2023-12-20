import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as datePicker;
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

Widget customDateInput(
        {required context,
        onChanged,
        required onConfirmed,
        required value}) =>
    GestureDetector(
      onTap: () {
        datePicker.DatePicker.showDatePicker(
          context,
          theme: datePicker.DatePickerTheme(
            doneStyle: TextStyle(
              color: blue,
            ),
          ),
          showTitleActions: true,
          onChanged: onChanged,
          onConfirm: onConfirmed,
          currentTime: DateTime.now().subtract(Duration(days: 18 * 365)),
        );
      },
      child: Container(
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: Text(
                        "Date of Birth",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: App.font_name,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 16),
                      child: Text(value,
                          style: TextStyle(
                            fontFamily: App.font_name,
                            fontWeight: FontWeight.w500,
                          )),
                    )
                  ],
                ),
              ),
              Icon(
                FontAwesome.calendar,
                size: 16,
                color: normalBlue,
              ),
              horizontalSpace(width: 16),
            ],
          ),
        ),
      ),
    );
