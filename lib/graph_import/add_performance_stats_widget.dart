import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/ui_widgets/performance_stats_item.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../controllers/stats_controller.dart';
import 'custom_time_drodown.dart';

class AddPerformanceStats extends StatefulWidget {
  final UserModel? userModel;
  final Function? stateParser;

  AddPerformanceStats(this.userModel, {this.stateParser});

  @override
  _AddPerformanceStatsState createState() => _AddPerformanceStatsState();
}

class _AddPerformanceStatsState extends State<AddPerformanceStats> {
  bool addItem = false;
  Color b = Color.fromRGBO(3, 12, 30, 1);
  String category = "Football";
  String goal = "Hours of Training";
  double? target = 12;
  TextEditingController targetController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  bool otherGoalVisible = false;

  @override
  Widget build(BuildContext context) {
    return addItem
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: boldText(
                    "Add Your Stats",
                    color: white,
                    size: 24,
                  ),
                ),
                verticalSpace(height: 15),
                Row(
                  children: [
                    mediumText("Sport", color: white, size: 16),
                    Spacer(),
                    Container(
                      height: 30,
                      child: CustomDropDownWithFeedBack(
                        selectedItem: category,
                        item: ["Football", "Rugby", "Personal"],
                        bgColor2: Colors.white,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        bgColor: b,
                        textColor: Colors.black,
                        onSelection: (value) {
                          setState(() {
                            category = value;
                          });
                          // toast(msg: "Selected Item is: $titlePosition");
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace(height: 10),
                Row(
                  children: [
                    mediumText("Activity", color: white, size: 16),
                    Spacer(),
                    Container(
                      height: 30,
                      child: CustomDropDownWithFeedBack(
                        selectedItem: goal,
                        bgColor2: Colors.white,
                        item: [
                          "Hours of Training",
                          "Squats Completed",
                          "Sprints Completed",
                          "Other"
                        ],
                        padding: EdgeInsets.only(left: 8, right: 8),
                        bgColor: Colors.white,
                        textColor: Colors.black,
                        onSelection: (value) {
                          setState(() {
                            if (value == "Other") {
                              otherGoalVisible = true;
                            } else
                              otherGoalVisible = false;
                            goal = value;
                          });
                          // toast(msg: "Selected Item is: $titlePosition");
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace(height: 10),
                Visibility(
                  visible: otherGoalVisible,
                  child: Row(
                    children: [
                      // mediumText("Category", color: white, size: 16),
                      Spacer(),
                      Expanded(
                        child: Container(
                          height: 30,
                          width: 70,
                          margin: EdgeInsets.only(left: 8.0),
                          padding: EdgeInsets.only(left: 4.0),
                          alignment: Alignment.topLeft,
                          child: TextField(
                            onTap: () {},
                            controller: goalController,
                            // initialValue: initialValue,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: App.font_name2,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Color.fromRGBO(
                                    255, 255, 255, 1.0) //rgba(228, 228, 228, 1)
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: mediumText("Target", color: white, size: 16)),
                    Expanded(
                      child: Container(
                        height: 30,
                        width: 70,
                        margin: EdgeInsets.only(left: 8.0),
                        padding: EdgeInsets.only(left: 4.0),
                        alignment: Alignment.topLeft,
                        child: TextField(
                          onTap: () {},
                          controller: targetController,
                          // initialValue: initialValue,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: App.font_name2,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromRGBO(
                                  255, 255, 255, 1.0) //rgba(228, 228, 228, 1)
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Obx(() {
                    return ScopedModel<UserModel>(
                      model: Get
                          .find<StatsController>()
                          .currentUserModel
                          .value,
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              addItem = false;
                              target = targetController.text != ''
                                  ? double.tryParse(targetController.text)
                                  : 0;
                              if (otherGoalVisible) goal = goalController.text;
                              toast(
                                  "Category: $category \n Goal: $goal \n Target: $target");
                            });
                            await createNewPerformanceStat();

                            widget.stateParser!(false);

                            //TODO ADD FUNCTION FOR UPLOAD .....
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                                child: boldText("Save", size: 19, color: white)),
                            decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }),
                    );
                  }
                ),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      addItem = true;
                      widget.stateParser!(true);
                    });
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    child: DottedBorder(
                      color: white,
                      strokeWidth: 2,
                      dashPattern: [16, 4],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Image.asset(
                            "assets/plus.png",
                            color: white,
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpace(height: 16),
                boldText("Add Your Stats", color: white, size: 24)
              ],
            ),
          );
  }

  Future createNewPerformanceStat() async {
    toast("Creating Performance Stat... ");

    int statIndex = Get.find<StatsController>().currentUserModel.value.getPerformanceStats().indexWhere((element) => element.category == category);

    if(statIndex == -1) {
      createPlayerPerformanceStats(
          token: Get
              .find<StatsController>()
              .currentUserModel
              .value
              .getAuthToken()!,
          target: target,
          goal: goal,
          category: category)
          .then((value) =>
          () {
        toast("Performance Stats Created Successfully");
        widget.stateParser!(false);
      })
          .catchError((onError) {
        toast("An Error occurred while creating in our databse");
        print("PlayerPerformance Creation Error: ");
        print(onError);
        widget.stateParser!(false);
      });
      Get.find<StatsController>().currentUserModel.value
          .addPlayerPerformance(
          performanceStat: PlayerPerformanceStat(goal: goal, target: target, category: category,
              id: Get.find<StatsController>().currentUserModel.value.getPerformanceStats().length));
    }else {
      await updatePlayerPerformanceStats(
          token: Get
              .find<StatsController>()
              .currentUserModel
              .value
              .getAuthToken()!,
          target: target,
          goal: goal,
          category: category,
          statid: Get
              .find<StatsController>()
              .currentUserModel
              .value
              .getPerformanceStats()
              .elementAt(statIndex)
              .id)
          .then((value) =>
          (value) {
        toast("Stats Updated Successfully");
        print("Stats Updated Successfully $value");
      })
          .catchError((error) {
        toast("An Error occurred");
        print("Update Target Error");
        print(error);
      });
      Get.find<StatsController>().currentUserModel.value.getPerformanceStats().elementAt(statIndex).target = target;

    }
    Get.find<StatsController>().currentUserModel.refresh();
  }
}
