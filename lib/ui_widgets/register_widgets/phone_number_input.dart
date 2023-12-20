import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:io';

import 'package:intl_phone_field/phone_number.dart';

class PhonePicker extends StatefulWidget {
  final Function onPhoneNumberChange;
  final String? initialPhoneNumber;
  final bool addPadding;
  final String? label ;
  Country? country;

  PhonePicker({required this.onPhoneNumberChange, this.initialPhoneNumber,  this.addPadding = true, this.label, this.country = null });

  @override
  State<PhonePicker> createState() => _PhonePickerState();


}

class _PhonePickerState extends State<PhonePicker> {

  @override
  Widget build(BuildContext context) {
    print("rebuild tel");
   // const _initialCountryCode = 'US';
    // var _country =   countries.firstWhere((element) => element.code == _initialCountryCode);
    return Container(
      padding: widget.addPadding ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
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
                widget.label ?? "Phone Number",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child:
              IntlPhoneField(
                decoration: InputDecoration(border: InputBorder.none),
                initialCountryCode:  getCurrentCountryCode(),
                initialValue:widget.initialPhoneNumber ,
                textAlignVertical: TextAlignVertical.center,
                // disableLengthCheck:true,
                style:TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: App.font_name,
                    color: Colors.black) ,
                onCountryChanged: (country) {
                  print("Contry changed... ${country.code}");
                  widget.country = country;
                } ,
                // decoration: InputDecoration(border: InputBorder.none),
                onChanged: (PhoneNumber phoneNumber) {
                  print("numberrr${phoneNumber}");
                  widget.country = getCurrentCountryWithCode(phoneNumber.countryISOCode) ;
                  if (phoneNumber.number.length >= ( widget.country?.minLength ?? 0) &&
                      phoneNumber.number.length <= ( widget.country?.maxLength ?? -1) ) {
                    // Run anything here
                    widget.onPhoneNumberChange(phoneNumber.number,phoneNumber.completeNumber, phoneNumber.countryISOCode ) ;
                  }else{
                    widget.onPhoneNumberChange("","", "");
                  }
                } ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget phoneNumberInput(onPhoneNumberChange,  { String? initialPhoneNumber   , bool addPadding = true, String? label}) =>
    PhonePicker(
      onPhoneNumberChange: onPhoneNumberChange,
        initialPhoneNumber:initialPhoneNumber,
        addPadding:addPadding,
        label:label);


Country getCurrentCountryWithCode(String code) {
  return countries.where((element) => element.code == code).first;
}
String getCurrentCountryCode(){
  final String defaultLocale = Platform.localeName; // Returns locale string in the form 'en_US'
//  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales; // Returns the list of locales that user defined in the system settings.
 // final List<Locale> systemLocales = window.locales;
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales; // Returns the list of locales that user defined in the system settings.
  print(systemLocales.first.countryCode );
  return systemLocales.first.countryCode ?? "GB" ;
}