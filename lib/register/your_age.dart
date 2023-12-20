// import 'package:cme/register/create_ac_guardian.dart';
import 'package:cme/register/create_new_account.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';

import 'need_gardian.dart';


// ignore: must_be_immutable
class YourAgeReg extends StatefulWidget {
  String? from;

  YourAgeReg({this.from});
  @override
  _YourAgeRegState createState() => _YourAgeRegState();
}

class _YourAgeRegState extends State<YourAgeReg> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
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
                "Steps 4/10",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ROBOTO",
                    fontSize: 9,
                    fontWeight: FontWeight.w100),
              ),
              StepProgressIndicator(
                totalSteps: 10,
                currentStep: 4,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                          fontFamily: App.font_name,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'What\'s your '),
                          TextSpan(
                              text: 'age',
                              style: TextStyle(color: colorActiveBtn)),
                          TextSpan(text: '? '),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildTypeCard(
                              "I'm over 13 years old.",
                              "assets/b16.png",
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
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildTypeCard(
                              "I'm under 13 years old.",
                              "assets/type_player.png",
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
                                  color: deepRed,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            // right: 0,
            left: 16,
            child: InkWell(
              child: Text(
                "Back",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.w100,
                    fontFamily: App.font_name),
              ),
              onTap: () {
                // print("inside back");
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            left: 0,
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
          )
        ],
      ),
    );
  }

  goToNext() async {

    if(selectedIndex == 1 ){
      pushRoute(
          context,
          NeedGardian( )
      );
    }else {
      pushRoute(
          context,
          CreateNewAct(
            needGuardian: selectedIndex != 0,
          ));
    }
  }

  Widget buildTypeCard(String text, String image, Color color) {
    return Container(
      width: double.infinity,
      height: 220,

      decoration: BoxDecoration(
        // image: DecorationImage(
        //   alignment: Alignment.bottomRight,
        //   // fit: BoxFit.contain,
        //   image: AssetImage(image),
        //   // scale: 4
        // ),
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child:boldText(text, color: white, size: 24),

      ),
    );
  }
}
