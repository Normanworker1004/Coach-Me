import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'dart:math' as m;

import 'package:menu_button/menu_button.dart';

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
          // border: Border.all(color: widget.borderColor),
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }
}

class CustomBioDropDown extends StatefulWidget {
  final textColor;
  final bgColor;
  final borderColor;
  final bgColor2;
  final bool hideIcon;
  String selectedItem;
  final List<String> item;
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
                  child: rBoldText("${widget.selectedItem}".toUpperCase(),
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
      onItemSelected: widget.onItemChanged != null
          ? widget.onItemChanged
          : (dynamic value) {
              setState(() {
                widget.selectedItem = value;
              });
            },
      decoration: BoxDecoration(
          // border: Border.all(color: widget.borderColor),
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }
}

// ignore: must_be_immutable
class CustomSeasonsDropDown extends StatefulWidget {
  final textColor;
  final bgColor;
  final borderColor;
  final bgColor2;
  final bool hideIcon;
  String selectedItem;
  final List<String?> item;
  final padding;
  final Function? onSelection, onAddNewSeason;
  final IconData? icon;

  CustomSeasonsDropDown({
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
      "All",
      "Season 1",
      "Season 2",
      "Season 3",
    ],
    this.selectedItem: "All",
    this.textColor: const Color.fromRGBO(25, 87, 234, 1),
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
    this.onSelection,
    this.onAddNewSeason,
    this.icon,
  }) : super(key: key);
  @override
  _CustomSeasonsDropDownState createState() => _CustomSeasonsDropDownState();
}

class _CustomSeasonsDropDownState extends State<CustomSeasonsDropDown> {
  @override
  Widget build(BuildContext context) {
    Widget button() => Container(
      child: SizedBox(
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
                            fit: BoxFit.scaleDown,
                            child: Icon(
                              widget.icon == null
                                  ? CupertinoIcons.forward
                                  : widget.icon,
                              color: widget.textColor,
                              size: 12,
                            ))),
                  ),
                ],
              ),
            ),
          ),

    );

    return MenuButton(
      child: button(),
      items: widget.item ,
      topDivider: true,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (dynamic value) => Container(
        color: widget.bgColor2,
        width: 83,
        height: 40,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: buildItem(value),
      ),
      toggledChild: Container(
        color: widget.bgColor2,
        child: button(),
      ),
      divider: Container(height: 1, color: widget.borderColor),
      onItemSelected: (dynamic value) => widget.onSelection!(value),
      // onItemSelected: (value) {
      //   widget.onSelection(value);
      //   // setState(() {
      //   //   widget.selectedItem = value;
      //   // });
      //   // if (widget.onSelection != null) widget.onSelection(value);
      //   // Action when new item is selected
      // },
      decoration: BoxDecoration(
          // border: Border.all(color: widget.borderColor),
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }

  Widget buildItem(value) {
    if (value == widget.item.last) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rLightText(value, color: widget.textColor),
          GestureDetector(
            onTap: () {
              widget.onAddNewSeason!();
            }, // widget.onAddNewSeason,
            child: Container(
              width: 36.0,
              height: 20.0,
              //color: Colors.red,
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                CupertinoIcons.add,
                color: Colors.black,
                size: 12,
              ),
            ),
          )
        ],
      );
    } else
      return Row(
        children: [
          rLightText(value, color: widget.textColor),
        ],
      );
  }
}

// ignore: must_be_immutable
class CustomDropDownWithFeedBack extends StatefulWidget {
  final textColor;
  final bgColor;
  final borderColor;
  final bgColor2;
  final bool hideIcon;
  String? selectedItem;
  final List<String> item;
  final padding;
  final Function? onSelection, onAddNewSeason;
  final IconData? icon;

  CustomDropDownWithFeedBack({
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
      "All",
      "Season 1",
      "Season 2",
      "Season 3",
    ],
    this.selectedItem: "All",
    this.textColor: const Color.fromRGBO(25, 87, 234, 1),
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
    this.onSelection,
    this.onAddNewSeason,
    this.icon,
  }) : super(key: key);
  @override
  _CustomDropDownWithFeedBackState createState() =>
      _CustomDropDownWithFeedBackState();
}

class _CustomDropDownWithFeedBackState
    extends State<CustomDropDownWithFeedBack> {
  @override
  Widget build(BuildContext context) {
    Widget button() => Container(
          width: 140,
          height: 40,
      decoration: BoxDecoration(
        border: Border.all(
            color:widget.borderColor,
            width: 1.0,
            style: BorderStyle.solid), //Border.all
         borderRadius: BorderRadius.all(
          Radius.circular(5),
        ), //BorderRadius.all
      ),
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
                          child: Icon(
                            widget.icon == null
                                ? CupertinoIcons.forward
                                : widget.icon,
                            color: widget.textColor,
                            size: 12,
                          ))),
                ),
              ],
            ),
          ),
        );

    return MenuButton(
      child: button(),
      items: widget.item,
      topDivider: false,
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
        ),
      ),
      toggledChild: Container(
        color: widget.bgColor2,
        child: button(),
      ),
      // divider: Container(height: 1, color: widget.borderColor),
      onItemSelected: (dynamic value) => widget.onSelection!(value),
      // onItemSelected: (value) {
      //   widget.onSelection(value);
      //   // setState(() {
      //   //   widget.selectedItem = value;
      //   // });
      //   // if (widget.onSelection != null) widget.onSelection(value);
      //   // Action when new item is selected
      // },
      decoration: BoxDecoration(
          // border: Border.all(color: widget.borderColor),
          // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }

  Widget buildItem(value) {
    if (value == widget.item.last) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rLightText(value, color: widget.textColor),
          GestureDetector(
            onTap: () {
              widget.onAddNewSeason;
            }, // widget.onAddNewSeason,
            child: Icon(
              FontAwesome.plus,
              color: Colors.white,
            ),
          )
        ],
      );
    } else
      return Row(
        children: [
          rLightText(value, color: widget.textColor),
        ],
      );
  }
}
