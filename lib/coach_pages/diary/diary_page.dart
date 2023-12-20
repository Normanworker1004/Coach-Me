import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/diary/availability_dashboard.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/dairy/diary_request.dart';
import 'package:cme/network/coach/dairy/dairy_function.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_booking_list_tile.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class CoachDiaryPage extends StatefulWidget {
  final UserModel? userModel;

  const CoachDiaryPage({Key? key, required this.userModel}) : super(key: key);

  @override
  _CoachDiaryPageState createState() => _CoachDiaryPageState();
}

class _CoachDiaryPageState extends State<CoachDiaryPage> {
  // var selectedTimeSlotList;
  var dairyJsonResopnse;
  List<DateTime>? selectedDatesList = [];

  DateTime? selectedDate;
  UserModel? userModel;

  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();

  DayReport? displayDateReport;

  Widget calendar() {
    return Container(
      child: CalendarCarousel<Event>(
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
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey),
          ),
        ),
        rightButtonIcon: Center(
          child: Text(
            DateFormat('MMMM')
                .format(DateTime(currentDate.year, currentDate.month + 1)),
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey),
          ),
        ),
        onDayPressed: (DateTime date, List<Event> events) {
          print(date);
          displayDateReport =  filterDairyForDay(dairyJsonResopnse, date: dateToString3(date));
          print("ALLDAY????? :: ${displayDateReport?.unAvailableAllDay}" );
          this.setState(() {});
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
          var displayDate = displayDateReport!.date;
          if ((displayDate.year == day.year) &&
              (displayDate.month == day.month) &&
              (displayDate.day == day.day)) {
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
          if (isSelectable && selectedDatesList!.contains(day)) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
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
        height: 350.0,
        daysHaveCircularBorder: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    var d = DateTime.now();
    DateTime displayDate = DateTime(d.year, d.month, d.month);
    displayDateReport = DayReport(date: displayDate);
    displayDateReport!.data = List<DairyData?>.filled(24, null, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "YOUR DIARY",
      ),
    );
  }

  filterJson() {}

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        InkWell(
          onTap: () async {
            await pushRoute(
                context,
                AvailabilityDashboardPage(
                  userModel: userModel,
                ));
            setState(() {});
          },
          child: buildCard(
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    "assets/diary.png",
                    width: 32,
                    height: 32,
                  ),
                  horizontalSpace(),
                  Column(
                    children: [
                      boldText("Unavailability", size: 24),
                      lightText("Set Your Unavalability",
                          color: Colors.grey, size: 16),
                    ],
                  ),
                  Spacer(),
                  Icon(CupertinoIcons.forward)
                ],
              ),
            ),
          ),
        ),
        verticalSpace(),
        FutureBuilder(
            future: fetchMothCoachDairyUnavailability(userModel!.getAuthToken()!,
                date: dateToString2(currentDate)),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                dairyJsonResopnse = snapshot.data;
                selectedDatesList = filterDairyBookingDates(dairyJsonResopnse);
                print("dairyJsonResopnse ${dairyJsonResopnse}");
                displayDateReport = filterDairyForDay(
                  dairyJsonResopnse,
                  date: dateToString3(displayDateReport!.date),
                );
              }
              return dairyJsonResopnse == null
                  ? Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(),
                            verticalSpace(),
                            boldText("Fetching your diary...")
                          ],
                        ),
                      ),
                    )
                  :
              Column(
                      children: [
                        calendar(),
                        verticalSpace(),
                        Row(
                          children: [
                            boldText("${dateToString(displayDateReport!.date)}",
                                size: 17),
                            // Spacer(),
                            // lightText("Not Available", size: 17),
                            // horizontalSpace(width: 4),
                            // InkWell(
                            //   onTap: displayDateReport!.containsBooking
                            //       ? null
                            //       : () {
                            //           print("tapp,,,,");
                            //           setState(() {
                            //             // displayDayNotAvailable =
                            //             //     !displayDayNotAvailable;
                            //             // displayDateReport.unAvailableAllDay
                            //
                            //             //TODO (Set unavailabele all day)
                            //           });
                            //         },
                            //   child: buildCheckBox(
                            //       displayDateReport!.unAvailableAllDay,
                            //       activeColor: deepRed),
                            // )
                          ],
                        ),
                        verticalSpace(),
                        Column(
                          children: List.generate(
                            displayDateReport!.data.length,
                            (index) {
                              var d = displayDateReport!.date;
                              var c = DateTime(d.year, d.month, d.day, index);
                              var time = DateFormat("h:mma").format(c);
                              var details = displayDateReport!.data[index];

                              return buildDayReportItem(time, details);
                            },
                          ),
                        ),
                        // verticalSpace(height: 32),
                        // proceedButton(text: "Update Diary", onPressed: () {}),
                      ],
                    );
            }),
      ],
    );
  }

  Widget buildDayReportItem(time, DairyData? details) {
    // if(details)
    Userdetails? d = details?.playerDetails;
    return Row(
      children: [
        horizontalSpace(width: 16),
        Container(
          width: 64,
          child: Text(
            time,
            style: TextStyle(
              fontSize: 10,
              fontFamily: "ROBOTO",
            ),
          ),
        ),
        Container(
          height: 65,
          width: 2,
          color: Color.fromRGBO(74, 92, 208, 1), //rgba
        ),
        Expanded(
          child: details == null //|| details.booking == "unavailable"
              ? Container(
                  padding: EdgeInsets.all(16),
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: .5, color: Colors.grey.withOpacity(.5)),
                  ),
                  child: Row(
                    children: [
                      horizontalSpace(width: 16),
                      Expanded(
                        child: details != null  ? lightText("Not Available", size: 17) :  lightText("Available", size: 17),
                      ),
                      // horizontalSpace(width: 4),
                      // buildCheckBox(details != null, activeColor: deepRed)
                      // ,Spacer(),
                    ],
                  ),
                )
              : details.booking == "booking"
                  ? SessionDetailListTile(
                      imgUrl: "${photoUrl + d!.profilePic!}",
                      level: "${getSportLevel(d)}",
                      name: "${d.name}",
                      hideDots: true,
                      date: "Today, $time",
                      location: "${details.bookingLocation ?? 'Not set'}",
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: .5, color: Colors.grey.withOpacity(.5)),
                      ),
                      child: Row(
                        children: [
                          horizontalSpace(width: 16),
                          Expanded(
                            child: details != null  ? lightText("Not Available", size: 17) :  lightText("Available", size: 17),
                          ),
                            // horizontalSpace(width: 4),
                            // buildCheckBox(details != null, activeColor: deepRed)
                          // ,Spacer(),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  Widget buildCheckBox(isSelected, {activeColor = Colors.blue}) {
    return Container(
      height: 32,
      width: 32,
      child: Visibility(
          visible: isSelected, child: Icon(Icons.check, color: white)),
      decoration: isSelected
          ? BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: activeColor,
              border: Border.all(color: white),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey),
            ),
    );
  }
}
