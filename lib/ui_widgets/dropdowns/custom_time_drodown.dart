import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'dart:math' as m;

// ignore: must_be_immutable
class CustomTimeDropDown extends StatefulWidget {
  final textColor;
  final bgColor;
  final borderColor;
  final bgColor2;
  final bool hideIcon;
  String selectedItem;
  final List<String> item;
  final padding;

  CustomTimeDropDown({
    Key? key,
    this.hideIcon: false,
    this.padding: const EdgeInsets.only(
      left: 16,
      right: 11,
      top: 8,
      bottom: 8,
    ),
    this.borderColor: Colors.grey,
    this.item: const [
      "March 13, 2020",
      "March 14, 2020",
      "March 15, 2020",
    ],
    this.selectedItem: "March 13, 2020",
    this.textColor: const Color.fromRGBO(25, 87, 234, 1),
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
  }) : super(key: key);
  @override
  _CustomTimeDropDownState createState() => _CustomTimeDropDownState();
}

class _CustomTimeDropDownState extends State<CustomTimeDropDown> {
  @override
  Widget build(BuildContext context) {
    Widget button() => SizedBox(
          width: 140,
          height: 40,
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: rBoldText(widget.selectedItem,
                      color: widget.textColor, size: 12),
                ),
                Visibility(
                  visible: !widget.hideIcon,
                  child: SizedBox(
                      width: 12,
                      height: 17,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Transform.rotate(
                            angle: m.pi * .5,
                            child: Icon(
                              CupertinoIcons.forward,
                              color: widget.textColor,
                            ),
                          ))),
                ),
              ],
            ),
          ),
        );

    return MenuButton(
      child: button(),
      items: widget.item,
      topDivider: true,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (dynamic value) => Container(
          color: widget.bgColor2,
          width: 83,
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              rLightText(value, color: widget.textColor),
            ],
          )),
      toggledChild: Container(
        color: widget.bgColor2,
        child: button(),
      ),
      divider: Container(height: 1, color: widget.borderColor),
      onItemSelected: (dynamic value) {
        setState(() {
          widget.selectedItem = value;
        });
        // Action when new item is selected
      },
      decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }
}

// ignore: must_be_immutable
class CustomBioDropDown extends StatefulWidget {
  final textColor;
  final bgColor;
  final borderColor;
  final bgColor2;
  final bool hideIcon;
  String? selectedItem;
  final List<String?> item;
  final padding;
  final onItemChanged;

  CustomBioDropDown({
    Key? key,
    this.hideIcon: false,
    this.padding: const EdgeInsets.only(
      left: 16,
      right: 11,
      top: 8,
      bottom: 8,
    ),
    this.borderColor: Colors.grey,
    this.item: const [
      "March 13, 2020",
      "March 14, 2020",
      "March 15, 2020",
    ],
    this.selectedItem: "March 13, 2020",
    this.textColor: const Color.fromRGBO(25, 87, 234, 1),
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
    this.onItemChanged,
  }) : super(key: key);
  @override
  __CustomTimeDropDownState createState() => __CustomTimeDropDownState();
}

class __CustomTimeDropDownState extends State<CustomBioDropDown> {
  String? selected;
  @override
  void initState() {
    super.initState();
    selected = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    Widget button() => SizedBox(
          width: 140,
          height: 40,
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: rBoldText("$selected".toUpperCase(),
                      color: widget.textColor, size: 12),
                ),
                Visibility(
                  visible: !widget.hideIcon,
                  child: SizedBox(
                      width: 12,
                      height: 17,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Transform.rotate(
                            angle: m.pi * .5,
                            child: Icon(
                              CupertinoIcons.forward,
                              color: widget.textColor,
                            ),
                          ))),
                ),
              ],
            ),
          ),
        );

    return MenuButton(
      menuButtonBackgroundColor: widget.bgColor2,
      child: button(),
      items: widget.item,
      topDivider: true,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (dynamic value) => Container(
          color: widget.bgColor2,
          width: 83,
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                  child: rLightText("$value".toUpperCase(),
                      color: widget.textColor)),
            ],
          )),
      toggledChild: Container(
        color: widget.bgColor2,
        child: button(),
      ),
      divider: Container(height: 1, color: widget.borderColor),
      onItemSelected: (dynamic value) {
        widget.onItemChanged(value);
        setState(() {
          selected = value;
        });
      },
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: widget.borderColor, // Set border color
              width: 1.0),   // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)), // Set rounded corner radius
       ),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }
}
