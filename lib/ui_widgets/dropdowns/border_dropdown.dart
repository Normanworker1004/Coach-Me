import 'package:cme/app.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'dart:math' as m;

Widget borderDropDown({
  title = "Football",
  double width = 99,
  double height = 25,
  color = const Color.fromRGBO(25, 87, 234, 1),
  textColor = const Color.fromRGBO(25, 87, 234, 1),
}) {
  return MenuButton(
    onItemSelected: (dynamic c) {},

    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
        child: Row(
          children: [
            boldText(title, color: textColor, size: 12),
            Spacer(),
            Transform.rotate(
              angle: m.pi * .5,
              child: Icon(
                CupertinoIcons.forward,
                color: textColor,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    ),
    items: ["Football", "Football1", "Football3", "Football2"],
    itemBuilder: (dynamic value) => Container(
        width: 83,
        height: 40,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(value)), //
  );
}

// ignore: must_be_immutable
class CustomDropDown extends StatefulWidget {
  final textColor;
  final bgColor;
  final bgColor2;
  String selectedItem;
  final List<String> item;

  final onItemChanged;

  CustomDropDown({
    Key? key,
    this.textColor,
    this.selectedItem: "Select Level",
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
    this.onItemChanged,
    this.item: const [
      "Grassroots",
      "Semi Pro",
      "Professional",
      "Expert",
    ],
  }) : super(key: key);
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String selected;
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
            padding: const EdgeInsets.only(left: 16, right: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.selectedItem,
                    style: TextStyle(
                        color: widget
                            .textColor //Color.fromRGBO(229, 229, 229, 1) //#E5E5E5
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                    width: 12,
                    height: 17,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: Transform.rotate(
                          angle: m.pi * .5,
                          child: Icon(
                            CupertinoIcons.forward,
                            color: Colors.grey,
                          ),
                        ))),
              ],
            ),
          ),
        );

    return MenuButton(
      child: button(),
      items: widget.item,
      topDivider: true,
      popupHeight: 200,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (dynamic value) => Container(
          color: widget.bgColor2,
          width: 83,
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              /* Checkbox(value: value == widget.selectedItem, onChanged: (v) {}),
              */
              value == widget.selectedItem
                  ? Icon(
                      Icons.check_box,
                      color: blue,
                    )
                  : Container(
                      child: Center(
                        child: Visibility(
                          visible: selected.contains(value),
                          child: Icon(
                            Icons.check_box,
                            color: blue,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey,
                        ),
                      ),
                    ),
              Expanded(child: Text(value)),
            ],
          )),
      toggledChild: Container(
        color: widget.bgColor2,
        child: button(),
      ),
      divider: Container(
        height: 1,
        color: Colors.grey,
      ),
      onItemSelected: (dynamic value) {
        widget.onItemChanged(value);
        setState(() {
          selected = value;
        });
        // Action when new item is selected
      },
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.bgColor),
      onMenuButtonToggle: (isToggle) {
        // print(isToggle);
      },
    );
  }
}
