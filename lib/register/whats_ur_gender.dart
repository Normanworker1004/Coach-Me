import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/final.dart';
import 'package:cme/model/subdetail.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/register/permissions.dart';
import 'package:cme/register/subscribtion_stage.dart';
import 'package:cme/subscription/sub_model.dart';
import 'package:cme/subscription/subfunctions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SelectGender extends StatefulWidget {
  String? from;
  SelectGender({this.from});

  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  List<BNBItem> genders = [
    BNBItem("Male", FontAwesome.mars, page: normalBlue),
    BNBItem("Female", FontAwesome.venus, page: deepRed),
    BNBItem("Gender\nNeutral", "assets/g3.png", page: Colors.black),
  ];

  late UserModel userModel;
  List<SubDetail> subList = [];

  int selectedIndex = -1;
  bool isFreeSub = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  var i;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    i = Final.getId();
  }

  @override
  Widget build(BuildContext context) {
    // print("inside select gender");
    return Stack(
      children: [
        ScopedModelDescendant<UserModel>(
          builder: (co, wid, model) {
            userModel = model;
            return Scaffold(
              key: _key,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: themeBkg,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        i == 1 ? "Steps 6/7" : "Steps 7/10",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w100),
                      ),
                      StepProgressIndicator(
                        totalSteps: 10,
                        currentStep: 7,
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
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
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
                            TextSpan(text: 'What\'s your '),
                            TextSpan(
                                text: 'gender?',
                                style: TextStyle(color: colorActiveBtn)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: List.generate(
                          3,
                          (index) => buildgender(
                              selectedIndex == index, genders[index], () {
                            setState(() {
                              selectedIndex = index;
                            });
                          }, type: index == 2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Stack(
                 // mainAxisAlignment: MainAxisAlignment.start,
                 //   crossAxisAlignment: CrossAxisAlignment.center ,//Center Column contents horizontally,

                   children: <Widget>[

                     Positioned(
                     child: Container(
                       child: Padding(
                         padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                         child: InkWell(
                           child: Text(
                             "   Back",
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
                     ),
                   ),

                     Positioned(
                        right: 0,
                       left: 0,
                       bottom:5,
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
                           onPressed: selectedIndex == null
                               ? null
                               : () async {
                                   CurrentSubManager c = await getOldPurchases();

                                   //.all["${package.offeringIdentifier}"];

                                   if (c.isPlayerBasicActive ||
                                       c.isCoachBasicActive ||
                                       c.isCoachAdvActive ||
                                       isFreeSub) {
                                     proceed("subId");

                                     return;
                                   }
                                   showSubscriptionDialogue(context);
                                   var u = context.read<UIProvider>();
                                   await u.setIsSubScribed();
                                   isFreeSub = true;
                                 },
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: false,
                     child: InkWell(
                       child: Text(
                         "Skip",
                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 19.0,
                             fontWeight: FontWeight.w100,
                             fontFamily: App.font_name),
                       ),
                       onTap: () async {
                         // print("inside back");
                         showSubscriptionDialogue(context);
                       },
                     ),
                   ),
                 ],
                  ),
              ),
            );
          },
        ),
        Visibility(
          visible: isLoading,
          child: Positioned(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }

  proceed(subId) async {
    print("Upload......SUB.");
    try {
      setState(() {
        isLoading = true;
      });
      // print("Upload data.......");
      var map = {
        "subscription_id": "$subId",
        "gender": "${genders[selectedIndex].title}",
      };
      var url = baseUrl + "api/auth/updateothers";
      http.Response r = await http.post(
        Uri.parse(url),
        body: map,
        headers: {
          "x-access-token": userModel.getAuthToken()!,
        },
      ).catchError((e) {
        // print("Upload failed.......$e");
      });

      // print("Upload inage......${r.body}.");
      // await loadCacheData();
      setState(() {
        isLoading = false;
      });
      pushRoute(context, AllowPermissionsPage());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // showSnack(widget.scfKey, "Error Occured");
    }
  }

  Widget buildgender(isSelected, BNBItem item, ontap, {type = false}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 164,
        width: 164,
        child: Stack(
          children: [
            Card(
              shape: CircleBorder(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        verticalSpace(height: 16),
                        Expanded(
                            child: type
                                ? Image.asset(
                                    item.icon,
                                    height: 40,
                                    width: 40,
                                  )
                                : Icon(item.icon, size: 42, color: item.page)),
                        verticalSpace(),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: App.font_name,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                right: 0,
                child: Visibility(
                  visible: isSelected,
                  child: Card(
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.check, color: deepRed),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  // goToNext() async {
  //   // Navigator.push(
  //   //     context,
  //   //     NavigatePageRoute(
  //   //         context, GuardianAccount(from: runtimeType.toString())));
  // }

  void showSubscriptionDialogue(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (BuildContext bc) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Card(
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SubBody(
                      scfKey: _key,
                      gender: selectedIndex == -1
                          ? genders[2].title
                          : genders[selectedIndex].title,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildCheckedTile() {
    return Container(
      width: double.infinity,
      height: 64,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Free Version",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Limited Features",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Card(
              margin: EdgeInsets.all(0),
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Color.fromRGBO(182, 9, 27, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
