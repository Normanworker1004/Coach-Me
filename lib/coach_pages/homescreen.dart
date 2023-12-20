import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/coach_account_page.dart';
import 'package:cme/coach_pages/coach_booking.dart';
// import 'package:cme/coach_pages/coach_stats.dart';
import 'package:cme/coach_pages/diary/diary_page.dart';
import 'package:cme/coach_pages/home.dart';
import 'package:cme/graph_import/coach_stats.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../app.dart';

class CoachHomeScreen extends StatefulWidget {
  @override
  _CoachHomeScreenState createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  var b = false;
  late Widget body;
  UserModel? userModel;
  List<Widget> bodyList = [];

  var bottomIndex = 0;
  List<BNBItem> bnbItemsList = [
    BNBItem("Home", "assets/bnb1a.png"),
    BNBItem("Bookings", "assets/bnb2b.png"),
    BNBItem("Stats", "assets/bnb3a.png"),
    BNBItem("Account", "assets/bnb4a.png"),
  ];

  Widget buildHomeBottom() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.3), blurRadius: 8)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              bnbItemsList.length,
                  (index) => GestureDetector(
                onTap: () {
                  gotoIndex(index);
                },
                child:
                Container(
                 // color: Colors.red,
                  child:
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Stack(
                      children: [
                        Container(
                          child: index == bottomIndex
                              ? Padding(
                            padding: const EdgeInsets.only(
                                top: 26.0, bottom: 26),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    bnbItemsList[index].icon,
                                    height: 20,
                                    color: Color.fromRGBO(25, 87, 234, 1),
                                  ),
                                  verticalSpace(height: 2),
                                  Text(
                                    bnbItemsList[index].title,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                        Color.fromRGBO(25, 87, 234, 1),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(
                                top: 26.0, bottom: 26),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(bnbItemsList[index].icon,
                                      height: 20, color: Colors.black),
                                  verticalSpace(height: 2),
                                  Text(
                                    bnbItemsList[index].title,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 22,
                          child: Visibility(
                            visible: index == 1 &&
                                userModel!.getCoachBookingCount() > 0,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(
                                      182, 9, 27, 1) //rgba(182, 9, 27, 1)
                              ),
                              child: Center(
                                child: Text(
                                  "${userModel!.getCoachBookingCount()}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: App.font_name2,
                                    fontSize: 10,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  gotoIndex(int index) {
    setState(() {
      bottomIndex = index;
      body = bodyList[bottomIndex];
    });
  }

  init() {
    bodyList = [
      CoachHome(),
      CoachBookingsSection(userModel: userModel),
      // CoachStatsPage(),
      CoachStatsPage(userModel: userModel),
      CoachAccountPage(userModel: userModel)
    ];
    body = bodyList[bottomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        init();
        return Scaffold(
          backgroundColor: Colors.white,
          body: WillPopScope(
            onWillPop: () async {
              // print("Back Pressed.....");
              if (bottomIndex == 0) {
                // print("....Back Pressed.....");
                return true;
              } else {
                // print("dont go ===== Back Pressed.....");
                gotoIndex(0);
                return false;
              }
            },
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: body,
                  bottom: 16,
                  top: 0,
                  left: 0,
                  right: 0,
                ),
                Positioned(
                    bottom: 0, left: 0, right: 0, child: buildHomeBottom()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pushRoute(
                            context,
                            CoachDiaryPage(
                              userModel: userModel,
                            ),
                          );
                        },
                        child: Card(
                            color: Colors.white70,
                            margin: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.white),
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(42),
                                  image: DecorationImage(
                                    image: AssetImage("assets/logo.png"),
                                    // fit: BoxFit.fitHeight
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
