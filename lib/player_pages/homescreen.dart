import 'package:cme/account_pages/subscriptions_page.dart';
import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/stats/add_stats_data_page.dart';
import 'package:cme/intro/splashscreen.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/account_pages/account_page.dart';
import 'package:cme/player_pages/book_coach/find_coach_page.dart';
import 'package:cme/player_pages/home_screen_pages/bookings.dart';
import 'package:cme/player_pages/home_screen_pages/home.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_bottom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../register/permissions.dart';
import '../utils/custom_tooltip.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  final TooltipController _controller = TooltipController();
  final TooltipController _controllerFixtures = TooltipController();

}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userModel;
  var b = false;
  var doneToolTip = false;
  var initialized = false;
  List<Widget> bodyList = [];
  var bottomIndex = 0;
  List<BNBItem> bnbItemsList = [
    BNBItem("Home", "assets/bnb1a.png"),
    BNBItem("Bookings", "assets/bnb2b.png"),
    BNBItem("Stats", "assets/bnb3a.png"),
    BNBItem("Account", "assets/bnb4a.png"),
  ];

  gotoIndex(int index, {int subIndex = 0}) {
    var u = context.read<UIProvider>();
    u.setCurrentScrenIndex(index, subIndex:subIndex);
  }

  Widget buildHomeBottom() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      elevation: 10,
      margin: EdgeInsets.all(0),
      child: Consumer<UIProvider>(
        builder: (c, provider, i) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            bnbItemsList.length,
            (index) => Flexible(
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: InkWell(
                  splashFactory:NoSplash.splashFactory, 
                  enableFeedback: false,
                  onTap: () {
                    //pushRoute(context, AllowPermissionsPage());
                     gotoIndex(index);
                    if (!provider.isSubScribed()) {
                         showBottomDialogue(  context: context, child: SubscriptionPage());
                    }
                  },
                  child:
                  Container(
                       child:  Padding(
                    padding: const EdgeInsets.only(left: 19.0, right: 19.0),
                    child: Stack(
                      children: [
                        Container(
                          child: index == provider.getCurrentScreenIndex()
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
                            visible: false, //index == 1,
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
                                  "4",
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
      ),
    );
  }

  init(UserModel model) {
    if(!initialized) {
      initialized = true;
      print("init User Model");
      userModel = model;
      bodyList = [
        HomeSection(),
        BookingsSection(userModel: model),
        AddStatsDataPage(userModel: model),
        AccountPage(userModel: model)
      ];
    }
  }

  showLogOutDialogue() async {
    await showCupertinoDialog<bool>(
      context: this.context,
      barrierDismissible: true,
      builder: (c) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to logout of Coach&Me?",
            style: TextStyle(
              fontFamily: App.font_name,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(c, false);
              return ;
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: App.font_name,
                color: Color.fromRGBO(182, 9, 27, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, NavigatePageRoute(c, GetStartedPage()));
            },
            child: Text(
              "Yes",
              style: TextStyle(
                fontFamily: App.font_name,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initToolTipTimer() async {
     var prefs = await SharedPreferences.getInstance();

    var alreadyShowed = await prefs.getInt('homeTooltip') ;
    print("ALREADY SHWED ? :: ${alreadyShowed}"); 
    if(alreadyShowed == 1)doneToolTip= true;
    widget._controller.setStartWhen( (initializedWidgetLength) async {
      //await any function and return a bool value when done.
      await Future.delayed(const Duration(milliseconds: 500));
      return initialized  && !doneToolTip;
    });

    widget._controller.onDone(() async {
      var prefs = await SharedPreferences.getInstance();
      print("DONE DONE ");
      // add function to occur
      await prefs.setInt('homeTooltip', 1);
     var test = await prefs.getInt('homeTooltip') ;
     print("here a get int : ${test}");
      setState(() {
        doneToolTip = true;
      });
    });

  }

  Widget bookCoachButtonContainer( {required BuildContext context, required child}){
    if(!doneToolTip){
      return  OverlayTooltipItem(
          tooltipVerticalPosition: TooltipVerticalPosition.TOP,
          displayIndex: 0,
          tooltip: (controller) =>
              MTooltip(
                  title: 'Press here to book a coach',
                  subTitle:'you can press this button from any screen to find a coach for you ',
                  controller: controller),
          child: child,
      );
    }
    return Container(child: child);
  }

  @override
  Widget build(BuildContext context) {
    initToolTipTimer();


    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        init(model);
        return  OverlayTooltipScaffold(
            overlayColor: Colors.black.withOpacity(.8),
            tooltipAnimationCurve: Curves.linear,
            tooltipAnimationDuration: const Duration(milliseconds: 1000),
            controller: widget._controller,
            builder: (BuildContext context) {

              return    Scaffold(
                backgroundColor: Colors.white,
                body: WillPopScope(
                  onWillPop: () async {
                    if (bottomIndex == 0) {
                      if (userModel!.getUserDetails()!.usertype == "player") {
                        showLogOutDialogue();
                      } else {
                        Navigator.pop(context);
                      }
                      return false;
                    } else {
                      gotoIndex(0);
                      return false;
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Consumer<UIProvider>(
                          builder: (c, provider, i) =>
                          bodyList[provider.getCurrentScreenIndex()],
                        ),
                        bottom: 16,
                        top: 0,
                        left: 0,
                        right: 0,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: buildHomeBottom(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 64,
                        child: bookCoachButtonContainer(
                          context:context,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  pushRoute(
                                    context,
                                    FindCoachPage(
                                      userModel: userModel,
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(0),
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 42,
                                      width: 42,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.white),
                                        color: Colors.white ,
                                        borderRadius: BorderRadius.circular(42),
                                        image: DecorationImage(
                                          image: AssetImage("assets/logo.png"),
                                          // fit: BoxFit.fitHeight
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );

            },


            );
      },
    );
  }
}
