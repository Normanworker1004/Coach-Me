import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach/diary/fetch_diary_unavailability_response.dart';
import 'package:cme/network/coach/dairy/diary_request.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class AvailabilityEditor extends StatefulWidget {
  final UserModel? userModel;
  final DiaryDetails? diaryDetails;

  const AvailabilityEditor({
    Key? key,
    required this.userModel,
    required this.diaryDetails,
  }) : super(key: key);
  @override
  _AvailabilityEditorState createState() => _AvailabilityEditorState();
}

class _AvailabilityEditorState extends State<AvailabilityEditor> {
  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey<ScaffoldMessengerState>();
  List<String> daysOption = [
    "Tomorrow",
    "Daily",
    "Mon - Fri",
    "Sat - Sun",
    "Custom",
  ];
  int? selectedDay;
  UserModel? userModel;

  List<DateTime> selectedDatesList = [];
  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();

  DateTime? fromTime;
  DateTime? toTime;

  bool isLoading = false;
  bool isAllday = true;

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    if (widget.diaryDetails != null) {
      var de = widget.diaryDetails;
      for (var i = 0; i < daysOption.length; i++) {
        if (de!.availableType == daysOption[i].toLowerCase()) {
          selectedDay = i;
          break;
        }
      }

      var d = Jiffy(de!.unavailablestart);
      var dd = Jiffy(de!.unavailableend);
      fromTime = DateTime(d.year, d.month, d.day, d.hour);
      toTime = DateTime(dd.year, dd.month, dd.day, dd.hour);

    } else {
      var d = DateTime.now();
     // fromTime = DateTime(d.year, d.month, d.day, d.hour);
    //  toTime = fromTime!.add(Duration(hours: 1));

      fromTime = DateTime(d.year, d.month, d.day, 0, 0, 0);
      toTime = DateTime(d.year, d.month, d.day, 23, 0, 0) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _key,
      child: buildBaseScaffold(
          context: context, body: buildBody(context), title: "SET UNAVAILABILITY"),
    );
  }

  Widget calendar() {
    return Container(
      child: Column(
        children: [
          CalendarCarousel<Event>(
            minSelectedDate: DateTime.now().subtract(Duration(days: 2)),
            pageSnapping: false,
            onCalendarChanged: (DateTime d) {
              setState(() {
                currentDate = d;
                targetDate = d;
              });
            },
            onLeftArrowPressed: () {
              setState(() {
                targetDate = DateTime(targetDate.year, targetDate.month - 1);
                currentDate = targetDate;
              });
            },
            onRightArrowPressed: () {
              setState(() {
                targetDate = DateTime(targetDate.year, targetDate.month + 1);
                currentDate = targetDate;
              });
            },
            headerTextStyle: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 32, color: Colors.black),
            leftButtonIcon: Center(
              child: Text(
                DateFormat('MMMM')
                    .format(DateTime(currentDate.year, currentDate.month - 1)),
                softWrap: false,
                // textDirection: TextDirection.RTL,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.grey),
              ),
            ),
            rightButtonIcon: Center(
              child: Text(
                DateFormat('MMMM')
                    .format(DateTime(currentDate.year, currentDate.month + 1)),
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.grey),
              ),
            ),
            onDayPressed: (DateTime date, List<Event> events) {
              // print(date);
              this.setState(() {
                if (selectedDatesList.contains(date)) {
                  selectedDatesList.remove(date);
                } else {
                  selectedDatesList.add(date);
                }
              });
            },
            //selectedDateTime: currentDate,
            //targetDateTime: targetDate,
            weekendTextStyle: TextStyle(color: Colors.black),
            weekdayTextStyle: TextStyle(color: Colors.black),
            thisMonthDayBorderColor: Colors.transparent,
            customDayBuilder: (bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day) {
              if (selectedDatesList.contains(day)) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(25, 87, 234, 1),
                  ),
                  // color: Colors.blue,
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle(color: white),
                    ),
                  ),
                );
              }
              return null;
            },
            weekFormat: false,
            height: 335.0,
            daysHaveCircularBorder: true,
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Specific time",
                  style: TextStyle(
                    color: isAllday ? Colors.grey : Color.fromRGBO(    25, 87, 234, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CupertinoSwitch(
                    activeColor: Color.fromRGBO(
                        25, 87, 234, 1), //rgba(25, 87, 234, 1)
                    value: isAllday,
                    onChanged: (c) {
                      setState(() {
                        isAllday = c;
                        if(isAllday){
                          DateTime now = DateTime.now();
                          fromTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
                          toTime = DateTime(now.year, now.month, now.day, 23, 0, 0) ;
                        }
                      });
                    }),
                Text(
                  "All day",
                  style: TextStyle(
                    color: isAllday ? Color.fromRGBO(    25, 87, 234, 1) : Colors.grey ,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
            verticalSpace(height: 16),
            Visibility(
              visible: !isAllday,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      child: CupertinoDatePicker(
                          initialDateTime: fromTime,
                          mode: CupertinoDatePickerMode.time,
                          maximumDate: toTime!.subtract(Duration(hours: 1)),
                          minuteInterval: 30,
                          onDateTimeChanged: (d) {
                            // print(d);
                            if (d.add(Duration(hours: 1)).isAfter(toTime!)) {
                              toTime = d.add(Duration(hours: 1));
                            }
                            setState(() {
                              fromTime = d;
                            });
                          }),
                    ),
                  ),
                  horizontalSpace(),
                  rLightText("TO", size: 24, color: blue),
                  horizontalSpace(),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: CupertinoDatePicker(
                          initialDateTime: toTime,
                          minuteInterval: 30,
                          minimumDate: fromTime!.add(Duration(hours: 1)),
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (d) {
                            setState(() {
                              toTime = d;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(height: 16),
            boldText("Choose Day"),
            Divider(),
            Column(
              children: List.generate(
                daysOption.length,
                (index) => InkWell(
                  onTap: () {
                    if (selectedDay != 4) {
                      selectedDatesList = [];
                    }
                    setState(() {
                      selectedDay = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                          child: Center(
                              child: Visibility(
                                  child: Image.asset(
                            "assets/check.png",
                            height: 7,
                          ))),
                          height: 16,
                          width: 16,
                          decoration: selectedDay == index
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: red)
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: red),
                                ),
                        ),
                        horizontalSpace(),
                        rBoldText(daysOption[index], size: 14)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            verticalSpace(),
            Visibility(
                visible: selectedDay == 4,
                child: calendar()), //CustomCalendarView()),
            verticalSpace(height: 64),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: proceedButton(
            isLoading: isLoading,
            text: "Save",
            onPressed: () => widget.diaryDetails != null
                ? updateAvailabiity(context)
                : saveAvailabiity(context),
          ),
        )
      ],
    );
  }

  saveAvailabiity(BuildContext context) async {
    if (selectedDay == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    print("START....b");
    var res = await addCoachDairyUnavailability(
      userModel!.getAuthToken()!,
      booking: "unavailable",
      bookingid: 1, //default
      unavailablestart: selectedDay != 4
          ? dateDiary(DateTime.now(), fromTime!)
          : dateDiary(selectedDatesList.first, fromTime!),
      unavailableend: selectedDay != 4
          ? dateDiary(DateTime.now(), toTime!)
          : dateDiary(selectedDatesList.last, toTime!),
      availableType: daysOption[selectedDay!].replaceAll(" ", "").toLowerCase(),
      timingstart: DateFormat.Hm().format(fromTime!),
      timingend: DateFormat.Hm().format(toTime!),
    );
    print("END....");
    if (res.status!) {
      Navigator.pop(context);
    } else {
      showSnack(context, "Error saving unavailability");
    }

    setState(() {
      isLoading = false;
    });
  }

  updateAvailabiity(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    print("START....a");
    var res = await editCoachDairyUnavailability(
      userModel!.getAuthToken()!,
      booking: "unavailable",
      bookingid: 1, //default
      unavailablestart: selectedDay != 4
          ? dateDiary(DateTime.now(), fromTime!)
          : dateDiary(selectedDatesList.first, fromTime!),
      unavailableend: selectedDay != 4
          ? dateDiary(DateTime.now(), toTime!)
          : dateDiary(selectedDatesList.last, toTime!),
      availableType: daysOption[selectedDay!].replaceAll(" ", "").toLowerCase(),
      timingstart: DateFormat.Hm().format(fromTime!),
      timingend: DateFormat.Hm().format(toTime!),
      unavailibilityID: widget.diaryDetails!.id,
    );
    print("END....${res.status}");
    if (res.status ?? false) {
      Navigator.pop(context);
    } else {
      showSnack(context, "Error saving unavailability");
    }

    setState(() {
      isLoading = false;
    });
  }
}
