import 'package:cme/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class CustomPasswordField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final onChanged;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.labelText: "Password",
  }) : super(key: key);
  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isShow = false;
  @override
  Widget build(BuildContext context) => Container(
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
                        widget.labelText,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: App.font_name,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: TextFormField(
                        onChanged: widget.onChanged,
                        controller: widget.controller,
                        obscureText: !isShow,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontFamily: App.font_name2,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Icon(FontAwesome.eye_slash,
                        size: 16, color: isShow ? blue : Colors.grey),
                  )),
              horizontalSpace(width: 8)
            ],
          ),
        ),
      );
}
