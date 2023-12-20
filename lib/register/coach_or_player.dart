import 'package:cme/model/final.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/app.dart';
import 'package:cme/register/reg_select_sport.dart';
import 'package:cme/utils/navigate_effect.dart';

// ignore: must_be_immutable
class CoachOrPlayer extends StatefulWidget {
  String? from;
  CoachOrPlayer({this.from});

  @override
  _CoachOrPlayerState createState() => _CoachOrPlayerState();
}

class _CoachOrPlayerState extends State<CoachOrPlayer> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    // print("Inside coach page  widget.from");
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
                "Steps 1/10",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w100),
              ),
              StepProgressIndicator(
                totalSteps: 10,
                currentStep: 1,
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
      body:
    SafeArea(
        child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: App.font_name,
                          letterSpacing: 0.0),
                      children: <TextSpan>[
                        TextSpan(text: 'Are you a '),
                        TextSpan(
                            text: 'player ',
                            style: TextStyle(color: colorActiveBtn)),
                        TextSpan(text: 'or '),
                        TextSpan(
                            text: 'coach ?',
                            style: TextStyle(color: colorActiveBtn)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Final.setId(0);
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildTypeCard(
                              "Player",
                              "assets/type_player.png",
                              selectedIndex == 0
                                  ? Color.fromRGBO(226, 3, 3, 1)
                                  : Color.fromRGBO(182, 9, 27, 1)),
                        ),
                        Positioned(
                          right: 0,
                          child: Visibility(
                            visible: selectedIndex == 0,
                            child: Card(
                              margin: EdgeInsets.all(0),
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.check,
                                  color: deepRed,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Final.setId(1);
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildTypeCard(
                              "Coach",
                              "assets/type_coach.png",
                              selectedIndex == 1
                                  ? blue
                                  : Color.fromRGBO(13, 89, 179,
                                      1) //.withOpacity(.7), //rgba(25, 87, 234, 1)
                              ),
                        ),
                        Positioned(
                          right: 0,
                          child: Visibility(
                            visible: selectedIndex == 1,
                            child: Card(
                              margin: EdgeInsets.all(0),
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.check,
                                  color: blue,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpace(height: 72),
                ],
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
                    color:
                        selectedIndex == null ? colorDisable : colorActiveBtn,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextButton(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          goToNext();
                        },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 24,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                // print("inside inkwell -> back");
              },
              child:Text(
                "Back",

                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.w100,
                    fontFamily: App.font_name),
              )
            ),
          ),
        ],
      ),
    ));
  }

  goToNext() async {
    await Navigator.push(
        context,
        NavigatePageRoute(
            context, SelectSportReg(from: runtimeType.toString())));
  }

  Widget buildTypeCard(String text, String image, Color color) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          // fit: BoxFit.contain,
          image: AssetImage(image),
          // scale: 4
        ),
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16),
        child: boldText(text, color: white, size: 28),
      ),
    );
  }
}
