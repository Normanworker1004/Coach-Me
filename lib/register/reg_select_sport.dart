import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/final.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/show_bottom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/app.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/register/sport_level.dart';

import '../ui_widgets/sport_icon_function.dart';

// ignore: must_be_immutable
class SelectSportReg extends StatefulWidget {
  String? from;

  SelectSportReg({this.from});

  @override
  _SelectSportRegState createState() => _SelectSportRegState();
}

class _SelectSportRegState extends State<SelectSportReg> {
  int? selectedIndex;
  List<int> selections = [];
  List<BNBItem> categories = sportsList;
  var i;
  @override
  void initState() {
    super.initState();
    i = Final.getId();
    // print("++++++++++++$i++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.from);
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1), //bgGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(245, 245, 245, 1), //bgGrey,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                i == 1 ? "Steps 2/7" : "Steps 2/10",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w100),
              ),
              StepProgressIndicator(
                totalSteps: 10,
                currentStep: 2,
                size: 6.0,
                padding: 0,
                selectedColor: colorActiveProgress,
                unselectedColor: colorInActiveProgress,
                roundedEdges: Radius.circular(10),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
               //left: 16.0,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    i == 1
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: App.font_name,
                                  letterSpacing: 0.0),
                              children: <TextSpan>[
                                TextSpan(text: 'Which Sport/s do you\n'),
                                TextSpan(
                                    text: 'coach',
                                    style: TextStyle(color: colorActiveBtn)),
                                TextSpan(text: ' in? '),
                              ],
                            ),
                          )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: App.font_name,
                                    letterSpacing: 0.0),
                                children: <TextSpan>[
                                  TextSpan(text: 'Which Sport/s do you want to '),
                                  TextSpan(
                                      text: 'be ',
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'coached',
                                      style: TextStyle(color: colorActiveBtn)),
                                  TextSpan(text: ' in? '),
                                ],
                              ),
                            ),
                        ),
                    verticalSpace(height: 16),
      Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
        ),
                    child:
                    Column(
                      children: List.generate(
                        4,
                        (index) {
                          return buildCategory(
                            // selectedIndex == index,
                            selections.contains(index),

                            categories[index],
                            () {
                              setState(() {
                                if (selections.contains(index)) {
                                  selections.remove(index);
                                } else {
                                  selections.add(index);
                                  if (selections.length == 2  ) {
                                    showBottomDialogue(
                                        heightPercent: .2,
                                        context: context,
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                boldText(
                                                    "Please Note:\nChoosing multiple sports will require a paid subscription. ")
                                              ],
                                            ),
                                          ),
                                        ));
                                  }
                                }
                                selectedIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),),
                    verticalSpace(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child:Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          "Back",

                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w100,
                              fontFamily: App.font_name),
                        ),
                        ),
                        onTap: () {
                          // print("inside back");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    verticalSpace(height: 64)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 121,
                decoration: BoxDecoration(
                    color: selectedIndex == null
                        ? colorInActiveProgress
                        : colorActiveBtn,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextButton(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: selections.isEmpty
                      ? null
                      : () {
                          goToNext();
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  goToNext() async {
//Bubble sort
    for (var i = 0; i < selections.length; i++) {
      for (var j = 0; j < selections.length; j++) {
        if (selections[i] < selections[j]) {
          int t = selections[j];
          selections[j] = selections[i];
          selections[i] = t;
        }
      }
    }

    SignInDetals.selectedSports = List.generate(
        selections.length, (index) => categories[selections[index]].page);

    List<BNBItem> sportsLis = List.generate(selections.length, (index) {
      BNBItem b = categories[selections[index]];
      b.title = -1;
      return b;
    });

    Navigator.push(
        context,
        NavigatePageRoute(
            context,
            SportLevelReg(
              from: runtimeType.toString(),
              sportsList: sportsLis,
            )));
  }

  Widget buildCategory(isSelected, BNBItem item, ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.0, right: 16),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: isSelected
                      ? BoxDecoration(
                          border: Border.all(
                            color: deepRed,
                            width: 2,
                          ),
                      boxShadow: [
                        BoxShadow(color: deepRed, spreadRadius: 2)
                      ],
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item.icon,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  item.page,
                  style: TextStyle(
                    color: white,
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Visibility(
                  visible: isSelected,
                  child: Card(
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.check, color: deepRed),
                      )),
                ),
              )
            ],
          ),
          verticalSpace(height: 8),
        ],
      ),
    );
  }
}
