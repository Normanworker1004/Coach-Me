import 'package:cme/app.dart';
import 'package:cme/network/player/challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'dart:math' as m;

// ignore: must_be_immutable
class BlockChallengeFromDropDown extends StatefulWidget {
  String? token;
  final textColor;
  final bgColor;
  final bgColor2;
  String selectedItem;
  final List<String> item;
  final List<int> currentlyBlocked;

  final onItemChanged;

  BlockChallengeFromDropDown({
    Key? key,
    this.textColor,
    this.selectedItem: "Select Level",
    this.bgColor: Colors.white,
    this.bgColor2: Colors.white,
    this.onItemChanged,
    required this.currentlyBlocked,
    required this.token,
    this.item: const [
      "Grassroots",
      "Semi Pro",
      "Professional",
      "Expert",
    ],
  }) : super(key: key);
  @override
  _BlockChallengeFromDropDownState createState() =>
      _BlockChallengeFromDropDownState();
}

class _BlockChallengeFromDropDownState
    extends State<BlockChallengeFromDropDown> {
  late List<String> selected;
  List<int>? currentlyBlocked;
  var catList = [
    "Grassroots",
    "Semi Pro",
    "Professional",
    "Expert",
  ];

  int getLevelIndex(String c) {
    for (var i = 0; i < catList.length; i++) {
      if ("$c" == "${catList[i]}") {
        return i;
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    currentlyBlocked = widget.currentlyBlocked;
    selected = List.generate(
        currentlyBlocked!.length, (index) => catList[currentlyBlocked![index]]);
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
              /*Checkbox(
                value: selected.contains(value), //value == widget.selectedItem,
                onChanged: (v) {
                  print("...new val $v");
                  setState(() {
                    if (v) {
                      print("add...new val $v");
                      selected.add(value);
                      currentlyBlocked.add(getLevelIndex(value));
                    } else {
                      print("add...new val $v");
                      selected.remove(value);
                      currentlyBlocked.remove(getLevelIndex(value));
                    }
                  });
                },
              ),*/
              selected.contains(value)
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
              horizontalSpace(),
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
          if (!selected.contains("$value")) {
            print("add...new val v");
            selected.add(value);
            currentlyBlocked!.add(getLevelIndex(value));
          } else {
            print("remove...new val ");
            selected.remove(value);
            currentlyBlocked!.remove(getLevelIndex(value));
          }
        });
        // setState(() {
        //   // selected = value;
        // });

        // Action when new item is selected
        updateBlockChallengeFrom(
          widget.token,
          blocList: currentlyBlocked,
        );
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
