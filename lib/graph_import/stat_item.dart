import 'package:cme/app.dart';
import 'package:cme/network/coach_stat/coach_stats_network_helper.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/stats_controller.dart';

class StatItem extends StatefulWidget {
  final String title;
  final List<double> current;
  final List<double?> target;
  final String img;
  final List<Widget> charts;
  final bool hidetarget;
  final bool hideAddRecord;
  final bool hideTop;
  final bool showButton3;
  final TargetType targetType;
  final int? statsId;
  final String? userToken;
  final Function? onEditPerformanceStat;
  final Function? onAddRecord;
  final Function? onAddToHome;
  final Function? onEditStats;

  const StatItem({
    Key? key,
    this.hideTop = false,
    required this.charts,
    required this.title,
    required this.current,
    required this.target,
    required this.targetType,
    required this.img,
    this.userToken,
    this.showButton3 = false,
    this.hidetarget = false,
    this.statsId,
    this.onEditPerformanceStat,
    this.onAddRecord,
    this.onAddToHome,
    this.onEditStats,
    this.hideAddRecord = false,
  }) : super(key: key);
  @override
  _StatItemState createState() => _StatItemState();
}

class _StatItemState extends State<StatItem> {
  TextEditingController targetController = TextEditingController();
  TextEditingController recordController = TextEditingController();
  late List<double> current;
  late List<double?> target;

  List<String> l = [
    "Weekly",
    "Month",
    "Year",
  ];

  bool isEdit = false;
  bool isAddRecord = false;
  int catIndex = 1;


  @override
  Widget build(BuildContext context) {
    current = widget.current;
    target = widget.target;
    targetController = TextEditingController(text: "${target.last}");
    recordController = TextEditingController(text: "${current.last}");


    print("i'm showing tartget :${target}");


    return isEdit ? buildEditTarget() : isAddRecord ? buildAddRecord() : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: buildContainer(
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent.withOpacity(.8),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                          child: boldText(widget.title, color: Colors.white, size: 24,
                              textOverflow: TextOverflow.ellipsis),),
                      if (widget.showButton3)
                        TextButton(
                          onPressed: () {
                            if (widget.onAddToHome != null) widget.onAddToHome!();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/plus.png",
                                height: 11.5,
                                width: 11.5,
                              ),
                              horizontalSpace(width: 5.5),
                              mediumText(
                                "Add to Home",
                                size: 12,
                                color: white,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Visibility(
                    visible: !widget.hideTop,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                catIndex = index;
                              });
                            },
                            child: catIndex == index
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromRGBO(26, 87, 234, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: lightText(
                                        l[index].toUpperCase(),
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  )
                                : boldText(
                                    l[index].toUpperCase(),
                                    color: Colors.white,
                                    size: 14,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.charts[widget.charts.length > 1 ? catIndex : 0],
                  Visibility(
                    visible: !widget.hidetarget,
                    child: Row(
                      children: [
                        RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                              text: "${current[catIndex].round()}\n",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Current",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                        ),
                        Spacer(),
                        RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${target[catIndex]!.round() }\n",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Target",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider(color: white),
            Container(
              color: white,
              width: double.infinity,
              height: 1,
            ),
            Flex(
              direction: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: white)),
                    ),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(color:white )
                        ),
                        onPressed: () {
                          setState(() {
                            isEdit = !isEdit;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/edit_red.png",
                              width: 12,
                              height: 12,
                              color: white,
                            ),
                            horizontalSpace(),
                            Text("Set target "),
                          ],
                        )),
                  ),
                ),
                VerticalDivider(
                  color: white,
                ),
                if(!widget.hideAddRecord)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: white)),
                    ),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(color:white )
                        ),
                        onPressed: () {
                          setState(() {
                            isAddRecord = !isAddRecord;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 12,),
                            horizontalSpace(),
                            Text("Add record"),
                          ],
                        )),
                  ),
                ),
                VerticalDivider(
                  color: white,
                ),
                Expanded(
                  child: TextButton(
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(color:white )
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/stats_share.png",
                            width: 12,
                            height: 12,
                            color: white,
                          ),
                          horizontalSpace(),
                          Text("Share"),
                        ],
                      )),
                ),
                VerticalDivider(
                  color: white,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  Widget buildContainer({Widget? child}) {
    return Container(
      child: child,
      // height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
            image: AssetImage(widget.img),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(deepBlue, BlendMode.color)),
      ),
    );
  }

  Widget buildEditTarget() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(3, 12, 30, 1) //rgba(3, 12, 30, 1)
          ),
      child: Column(
        children: [
          verticalSpace(height: 8),
          Center(child: boldText(widget.title, size: 24, color: white)),
          verticalSpace(height: 16),
          Row(
            children: [
              Text("Target",
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: white,
                  )),
              Spacer(),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 8, 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: white),
                      borderRadius: BorderRadius.circular(8)),
                  child: buildTargetInputField(
                      controller: targetController,
                      topLabel:
                          ''), // rLightText(widget.target, color: white, size: 16),
                ),
              ),
            ],
          ),
          verticalSpace(),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Tip",
                        style: TextStyle(
                          fontFamily: App.font_name,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: white,
                        )),
                    horizontalSpace(),
                    Tooltip(
                      decoration: BoxDecoration(color: Colors.white),
                      textStyle: TextStyle(
                        fontFamily: App.font_name,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      message:
                          "Expert: High level qualifications/ High level experience as a COACH i.e. 10 years +\n"
                          "Professional: Advanced level qualifications or coaching/playing experience 5 years +\n"
                          "Intermediate: General level qualification or coaching/playing experience 2 years+\n"
                          "Beginner: entry level qualification or coaching/playing experience 1 year+\n",
                      child: Image.asset(
                        "assets/info_red.png",
                        height: 12,
                        color: Colors.red,
                        width: 12,
                      ),
                    )
                  ],
                ),
                verticalSpace(),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: App.font_name,
                          fontWeight: FontWeight.w100),
                      children: [
                        TextSpan(text: "You need "),
                        TextSpan(
                            text: "52 Sessions",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                " your current rate of £100 to achieve your target"),
                      ]),
                ),
              ],
            ),
          ),
          verticalSpace(height: 64),
          proceedButton(
            text: "Save",
            onPressed: () {
              if (targetController.text != '') {
                double targetValue = double.parse(targetController.text.trim());
                setState(() {
                  isEdit = !isEdit;
                });
                if (widget.onEditPerformanceStat != null)
                  widget.onEditPerformanceStat!(targetValue);
                else {
                  saveTarget(targetValue);
                  Future.delayed(Duration(seconds: 10)).then((value) => () {
                        widget.onEditStats!(targetValue);
                      });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildAddRecord() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(3, 12, 30, 1) //rgba(3, 12, 30, 1)
          ),
      child: Column(
        children: [
          verticalSpace(height: 8),
          Center(child: boldText(widget.title, size: 24, color: white)),
          verticalSpace(height: 16),
          Row(
            children: [
              Text("Record",
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: white,
                  )),
              Spacer(),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 8, 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: white),
                      borderRadius: BorderRadius.circular(8)),
                  child: buildTargetInputField(
                      controller: recordController,
                      topLabel:
                          ''), // rLightText(widget.target, color: white, size: 16),
                ),
              ),
            ],
          ),
          verticalSpace(height: 64),
          proceedButton(
            text: "Save",
            onPressed: () {
              if (recordController.text != '') {
                double recordValue = double.parse(recordController.text.trim());
                setState(() {
                  isAddRecord = !isAddRecord;
                });
          if(widget.onAddRecord != null){
            widget.onAddRecord!(recordValue);
          }else {
            saveRecord(recordValue);
            Future.delayed(Duration(seconds: 10)).then((value) =>
                () {
              widget.onEditStats!(recordValue);
            });
          }
                }

            },
          ),
        ],
      ),
    );
  }

  saveTarget(double targetValue) async {
    // TODO: You should be able to use this to update the target in case the other method doesn't work

    await updateTarget(widget.userToken, widget.targetType, targetValue)
        .then((value) => (value) {
              if (value["Status"] = true) {
                print("Done! Update Target");
                toast("Target updated successfully!");
              }
            })
        .catchError((error) {
      toast("An Error occurred");
      print("Update Target Error");
      print(error);
    });
  }

  saveRecord(double recordValue) async {
    // TODO: You should be able to use this to update the record in case the other method doesn't work

    // await updateTarget(widget.userToken, widget.targetType, recordValue)
    //     .then((value) => (value) {
    //           if (value["Status"] = true) {
    //             print("Done! Update Record");
    //             toast("Record updated successfully!");
    //           }
    //         })
    //     .catchError((error) {
    //   toast("An Error occurred");
    //   print("Update Record Error");
    //   print(error);
    // });


  }

  Widget buildTargetInputField(
          {required TextEditingController controller,
          required String topLabel}) =>
      Container(
        child: Material(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontFamily: App.font_name2,
                  color: Colors.white),
            ),
          ),
        ),
      );
}
