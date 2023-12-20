import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/final.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/register/create_new_account.dart';
import 'package:cme/register/your_age.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';

// ignore: must_be_immutable
class SportLevelReg extends StatefulWidget {
  String? from;
  final List<BNBItem> sportsList;

  SportLevelReg({this.from, required this.sportsList});

  @override
  _SportLevelRegState createState() => _SportLevelRegState();
}

class _SportLevelRegState extends State<SportLevelReg> {
  int? selectedIndex;

  List<BNBItem> sportsList = [];
  List<BNBItem> list = [];

  List<BNBItem> player = [
    BNBItem(
      "Professional",
      "assets/level1.png",
      page: "Would train 5 days a week",
    ),
    BNBItem(
      "Semi professional",
      "assets/level2.png",
      page: "Would train 3 days a week",
    ),
    BNBItem(
      "Grass roots",
      "assets/level3.png",
      page: "Would train 1 days a week",
    ),
    BNBItem(
      "Keep it Fun",
      "assets/level4.png",
      page: "Up to you",
    ),
  ];

  List<BNBItem> coach = [
    BNBItem(
      "Expert",
      "assets/badge4.png",
      page: "Train at your own pace",
      height:
          "High level qualifications/ High level experience as a COACH i.e. 10 years",
    ),
    BNBItem(
      "Professional",
      "assets/badge3.png",
      page: "1 day a week +",
      height:
          "Advanced level qualifications or coaching/playing experience i.e. 5 years+",
    ),
    BNBItem(
      "Intermediate",
      "assets/badge2.png",
      page: "3 days a week+",
      height:
          "General level qualification or coaching/playing experience i.e. 2 years+",
    ),
    BNBItem(
      "Beginner",
      "assets/badge1.png",
      page: "5 days a week+",
      height:
          "Entry level qualification or coaching/playing experience i.e. 1 year+",
    ),
  ];

  var i;
  @override
  void initState() {
    super.initState();
    sportsList = widget.sportsList;
    i = Final.getId();
    // print("++++++++++++$i++++++++++++");
    if (i == 0) {
      list = player;
    } else {
      list = coach;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBkg,
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
                i == 1 ? "Steps 3/7" : "Steps 3/10",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w100),
              ),
              StepProgressIndicator(
                totalSteps: 10,
                currentStep: 3,
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
            child: Center(
              child: Column(
                children: <Widget>[
                  i == 1
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: App.font_name,
                                letterSpacing: 0.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'What is your coaching \nexperience '),
                              TextSpan(
                                  text: 'level ',
                                  style: TextStyle(color: colorActiveBtn)),
                              TextSpan(text: '? '),
                            ],
                          ),
                        )
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: App.font_name,
                                letterSpacing: 0.0),
                            children: <TextSpan>[
                              /* TextSpan(text: 'What '),
                              TextSpan(
                                  text: 'ability ',
                                  style: TextStyle(color: colorActiveBtn)),
                              TextSpan(text: ' are you? '),*/
                              TextSpan(text: 'What '),
                              TextSpan(
                                  text: 'level ',
                                  style: TextStyle(color: colorActiveBtn)),
                              // TextSpan(text: 'do you want\n'),
                              TextSpan(text: 'do you aim to reach? '),
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: List.generate(
                        list.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: buildExpirienceLevel(index),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                  verticalSpace(height: 16)
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
                    color: canProceed() ? colorActiveBtn : Colors.grey,
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextButton(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: canProceed()
                      ? () {
                          goToNext();
                        }
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool canProceed() {
    for (var item in sportsList) {
      if (item.title == -1) {
        return false;
      }
    }
    return true;
  }

  goToNext() async {
    SignInDetals.sportExperience = sportsList;

    if (i == 1) {
      pushRoute(context, CreateNewAct());
    } else {
      pushRoute(context, YourAgeReg(from: runtimeType.toString()));
    }
  }

  Widget buildCategory(isSelected, item, ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.0, right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: isSelected
                        ? BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: deepRed,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          )
                        : BoxDecoration(
                            color: white,
                          ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.contain,
                      ),
                    ),
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

  Widget buildExpirienceLevel(int index) {
    BNBItem item = list[index];
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mediumText(item.title, size: 22),
                        verticalSpace(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: App.font_name,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: i == 1
                                ? [
                                    TextSpan(
                                      text:
                                          "${item.height}".split("i.e.").first,
                                      style: TextStyle(
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "i.e."
                                          "${item.height.split("i.e.").last}",
                                      style: TextStyle(
                                        color: normalBlue,
                                      ),
                                    ),
                                  ]
                                : "${item.page}".contains('Would')
                                    ? [
                                        TextSpan(
                                          text: "Would train ",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                153, 153, 153, 1),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item.page.split("Would train ").last}",
                                          style: TextStyle(
                                            color: normalBlue,
                                          ),
                                        ),
                                      ]
                                    : [
                                        TextSpan(
                                          text: "${item.page}",
                                          style: TextStyle(
                                            color: normalBlue,
                                          ),
                                        )
                                      ],
                          ),
                        ),
                        verticalSpace(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            sportsList.length,
                            (a) {
                              BNBItem sport = sportsList[a];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    sport.title = index;
                                  });
                                },
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  margin: EdgeInsets.only(right: 8),
                                  // padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(sport.title == index
                                            ? sport.height
                                            : sport.width)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(width: 16),
                  Center(
                    child: Image.asset(
                      item.icon,
                      width: 100,
                      height: 70,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
