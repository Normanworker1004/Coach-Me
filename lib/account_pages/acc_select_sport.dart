import 'package:cme/account_pages/acc_select_sport_level.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/final.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:cme/utils/navigate_effect.dart';

import '../ui_widgets/sport_icon_function.dart';

// ignore: must_be_immutable
class AcctSelectSport extends StatefulWidget {
  final UserModel? userModel;

  AcctSelectSport({required this.userModel});

  @override
  _AcctSelectSportState createState() => _AcctSelectSportState();
}

class _AcctSelectSportState extends State<AcctSelectSport> {
  late UserModel userModel;
  int? selectedIndex;
  List<int> selections = [];
  List<BNBItem> sportsCategories = sportsList;

  var i;
  @override
  void initState() {
    super.initState();
    i = Final.getId();
    userModel = UserModel();
    print(userModel.getUserDetails()!.usertype);
    i =  userModel.getUserDetails()!.usertype == "player" ? 0 : 1 ;
    var sportList = userModel.getUserDetails()?.profile?.sport?.sport ?? [];
    print("$sportList"+"aaa");

    for (var i = 0; i < sportsCategories.length; i++) {
      for (var item in sportList) {
        if ("$item".toLowerCase().trim() ==
            "${sportsCategories[i].page}".toLowerCase().trim()) {
          selections.add(i);
         if (selectedIndex == null)  selectedIndex = i ;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      context: context,
      body: buildBody(context),
      title: "Update Sports",
      lrPadding: 0,
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1), //bgGrey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
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
                                TextSpan(text: 'Which Sport do you\n'),
                                TextSpan(
                                    text: 'coach',
                                    style: TextStyle(color: colorActiveBtn)),
                                TextSpan(text: ' in? '),
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
                                TextSpan(text: 'Which Sport do you want to '),
                                TextSpan(
                                    text: 'be ',
                                    style: TextStyle(color: colorActiveBtn)),
                                TextSpan(
                                    text: 'coached',
                                    style: TextStyle(color: colorActiveBtn)),
                                TextSpan(text: ' in? '),
                              ],
                            ),
                          ),
                    verticalSpace(height: 16),
                    Column(
                      children: List.generate(
                        sportsCategories.length,
                        (index) {
                          return buildCategory(
                            // selectedIndex == index,
                            selections.contains(index),

                            sportsCategories[index],
                            () {
                              setState(() {
                                if (selections.contains(index)) {
                                  selections.remove(index);
                                } else {
                                  selections.add(index);
                                }
                                selectedIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    verticalSpace(height: 8),
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
                  borderRadius: BorderRadius.circular(30.0),
                ),
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
        selections.length, (index) => sportsCategories[selections[index]].page);

    List<BNBItem> sportsLis = List.generate(selections.length, (index) {
      BNBItem b = sportsCategories[selections[index]];
      b.title = -1;
      return b;
    });

    Navigator.push(
        context,
        NavigatePageRoute(
            context,
            AcctSelectSportLevel(
              sportsList: sportsLis,
              userModel: widget.userModel,
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
