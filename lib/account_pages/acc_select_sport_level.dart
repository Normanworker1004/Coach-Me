import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/update.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';

class AcctSelectSportLevel extends StatefulWidget {
  final UserModel? userModel;
  final List<BNBItem> sportsList;

  AcctSelectSportLevel({required this.sportsList, required this.userModel});

  @override
  _AcctSelectSportLevelState createState() => _AcctSelectSportLevelState();
}

class _AcctSelectSportLevelState extends State<AcctSelectSportLevel> {
  int? selectedIndex;

  List<BNBItem> sportsList = [];
  List<BNBItem> list = [];

  List<BNBItem> player = [
    BNBItem(
      "Professional",
      "assets/level1.png",
      page: "Would train 5 days a week+",
    ),
    BNBItem(
      "Semi professional",
      "assets/level2.png",
      page: "Would train 5 days a week+",
    ),
    BNBItem(
      "Grass root",
      "assets/level3.png",
      page: "Would train 5 days a week+",
    ),
    BNBItem(
      "Keep it Fun",
      "assets/level4.png",
      page: "Would train 5 days a week+",
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
    i = widget.userModel!.getUserDetails()!.usertype == "player" ? 0 : 1;
    if (i == 0) {
      list = player;
    } else {
      list = coach;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      bottomPadding: 0,
      context: context,
      lrPadding: 0,
      body: buildBody(context),
      title: "Update Expertise",
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBkg,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SingleChildScrollView(
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
                                    text:
                                        'What is your coaching \nexperience '),
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
                                TextSpan(text: 'What '),
                                TextSpan(
                                    text: 'level ',
                                    style: TextStyle(color: colorActiveBtn)),
                                TextSpan(text: 'do you want\n'),
                                TextSpan(text: ' to get to? '),
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
                    verticalSpace(height: 16)
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
    print("Proceed.... ");

    //todo add
      SignInDetals.sportExperience = sportsList;

    try {
      List<String> sportList = List.generate(
        sportsList.length,
        (index) => "${sportsList[index].page}".toLowerCase(),
      );
      List<String> expList = List.generate(
        sportsList.length,
        (index) => "${sportsList[index].title}".toLowerCase(),
      );

      GeneralResponse2 r = await updateProfileSport(
          token: widget.userModel!.getAuthToken()!,
          sports: sportList,
          experienceLevel: expList);


      if (r.status!) {
        var userModel = UserModel();
        userModel.setUserDetails(r.userDetails);
        userModel.setUserProfileDetails(r.userDetails!.profile);

        userModel.storage.setUserDetails(r.userDetails);
        userModel.storage.setUserProfileDetails(r.userDetails!.profile);



        widget.userModel!.setUserDetails(r.userDetails);
        widget.userModel!.setUserProfileDetails(r.userDetails!.profile);

        widget.userModel!.storage.setUserDetails(r.userDetails);
        widget.userModel!.storage.setUserProfileDetails(r.userDetails!.profile);

       // var sportList = userModel.getUserDetails()?.profile?.sport?.sport ?? [];

        //print("justUpdatedDetails : ${r.userDetails.toString()}");


         Navigator.pop(context);
        Navigator.pop(context);
        // if(i == 1)
        //   pushRoute(context, EditBioPage(userModel: widget.userModel));

      }
    } catch (e) {
      print("errorrrrrr......$e ");
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
                                : [
                                    TextSpan(
                                      text: "Would train ",
                                      style: TextStyle(
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "5 days a week+",
                                      style: TextStyle(
                                        color: normalBlue,
                                      ),
                                    ),
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
                              return Expanded(
                                child: InkWell(
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
                                        image: AssetImage(
                                          sport.title == index
                                              ? sport.height
                                              : sport.width,
                                        ),
                                      ),
                                    ),
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
