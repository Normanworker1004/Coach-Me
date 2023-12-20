import 'dart:io';
import 'dart:typed_data';

import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/share_widget_page.dart';
import 'package:cme/network/fixture/fixture_table_network_helper.dart';
import 'package:cme/network/fixture/seasons_data.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/string_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as datePicker;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as ui;



import '../model/bnb_item.dart';
import '../ui_widgets/button.dart';
import '../ui_widgets/sport_icon_function.dart';
import '../utils/custom_tooltip.dart';
import '../utils/navigate_effect.dart';
import 'custom_time_drodown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class FixtureSection extends StatefulWidget {
  final UserModel? userModel;
  final TooltipController tooltipController;

    FixtureSection({Key? key, required this.userModel, required this.tooltipController }) : super(key: key);
  @override
  _FixtureSectionState createState() => _FixtureSectionState();
}

class _FixtureSectionState extends State<FixtureSection> {
  //WidgetsToImageController controllerImage = WidgetsToImageController();

  Future<SeasonsData>? seasonsData;
  String? house = "Home";
  String? gameStatus = "Win";
  List<String> opponents = [""];
  bool noSeasons = true;
  bool screenshotInProgress = false;
  Season? currentSeason;
  String selected = "All";
  String newDate = "16/07/2020";
  bool addNewFixture = false;
  String selectedSport = "";
  bool changingSport = false;
  bool needToShowToolTipSoloFixture = false;



  TextEditingController newFixtureScore1Controller = TextEditingController();
  TextEditingController newFixtureScore2Controller = TextEditingController();
  TextEditingController newFixtureScore3Controller = TextEditingController();
  TextEditingController newFixtureScore4Controller = TextEditingController();
  TextEditingController newFixtureScore5Controller = TextEditingController();
  TextEditingController newFixtureScore6Controller = TextEditingController();
  TextEditingController seasonTitle1Controller = TextEditingController();
  TextEditingController seasonTitle2Controller = TextEditingController();
  TextEditingController seasonTitle3Controller = TextEditingController();
  TextEditingController seasonTitle4Controller = TextEditingController();
  TextEditingController seasonTitle5Controller = TextEditingController();
  TextEditingController seasonTitle6Controller = TextEditingController();
  TextEditingController oppositionController = TextEditingController();

  bool fixture5Visible = false;
  bool fixture6Visible = false;

  bool isAll = false;
  bool isCustomizable = false;
  bool doneToolTip = false;
  bool initialized = false;
  SeasonsData? sDataSave = null;
  Widget fixtureResume = Container();

  Widget sportSeclector(BuildContext context){
   if( ( widget.userModel?.getUserDetails()?.sport?.sport?.length ?? 0) == 0) {
     return Container();
   }
   var sportLists = widget.userModel!.getUserDetails()!.sport!.sport!;
    if(sportLists.length == 1){ // just One sport, so we should keep it for later use.
      selectedSport = sportLists[0];
    }else{
      if(selectedSport == "")selectedSport =  sportLists[0];
      // we should build super widget here...

      return
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children:  [...List.generate(
              sportLists.length,
                  (a) {
                BNBItem sport = getItemFromSport(sportLists[a]);
                return Container(
                  child: InkWell(
                    onTap: ()  async {
                      loadSeasonsData(sportLists[a]);
                      selectedSport = sportLists[a];
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {
                       changingSport = true;
                        currentSeason = null;
                        selected = "";
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
                            sportLists[a] == selectedSport ?
                            sport.height : sport.width,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(child: Container()),
              InkWell(child: Icon(Icons.info_outline),
              onTap: (){
                doneToolTip = false;
                OverlayTooltipScaffold.of(context)?.controller.start(0);
              },)
            ]
          ),
        );

    }
    return Container();
  }


  Future<void> initToolTipTimer() async {
    String toolShownTipKey = "fixtureToolTipbaaaazzcaaaa";
    final prefs = await SharedPreferences.getInstance();
    var alreadyShowed = await prefs.getString(toolShownTipKey) ?? "false";
    var alreadyShowedSolo = await prefs.getString(toolShownTipKey+"Solo") ?? "false";
    print("alreadyShowed???? ${alreadyShowed}");
    if(alreadyShowed == "true")doneToolTip= true;
    if((!noSeasons && initialized && !doneToolTip )  ){
      widget.tooltipController.start();
      await prefs.setString(toolShownTipKey, "true");
    }
    if(needToShowToolTipSoloFixture && doneToolTip && alreadyShowedSolo == "false" ){
      widget.tooltipController.start(4);
    }
     widget.tooltipController.onDone(() async {
      final prefs = await SharedPreferences.getInstance();

      // add function to occur
      var alreadyShowed2 = await prefs.getString(toolShownTipKey) ?? "false";
      print("alreadyShowed???? ${alreadyShowed2}");

      if(needToShowToolTipSoloFixture) await prefs.setString(toolShownTipKey+"Solo", "true");

      setState(() {
        doneToolTip = true;
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    initToolTipTimer();
    return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {});
            },
            child: FutureBuilder(
                future: seasonsData,
                builder: (context, snapshot) {

                  if (!snapshot.hasData || snapshot.data == null) {
                    sDataSave = null;
                    initialized = true;
                    return Container(
                        child: Center(
                      child: Text('Please, check your internet connection!'),
                    ));
                  } else if (snapshot.data != null) {
                    // activeSeasonsData = snapshot.data;

                    SeasonsData? sData = snapshot.data as SeasonsData?;
                    sDataSave = sData;
                    // print(" snapshot.data :: ${ sData?.allSeason?.seasonName}");
                    if((sData?.seasons?.length ?? 0) > 0) {
                      currentSeason = currentSeason ??  sData?.seasons?.last ?? null;
                      selected = currentSeason?.seasonName ?? "";

                      if(changingSport) {
                        currentSeason =  sData?.seasons?.last;
                        selected = currentSeason?.seasonName ?? "";

                      }
                    }
                    noSeasons = currentSeason == null;
                    if(noSeasons) createNewSeason(selectedSport);
                    currentSeason ??= sData?.allSeason;

                    isAll = currentSeason == sData?.allSeason && selected == "All";
                    isCustomizable = ((currentSeason?.title5 ?? "") == "" || (currentSeason?.title6 ?? "") == "") ;
                    fixture5Visible = ((currentSeason?.title5 ?? "") != "") ;
                    fixture6Visible = ((currentSeason?.title6 ?? "") != "") ;
                    //changingSport = false;

                       return
                      ListView(
                          children: [
                            sportSeclector(context),
                            sData != null ? buildFixtureTableOverview(sData) : Container(),
                            Visibility(
                              visible: !noSeasons,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15.0, 18.0, 14, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        mediumText("Fixtures",
                                            color: Colors.black, size: 17),
                                          Spacer(),
                                        Stack(
                                          children: [
                                            Visibility(
                                              visible: isCustomizable,
                                              child: InkWell(
                                                onTap: () {
                                                 showNextFixture(context);
                                                },
                                                child:
                                                OverlayTooltipItem(
                                                  // tooltipVerticalPosition: TooltipVerticalPosition.,
                                                  tooltipHorizontalPosition: TooltipHorizontalPosition.WITH_WIDGET,
                                                  //color:Colors.red,
                                                  displayIndex: 3,
                                                  tooltip: (controller) =>
                                                      MTooltip(
                                                          title: 'Press to add headings',
                                                          subTitle:'You can add 2 more headings / fixtures at any time',
                                                          controller: controller),
                                                  child: Container(
                                                    height: 25,

                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons.plus,
                                                            color: Colors.black,
                                                            size: 12,
                                                          ),
                                                          // horizontalSpace(),
                                                          // mediumText(
                                                          //   "Customize",
                                                          //   color: Colors.black,
                                                          //   size: 12,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: isCustomizable,
                                            //   child: InkWell(
                                            //     onTap: () {
                                            //       setState(() {
                                            //         if (updateSeasonsTitles())
                                            //           isCustomizable = false;
                                            //       });
                                            //     },
                                            //     child: Container(
                                            //       height: 30,
                                            //       child: Padding(
                                            //         padding: const EdgeInsets.all(8.0),
                                            //         child: Row(
                                            //           children: [
                                            //             Icon(
                                            //               Icons.save,
                                            //               color: Colors.white,
                                            //               size: 12,
                                            //             ),
                                            //             horizontalSpace(),
                                            //             mediumText(
                                            //               "Save Customization",
                                            //               color: Colors.white,
                                            //               size: 12,
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //       decoration: BoxDecoration(
                                            //         color: red,
                                            //         border: Border.all(
                                            //           color: Colors.white,
                                            //         ),
                                            //         borderRadius:
                                            //             BorderRadius.circular(12),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                    verticalSpace(height: 16),
                                    buildHeadings(context),
                                    verticalSpace(height: 10),
                                    Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          datePicker.DatePicker.showDatePicker(
                                                            context,
                                                            theme: datePicker.DatePickerTheme(
                                                              doneStyle: TextStyle(
                                                                color: blue,
                                                              ),
                                                            ),

                                                            showTitleActions: true,
                                                            // onChanged: (DateTime) {},
                                                            onConfirm:
                                                                (DateTime date) {
                                                              if (isAll)
                                                                alert(context,
                                                                    "Please, select a season, in order to save your new fixture!");
                                                              setState(() {
                                                                newDate =
                                                                    "${date.day}/${date.month}/${date.year}";
                                                                addNewFixture =
                                                                    true && !isAll;
                                                              });
                                                            },
                                                            currentTime: DateTime
                                                                    .now()
                                                                .subtract(Duration(
                                                                    days:
                                                                        18 * 365)),
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(right: 20),
                                                          height: 25,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(5),
                                                            border: Border.all(
                                                                color: Color.fromRGBO(
                                                                    228,
                                                                    228,
                                                                    228,
                                                                    1) //rgba(228, 228, 228, 1)
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/calendar.png",
                                                                  width: 10,
                                                                  height: 10,
                                                                ),
                                                                horizontalSpace(
                                                                    width: 2),
                                                                rMediumText(
                                                                  "$newDate",
                                                                  size: 10,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 25,
                                                        width: 35,
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                        child: buildFixtureValueField(
                                                            newFixtureScore1Controller),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 25,
                                                        width: 35,
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                        child: buildFixtureValueField(
                                                            newFixtureScore2Controller),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 25,
                                                        width: 35,
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                        child: buildFixtureValueField(
                                                            newFixtureScore3Controller),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: 25,
                                                        width: 35,
                                                        margin:
                                                        EdgeInsets.only(left: 4),
                                                        child: buildFixtureValueField(
                                                            newFixtureScore4Controller),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: fixture5Visible,
                                                      child: Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: 25,
                                                          width: 35,
                                                          margin:
                                                          EdgeInsets.only(left: 4),
                                                          child: buildFixtureValueField(
                                                              newFixtureScore5Controller),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: fixture6Visible,
                                                      child: Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: 25,
                                                          width: 35,
                                                          margin:
                                                          EdgeInsets.only(left: 4),
                                                          child: buildFixtureValueField(
                                                              newFixtureScore6Controller),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                verticalSpace(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 35,
                                                      width: 80,
                                                      child: CustomDropDownWithFeedBack(
                                                        padding: EdgeInsets.only(
                                                            left: 4, right: 4),
                                                        textColor: blue,
                                                        selectedItem: house,
                                                        item: ["Home", "Away"],
                                                        onSelection: (value) {
                                                          setState(() {
                                                            house = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      width: 100,
                                                      child: TextField(
                                                        textAlign: TextAlign.center,
                                                        textAlignVertical:
                                                            TextAlignVertical.center,
                                                        controller:
                                                            oppositionController,
                                                        // autofillHints: opponents,
                                                        decoration: InputDecoration(
                                                          hintText: "Opposition",
                                                          enabled: addNewFixture,
                                                          border: OutlineInputBorder(),
                                                          contentPadding:
                                                              EdgeInsets.all(2.0),
                                                          hintMaxLines: 1, floatingLabelBehavior: FloatingLabelBehavior.never,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 35,
                                                      width: 80,
                                                      child: CustomDropDownWithFeedBack(
                                                        padding: EdgeInsets.only(
                                                            left: 4, right: 4),
                                                        textColor: blue,
                                                        item: [
                                                          "Win",
                                                          "Draw",
                                                          "Loss"
                                                        ],
                                                        selectedItem: gameStatus,
                                                        onSelection: (value) {
                                                          setState(() {
                                                            gameStatus = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: addNewFixture,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                              ),
                                              child: InkWell(
                                                child: Container(
                                                  height: 29,
                                                  color: Color.fromRGBO(28, 67, 138, 1),
                                                  child: Center(
                                                      child: boldText("Save",
                                                          color: white, size: 14)),
                                                ),
                                                onTap: () {
                                                  if (createNewFixture())
                                                    setState(() {
                                                      addNewFixture = false;
                                                    });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // height: 80,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(8)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 8.0, bottom: 16.0),
                                      child: Column(
                                        children: currentSeason != null &&
                                                currentSeason!.fixture != []
                                            ? List.generate(
                                                currentSeason!.fixture!.length, (index) {
                                                Fixture fixture =
                                                    currentSeason!.fixture![index];
                                                return buildFixturesItem(context,
                                                    fixture: fixture);
                                              })
                                            : [],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: noSeasons,
                              child: verticalSpace(height: 16.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: borderProceedButton(
                                    text:"Add Season",
                                    onPressed: (){
                                      toast("Add new season");
                                      createNewSeason(selectedSport);
                                    },
                                    color: Color.fromRGBO(25, 87, 234, 1),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: borderProceedButton(
                                      text:"Delete Season",
                                      onPressed: (){
                                        showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text('Are you sure ? '),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                     Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text('Delete Season and data'),
                                                  isDestructiveAction: true,
                                                  onPressed: () async {
                                                   Navigator.pop(context);
                                                   await deleteCurrentSeason();
                                                  },
                                                ),
                                              ],
                                              content:  Text('By deleting this season, you will delete all data with it, you will not be able to restore the information.')
                                            );
                                          },
                                        );
                                      },
                                      color: Color.fromRGBO(182, 9, 27, 1)
                                  ),
                                ),
                              ],
                            ),
                          ],

                      );
                  } else {
                    return Container(
                        child: Center(
                      child: Text('This is an Empty Container'),
                    ));
                  }
                }),
          ),

    );
  }

  Row buildHeadings(BuildContext context) {
    return Row(
                                    children: [
                                      horizontalSpace(width: 8),
                                      Expanded(
                                          flex: 2,
                                          child: mediumText("Date", size: 12)),
                                      Expanded(
                                        flex: 1,
                                        child: OverlayTooltipItem(
                                           // tooltipVerticalPosition: TooltipVerticalPosition.,
                                          tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                                          displayIndex: 2,
                                          tooltip: (controller) =>
                                          MTooltip(
                                          title: 'Press to change headings',
                                          subTitle:'You can change any headings here before adding fixtures',
                                          controller: controller),

                                          child: GestureDetector(
                                            onLongPress: (){
                                              showEditFixtureModal(
                                                context: context,
                                                controller: seasonTitle1Controller,
                                                currentSeason: currentSeason,
                                                currentTitle: currentSeason?.title1
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: Stack(
                                                children: [
                                                  fixtureTitleText(
                                                      "${currentSeason?.title1}",
                                                      size: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onLongPress: (){
                                            showEditFixtureModal(
                                                context: context,
                                                controller: seasonTitle2Controller,
                                                currentSeason: currentSeason,
                                                currentTitle: currentSeason?.title2
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                // Visibility(
                                                //     visible: isCustomizable,
                                                //     child: buildSeasonTitleField(
                                                //         seasonTitle2Controller,
                                                //         currentSeason?.title2)),
                                                fixtureTitleText(
                                                    "${currentSeason?.title2}",
                                                    size: 12),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onLongPress: (){
                                            showEditFixtureModal(
                                                context: context,
                                                controller: seasonTitle3Controller,
                                                currentSeason: currentSeason,
                                                currentTitle: currentSeason?.title3
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                // Visibility(
                                                //     visible: isCustomizable,
                                                //     child: buildSeasonTitleField(
                                                //         seasonTitle3Controller,
                                                //         currentSeason?.title3)),
                                                fixtureTitleText(
                                                    "${currentSeason?.title3}",
                                                    size: 12),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onLongPress: (){
                                            showEditFixtureModal(
                                                context: context,
                                                controller: seasonTitle4Controller,
                                                currentSeason: currentSeason,
                                                currentTitle: currentSeason?.title4
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                // Visibility(
                                                //     visible: isCustomizable,
                                                //     child: buildSeasonTitleField(
                                                //         seasonTitle4Controller,
                                                //         currentSeason?.title4)),
                                                fixtureTitleText(
                                                    "${currentSeason?.title4}",
                                                    size: 12),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: fixture5Visible,
                                        child: Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onLongPress: (){
                                              showEditFixtureModal(
                                                  context: context,
                                                  controller: seasonTitle5Controller,
                                                  currentSeason: currentSeason,
                                                  currentTitle: currentSeason?.title5
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: [
                                                  // Visibility(
                                                  //     visible: isCustomizable,
                                                  //     child: buildSeasonTitleField(
                                                  //         seasonTitle5Controller,
                                                  //         currentSeason?.title5)),
                                                  fixtureTitleText(
                                                      "${currentSeason?.title5}",
                                                      size: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: fixture6Visible,
                                        child: Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onLongPress: (){
                                              showEditFixtureModal(
                                                  context: context,
                                                  controller: seasonTitle6Controller,
                                                  currentSeason: currentSeason,
                                                  currentTitle: currentSeason?.title6
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: [
                                                  // Visibility(
                                                  //     visible: isCustomizable,
                                                  //     child: buildSeasonTitleField(
                                                  //         seasonTitle6Controller,
                                                  //         currentSeason?.title6)),
                                                  fixtureTitleText(
                                                      "${currentSeason?.title6}",
                                                      size: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
  }

  Future<void> deleteCurrentSeason() async {
      await deleteSeason(widget.userModel!.getAuthToken(), currentSeason?.id);
      changingSport = true;
      await loadSeasonsData(selectedSport);
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        currentSeason = null ;
        selected = "";
      });
  }

  Widget buildFixtureTableOverview(SeasonsData data, {bool isSharing = false}) {
    List<String> seasonsList = data.seasons != null
        ? List.generate(data.seasons?.length ?? 0, (index) {
            return data.seasons![index].seasonName ?? "";
          })
        : [];

    List<String> overviewColumns = (currentSeason != null)
        ? [
            "APP\n${currentSeason!.app}",
            "${currentSeason!.title1}\n${currentSeason!.score1Sum}",
            "${currentSeason!.title2}\n${currentSeason!.score2Sum}",
            "${currentSeason!.title3}\n${currentSeason!.score3Sum}",
            "${currentSeason!.title4}\n${currentSeason!.score4Sum}",
            ]
        : ["App\n0", "Score 1\n0", "Score 2\n0", "Score 3\n0", "Score 4\n0"];
    if(fixture5Visible)  overviewColumns = [...overviewColumns,  "${currentSeason!.title5}\n${currentSeason!.score5Sum}",];
    if(fixture6Visible)  overviewColumns = [...overviewColumns,  "${currentSeason!.title6}\n${currentSeason!.score6Sum}",];
    return Padding(  key: UniqueKey(),
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child:Container(
          padding: EdgeInsets.all(0),
          child:
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child:
                                boldText("${selectedSport.capitalize()} stats", color: white, size: 24)),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child:
                             isSharing ?     
                             Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Text('${currentSeason?.seasonName}',
                              textAlign: TextAlign.end,
                              style:TextStyle(color:Colors.white)),
                        ) :
                            Stack(
                              children: [
                                Visibility(
                                  visible: !noSeasons,
                                  child:
                                  OverlayTooltipItem(
                                    // tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                                    // tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                                    displayIndex: 1,
                                    tooltip: (controller) =>
                                        MTooltip(
                                            title: 'Add season',
                                            subTitle: "Create more seasons once a season has been completed, select a season here",
                                            controller:widget.tooltipController,
                                        ),

                                    child:
                                     CustomSeasonsDropDown(
                                      icon: CupertinoIcons.settings,
                                      bgColor: Colors.transparent,
                                      textColor: Colors.black,
                                      //bgColor2: Color(0xFF112440),
                                      item: seasonsList,// ["All"] +
                                      selectedItem: selected,
                                      onSelection: (value) {
                                        setState(() {
                                          changingSport = false;
                                          selected = value;
                                          if (value == "All") {
                                            currentSeason = data.allSeason;
                                            isAll = true;
                                          } else {
                                            currentSeason = data.seasons![seasonsList.indexOf(value)];
                                          }
                                          print("Just choosed season :: ${currentSeason?.seasonName}");
                                          isCustomizable = false;
                                          addNewFixture = false;
                                        });
                                      },
                                      onAddNewSeason: () {
                                        toast("Add new season");
                                        createNewSeason(selectedSport);
                                      },
                                    ) ,
                                  ),
                                ),
                                // Visibility(
                                //   visible: noSeasons,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       createNewSeason(selectedSport);
                                //     },
                                //     child: Container(
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(6.0),
                                //         child: Row(
                                //           children: [
                                //             mediumText("Create Season",
                                //                 color: white, size: 12),
                                //             Icon(
                                //               CupertinoIcons.settings,
                                //               color: white,
                                //               size: 12,
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //           color: white,
                                //         ),
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalSpace(height: 15),
                    // Season's Columns titles
                    Visibility(
                      visible: !noSeasons  ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            List.generate(overviewColumns.length , (index) {
                          var cellContent = overviewColumns[index].split("\n");
                          return Column(
                            children: [
                              Text(
                                "${cellContent[0]}",
                                style: TextStyle(
                                  color: white,
                                  fontFamily: App.font_name,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              verticalSpace(height: 6),
                              Text(
                                cellContent[1],
                                style: TextStyle(
                                  color: white,
                                  fontFamily: App.font_name2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Visibility(
                visible: !noSeasons && !screenshotInProgress ,
                child: Row(
                  children: [
                    // Expanded(
                    //   child: Container(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Image.asset(
                    //           "assets/plus.png",
                    //           height: 11.5,
                    //           width: 11.5,
                    //         ),
                    //         horizontalSpace(width: 5.5),
                    //         mediumText(
                    //           "Add to Home",
                    //           size: 12,
                    //           color: white,
                    //         ),
                    //       ],
                    //     ),
                    //     height: 40,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: white,
                    //       ),
                    //       borderRadius: BorderRadius.only(
                    //         bottomLeft: Radius.circular(10),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    !isSharing ? Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await shareTopFixture();
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/stats_share.png",
                                height: 11.5,
                                width: 11.5,
                              ),
                              horizontalSpace(width: 5.5),
                              mediumText(
                                "Share",
                                size: 12,
                                color: white,
                              ),
                            ],
                          ),
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: white,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(3, 12, 30, 1).withOpacity(.89),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        height: 176,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/stats11.png"),
            )),
      ),
    );
  }
  Future<Uint8List> getLogoIMG() async {
    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final Uint8List list = bytes.buffer.asUint8List();
    return list;
  }
  Future<void> shareTopFixture() async {
   if(sDataSave != null ) {
     pushRoute(
         context,
         ShareWidgetPage(
           child: buildFixtureTableOverview(sDataSave!, isSharing: true),
           textToShare: '@${widget.userModel?.getUserDetails()?.username ?? ""}'  ,
         ));
   }

  }

  Widget buildFixtureItemWithHeading(BuildContext context, Fixture fixture){
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 10.0),
              child: buildHeadings(context),
            ),
          ),
          buildFixturesItem(context, fixture: fixture),
        ],
      ),
    );
  }

  Future<void> shareSimpleFixture(BuildContext context, Fixture fixture ) async {
    await Future.delayed(Duration(milliseconds: 50));
    if(sDataSave != null ) {
      pushRoute(
          context,
          ShareWidgetPage(
            child: buildFixtureItemWithHeading(context, fixture),
            textToShare: '@${widget.userModel?.getUserDetails()?.username ?? ""}'  ,
          ));
    }

  }

  // checkForSeasons(AsyncSnapshot snapshot) {
  //   if (snapshot.data != null) {
  //     SeasonsData? data = snapshot.data;
  //     if (currentSeason == null && data!.allSeason!.fixture != []) {
  //       currentSeason = data.allSeason;
  //       setState(() {
  //         noSeasons = false;
  //       });
  //     }
  //   }
  // }

  Widget buildFixturesItem(BuildContext context, {required Fixture fixture, bool isScreenShot = false}) {
    Color color = const Color.fromRGBO(100, 100, 100, 1);
    String status = fixture.gamestatus != null && fixture.gamestatus != ''
        ? fixture.gamestatus!.split('')[0]
        : '';
    String? venue = fixture.house;
    String? opponent = fixture.opponent;
    String date = fixture.getDatePlayed().split(' ')[0].replaceAll('-', '/');
    int? score1 = fixture.score1 ?? 0;
    int? score2 = fixture.score2 ?? 0;
    int? score3 = fixture.score3 ?? 0;
    int? score4 = fixture.score4 ?? 0;
    int? score5 = fixture.score5 ?? 0;
    int? score6 = fixture.score6 ?? 0;

    print("BUILD FIXTURE....${fixture.toJson()}");
     switch (status) {
      case ('w'):
      case ('W'):
        color = const Color.fromRGBO(9, 100, 232, 1);
        break;
      case ('l'):
      case ('L'):
        color = const Color.fromRGBO(192, 9, 27, 1);
        break;
      default:
        color = const Color.fromRGBO(100, 100, 100, 1);
        break;
    }
    //WidgetsToImageController  myController = WidgetsToImageController();

    return

      OverlayTooltipItem(
        tooltipVerticalPosition: TooltipVerticalPosition.TOP ,
        tooltipHorizontalPosition: TooltipHorizontalPosition.WITH_WIDGET,
        //color:Colors.red,
        displayIndex: 4,
        tooltip: (controller) =>
        MTooltip(
            title: 'Long Press to share',
            subTitle:'You can share individual fixture on long press.',
            controller: controller),
        child: GestureDetector(
         onLongPress: (){
           shareSimpleFixture(context, fixture);
         },
         child: Container(
         height: 56,
         margin: EdgeInsets.symmetric(vertical: 4),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(8),
           child:
           Scrollable(
             viewportBuilder: (context, position) {
               return Slidable(
                 endActionPane: ActionPane(
                   motion: const ScrollMotion(),
                   // All actions are defined in the children parameter.
                   children:   [
                     // A SlidableAction can have an icon and/or a label.
                     SlidableAction(
                       onPressed: (context){
                         setState(() {
                           // Set the content of the New Fixture Field to previous values of the Fixture
                           newFixtureScore1Controller.text = fixture.score1.toString();
                           newFixtureScore2Controller.text = fixture.score2.toString();
                           newFixtureScore3Controller.text = fixture.score3.toString();
                           newFixtureScore4Controller.text = fixture.score4.toString();
                           newFixtureScore5Controller.text = fixture.score5.toString();
                           newFixtureScore6Controller.text = fixture.score6.toString();
                           house = fixture.house;
                           newDate = date;
                           gameStatus = fixture.gamestatus;

                           addNewFixture = true;
                         });
                       },
                       backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                       foregroundColor: Colors.black,
                       label: 'Edit',
                       icon: CupertinoIcons.pencil,

                     ),

                     SlidableAction(
                       onPressed: (context)
                         {
                           deleteFixture(widget.userModel!.getAuthToken(), fixture);
                           alert(context,
                               "Fixture Deleted! id: ${fixture.id}, Season Name: Season ${fixture.seasonID}");
                           setState(() {
                             currentSeason!.fixture!.remove(fixture);
                           });
                         } ,
                       backgroundColor: Colors.red,
                       foregroundColor: Colors.white,
                       label: 'Delete',
                       icon: CupertinoIcons.bin_xmark_fill,
                       // icon:
                       // ImageIcon(
                       //   AssetImage( "assets/edit_red.png")
                       //  ),
                     ),

                     SlidableAction(
                       onPressed: (context){
                          showCommentFixtureModal(fixture, fixture.comment);
                         // setState(() {
                         // });
                       },
                       backgroundColor: Colors.grey,
                       foregroundColor: Colors.black,
                       label: 'Com.',
                       icon: CupertinoIcons.mail_solid,
                       // icon:
                       // ImageIcon(
                       //   AssetImage( "assets/message.png")
                       //  ),
                     ),
                   ],
                 ),
                 child: Builder(
                   builder: (context) {
                     return Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           child: Center(
                             child: boldText(
                               status,
                               color: white,
                               size: 10,
                             ),
                           ),
                           width: 13,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(8),
                               bottomLeft: Radius.circular(8),
                             ),
                             color: color,
                           ),
                         ),
                         horizontalSpace(width: 4),
                         Column(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             rMediumText(date, size: 10),
                             RichText(
                               text: TextSpan(
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 10,
                                   fontFamily: App.font_name2,
                                 ),
                                 children: [
                                   TextSpan(
                                     text: "VS ",
                                     style: TextStyle(
                                       color: red,
                                       fontSize: 10,
                                       fontFamily: App.font_name2,
                                     ),
                                   ),
                                   TextSpan(text: opponent),
                                 ],
                               ),
                             ),
                             rMediumText(venue, color: blue, size: 10),
                           ],
                         ),
                         Spacer(),
                         rMediumText("$score1", size: 10),
                         Spacer(),
                         rMediumText("$score2", size: 10),
                         Spacer(),
                         rMediumText("$score3", size: 10),
                         Spacer(),
                         rMediumText("$score4", size: 10),
                         Visibility( visible:fixture5Visible ,child: Spacer()),
                         Visibility( visible:fixture5Visible ,child:   rMediumText("$score5", size: 10)),
                         Visibility( visible:fixture6Visible ,child: Spacer()),
                         Visibility( visible:fixture6Visible ,child:   rMediumText("$score6", size: 10)),
                          horizontalSpace(width: 15),
                          GestureDetector(
                              onTap: (){
                                print("plz open");
                                Slidable.of(context)!.openEndActionPane();
                                },
                              child: Container(
                                  height: 50,
                                  width: 20,
                                child:
                               ( fixture.comment ?? "") == "" ?
                                Icon( Icons.more_vert   )
                                : Center(
                                   child: Text("C", textAlign: TextAlign.center,),
                                )

                               //

                              ))

                       ],
                     );
                   }
                 ),
               );
             }
           ),

         ),
         decoration: BoxDecoration(
           color: white,
           borderRadius: BorderRadius.circular(8),
         ),
    ),
          ),
      );
  }

  Widget buildFixtureValueField(TextEditingController controller) {
    return TextField(
      onTap: () {
        if (isAll)
          alert(context,
              "Please Select a Season, in order to save your new fixture!");
        setState(() {
          addNewFixture = true && !isAll;
        });
      },
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: App.font_name2,
        // color: Colors.black,
      ),
      // autofillHints: opponents,
      decoration: InputDecoration(
        hintText: "0",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(2.0),
        hintMaxLines: 1,
      ),
    );
    return Container(
      height: 25,
      width: 36,
      child: Center(
        child: TextFormField(
          onTap: () {
            if (isAll)
              alert(context,
                  "Please Select a Season, in order to save your new fixture!");
            setState(() {
              addNewFixture = true && !isAll;
            });
          },
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: App.font_name2,
              color: Colors.black),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: Color.fromRGBO(228, 228, 228, 1) //rgba(228, 228, 228, 1)
            ),
      ),
    );
  }

  Widget buildSeasonTitleField(
      TextEditingController controller, String? initialValue) {
    return Container(
      height: 30,
      width: 50,
      child: Center(
        child: TextFormField(
          onTap: () {
            if (isAll)
              alert(context, "Please, Select a Season you which to edit");
          },
          controller: controller,
          // initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: App.font_name2,
              fontSize: 12,
              color: Colors.black),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: Color.fromRGBO(228, 228, 228, 1) //rgba(228, 228, 228, 1)
            ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var sportLists = widget.userModel!.getUserDetails()!.sport!.sport!;
    if(selectedSport == "")selectedSport =  sportLists[0];
    if (seasonsData == null) loadSeasonsData(selectedSport);
  }

  loadSeasonsData(String sport)   {
    seasonsData = fetchSeasons(widget.userModel!.getAuthToken(), sport) ;
    setState(() {
    });
   }

 void emptyControllers(){
   setState(() {
     newFixtureScore1Controller.text = "";
     newFixtureScore2Controller.text = "";
     newFixtureScore3Controller.text = "";
     newFixtureScore4Controller.text = "";
     newFixtureScore5Controller.text = "";
     newFixtureScore6Controller.text = "";
   });
 }

  bool createNewFixture() {
    if (newFixtureScore1Controller.text.isEmpty &&
        newFixtureScore2Controller.text.isEmpty &&
        newFixtureScore3Controller.text.isEmpty &&
        newFixtureScore4Controller.text.isEmpty &&
        newFixtureScore5Controller.text.isEmpty &&
        newFixtureScore6Controller.text.isEmpty) {
      alert(context, "All Fields are Empty");
      return false;
    } else {
      int score1 = int.parse("0${newFixtureScore1Controller.text}");
      int score2 = int.parse("0${newFixtureScore2Controller.text}");
      int score3 = int.parse("0${newFixtureScore3Controller.text}");
      int score4 = int.parse("0${newFixtureScore4Controller.text}");
      int score5 = int.parse("0${newFixtureScore5Controller.text}");
      int score6 = int.parse("0${newFixtureScore6Controller.text}");

      if(!fixture5Visible)  score5 = 0;
      if(!fixture6Visible)  score6 = 0;



      String opposition = oppositionController.text;
      opponents.add(opposition);

      Fixture newFixture = Fixture(
          userid: currentSeason!.userid,
          seasonID: currentSeason!.id,
          score1: score1,
          score2: score2,
          score3: score3,
          score4: score4,
          score5: score5,
          score6: score6,
          dateplayed: newDate,
          house: house,
          opponent: opposition,
          gamestatus: gameStatus);

      setState(() {
        changingSport = false;
        currentSeason!.addNewFixture(newFixture);
        needToShowToolTipSoloFixture = true;
      });

      createFixture(widget.userModel!.getAuthToken(), newFixture);
    }

    emptyControllers();
    return true;
  }

  bool updateSeasonsTitles() {
    if (seasonTitle1Controller.text.isEmpty &&
        seasonTitle2Controller.text.isEmpty &&
        seasonTitle3Controller.text.isEmpty &&
        seasonTitle4Controller.text.isEmpty &&
        seasonTitle5Controller.text.isEmpty &&
        seasonTitle6Controller.text.isEmpty

    ) {
      alert(context, "All Fields are Empty");
      return false;
    } else {
      String title1 = !seasonTitle1Controller.text.isEmpty ? seasonTitle1Controller.text : (currentSeason?.title1 ?? "");
      String title2 = !seasonTitle2Controller.text.isEmpty ? seasonTitle2Controller.text : (currentSeason?.title2 ?? "");
      String title3 = !seasonTitle3Controller.text.isEmpty ? seasonTitle3Controller.text : (currentSeason?.title3 ?? "");
      String title4 = !seasonTitle4Controller.text.isEmpty ? seasonTitle4Controller.text : (currentSeason?.title4 ?? "");
      String title5 = !seasonTitle5Controller.text.isEmpty ? seasonTitle5Controller.text : (currentSeason?.title5 ?? "");
      String title6 = !seasonTitle6Controller.text.isEmpty ? seasonTitle6Controller.text : (currentSeason?.title6 ?? "");

      setState(() {
        currentSeason!.title1 = title1;
        currentSeason!.title2 = title2;
        currentSeason!.title3 = title3;
        currentSeason!.title4 = title4;
        currentSeason!.title5 = title5;
        currentSeason!.title6 = title6;
      });

      updateSeasonInfo(widget.userModel!.getAuthToken(), currentSeason!.id,
          title1, title2, title3, title4,title5,title6);
    }
    return true;
  }

  Future<void> addCommentToFixture(Fixture fixture, String? comment) async {
      await updateCommentFixture(widget.userModel!.getAuthToken(), fixture.id, comment ?? "");
      await loadSeasonsData(selectedSport);

      setState(() {
       var index=  currentSeason!.fixture!.indexOf(fixture);
       fixture.comment = comment;
       currentSeason!.fixture![index] = fixture;
      });
  }

  void createNewSeason(String sport) async {

    Season? newSeason = await createSeason(widget.userModel!.getAuthToken(), sport);
    await loadSeasonsData(selectedSport);
    currentSeason = newSeason;
    changingSport = true; // not realy but i can be good to reload it like that.
    await Future.delayed(Duration(seconds: 1));
    setState(() {
    });
    emptyControllers();
    toast("New Season Created");
  }
  void showNextFixture(BuildContext context){
    if(!fixture5Visible) {
      showEditFixtureModal(
        context: context,
        controller: seasonTitle5Controller,
        currentSeason: currentSeason,
        currentTitle: currentSeason?.title5 ?? "",
        force: true
      );
    }else if(!fixture6Visible) {
      showEditFixtureModal(
          context: context,
          controller: seasonTitle6Controller,
          currentSeason: currentSeason,
          currentTitle: currentSeason?.title6 ?? "",
          force: true
      );
    }

  }



  void showEditFixtureModal({required BuildContext context, required TextEditingController controller,  Season? currentSeason, String? currentTitle, bool force = false}) {
    if (!force && (currentSeason?.fixture?.length ?? 0) > 0) {
      showDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Error'),
            actions: [
              CupertinoDialogAction(
                child: Text('Ok'),
                 onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: Text('You cannot change the titles after adding data.'),
          );
        },
      );
    } else {
      showDialog<bool>(
        context: context,
        builder: (context) {
          controller.text =
              (controller.text == "" ? currentTitle : controller.text) ?? "";
          return CupertinoAlertDialog(
            title: Text('New title'),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Save'),
                onPressed: () {
                  updateSeasonsTitles();
                  Navigator.pop(context);
                },
              ),
            ],
            content: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  CupertinoTextField
                    (
                      controller: controller,
                      autofocus: true,
                      maxLength: 8
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void showCommentFixtureModal(Fixture fixture, String? comment){
    print("triyng to show comment ${comment}");
    TextEditingController cont = TextEditingController();
    showDialog<bool>(
      context: context,
      builder: (context) {
        cont.text =  (cont.text == "" ? comment : cont.text) ?? "";
        return CupertinoAlertDialog(
          title: Text('Comment'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text('Save'),
              onPressed: () {
               addCommentToFixture(fixture,cont.text);
                Navigator.pop(context);
              },
            ),
          ],
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                CupertinoTextField
                  (
                    controller: cont,
                    autofocus: true,
                    placeholder: "Position played, score out of 10",
                    maxLines: 4
                ),
              ],
            ),
          ),
        );
      },
    );
  }




}


Future<Uint8List> addPixelsOnTop(Uint8List imageData, int height) async {
  ui.Image? originalImage = ui.decodeImage(imageData);
  ui.Image newImage = ui.Image(originalImage?.width ?? 0, height) ;

  int offset = height - originalImage!.height ;
  ui.drawImage(newImage, originalImage, dstY: offset);

  return Uint8List.fromList(ui.encodePng(newImage));
}