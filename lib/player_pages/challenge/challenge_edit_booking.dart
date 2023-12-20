import 'dart:convert';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/map/pick_location.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/player/challenge.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/dropdowns/custom_time_drodown.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/address_function.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ChallengeEditBookingEditorPage extends StatefulWidget {
  final UserModel? userModel;
  final ChallengeBookingDetails bookingDetails;

  const ChallengeEditBookingEditorPage({
    Key? key,
    required this.userModel,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  _ChallengeEditBookingEditorPageState createState() =>
      _ChallengeEditBookingEditorPageState();
}

class _ChallengeEditBookingEditorPageState
    extends State<ChallengeEditBookingEditorPage> {
  List<DateTime> timeSlots = [];
  List<DateTime>? selectedTimeSlotList = [];
  String? selectedTimeSlot;

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  bool isPhysical = false;
  String selectedDropDownDate = "";
  int selectedBookingIndex = 0;
  BookingDates? selectedBookingDate;
  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();

  LatLng? currentLocation;
  String? bookingAddress = "Virtual";

  bool isLoading = false;

  String winCondition = "Best Out of 10";
  String? gamePlay = "First to Score wins";
  late ChallengeBookingDetails bDetails;
  initAll() {
    bDetails = widget.bookingDetails;

    try {
      //isPhysical ? "0" : "1",
      gamePlay = bDetails.gameplay;
      winCondition = "Best Out of ${bDetails.tryout}";

      if (bDetails.sessionmode == 0) {
        isPhysical = true;
        currentLocation =
            LatLng((bDetails.lat ?? 0.0) / 1.0, (bDetails.lon ?? 0.0) / 1.0);
        bookingAddress = "${bDetails.location}";
      }

      List d = bDetails.bookingDates!.split("T").first.split("-");
      List<int?> dateV =
          List.generate(d.length, (index) => int.tryParse(d[index]));

      print("completed...$dateV");
      DateTime bDate = DateTime(dateV[2]!, dateV[1]!, dateV[0]!);

      var l = jsonDecode(bDetails.bookingtime!);

      List sTimeList = List.generate(l.length, (index) => l[index]["time"]);
      for (var i in sTimeList) {
        var k = i.split(":");
        List<int?> dT = List.generate(
          k.length,
          (index) => int.tryParse(k[index]),
        );

        selectedTimeSlotList!
            .add(DateTime(bDate.year, bDate.month, bDate.day, dT[0]!, dT[1]!));
      }

      selectedBookingDate =
          BookingDates(bDate, bookingTimes: selectedTimeSlotList);
      timeSlots = buildBookingTimeList(selectedBookingDate!.date);
    } catch (e) {
      print("Error.....$e");
    }
  }

  Widget calendar() {
    return Container(
      child: Column(
        children: [
          CalendarCarousel<Event>(
            minSelectedDate: DateTime.now(),
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
                fontWeight: FontWeight.w500, fontSize: 32, color: Colors.white),
            leftButtonIcon: Center(
              child: Text(
                DateFormat('MMMM')
                    .format(DateTime(currentDate.year, currentDate.month - 1)),
                softWrap: false,
                // textDirection: TextDirection.RTL,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white),
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
                    color: Colors.white),
              ),
            ),
            onDayPressed: (DateTime date, List<Event> events) {
              this.setState(() {
                selectedBookingDate = BookingDates(date, bookingTimes: []);
                timeSlots = buildBookingTimeList(selectedBookingDate!.date);
              });
            },
            //selectedDateTime: currentDate,
            //targetDateTime: targetDate,
            weekendTextStyle: TextStyle(color: Colors.white),
            weekdayTextStyle: TextStyle(color: Colors.white),
            thisMonthDayBorderColor: Colors.transparent,
            customDayBuilder: (
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
            ) {
              if (selectedBookingDate!.date == day) {
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
              return Center(
                child: Text(
                  "${day.day}",
                  style: TextStyle(color: isSelectable ? white : bgGrey),
                ),
              );
            },
            weekFormat: false,
            height: 335.0,
            daysHaveCircularBorder: true,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // timeSlots = buildBookingTimeList(DateTime.now());
    // selectedBookingDate = BookingDates(currentDate, bookingTimes: []);
    initAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
          context: context,
          leftIcon: Icons.close,
          body: buildBody(context),
          title: "Edit Booking",
          color: deepBlue,
          textColor: white),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        calendar(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: <Widget>[
              buildDivider(),
              Row(
                children: [
                  mediumText(
                    "Select Time",
                    color: white,
                    size: 17,
                  ),
                  Spacer(),
                  Container(
                    height: 29,
                    child: mediumText(
                      "${selectedBookingDate == null ? "" : dateToString(selectedBookingDate!.date)}",
                      color: white,
                    ),
                  ),
                ],
              ),
              verticalSpace(),
              Wrap(
                children: List.generate(timeSlots.length, (index) {
                  DateTime time = timeSlots[index];
                  String timeRangeText = bookingTimeRange(time);
                  selectedTimeSlotList = selectedBookingDate!.bookingTimes;

                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: white)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedTimeSlotList!.contains(time)) {
                                selectedTimeSlotList!.remove(time);
                              } else {
                                selectedTimeSlotList!.add(time);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  timeRangeText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: white),
                                ),
                                Spacer(),
                                Container(
                                  height: 32,
                                  width: 32,
                                  child: Visibility(
                                      visible:
                                          selectedTimeSlotList!.contains(time),
                                      child: Icon(Icons.check, color: white)),
                                  decoration: selectedTimeSlotList!
                                          .contains(time)
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          color: Color.fromRGBO(25, 87, 234, 1),
                                          // border: Border.all(color: white),
                                        )
                                      : BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          border: Border.all(color: white),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpace()
                    ],
                  );
                }),
              ),
              buildDivider(),
              Row(
                children: <Widget>[
                  Text(
                    "Mode of Session",
                    style: TextStyle(
                        fontSize: 14,
                        color: white,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        "Virtual",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Transform.scale(
                        scale: .8,
                        child: CupertinoSwitch(
                          activeColor: blue,
                          value: isPhysical,
                          onChanged: (c) {
                            setState(() {
                              isPhysical = c;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Physical",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Visibility(
                visible: isPhysical,
                child: AnimatedOpacity(
                  opacity: isPhysical ? 1 : 0.0,
                  duration: Duration(seconds: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDivider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Choose location",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: white,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                var d = widget.userModel!.getUserDetails();
                                var c = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (con) => PickLoactionPage(
                                      currentLocation: LatLng(
                                          (d!.lat ?? 51.5074) / 1.0,
                                          (d.lon ?? 0.1278) / 1.0),
                                      isBlue: true,
                                    ),
                                  ),
                                );

                                if (c == null) {
                                  showSnack(context, "No Location was selected");
                                } else {
                                  var add = await convertCordinaeToAddress(c);
                                  setState(() {
                                    currentLocation = c;
                                    bookingAddress = add;
                                  });
                                }
                              },
                              child: currentLocation == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 4, 16, 4),
                                        child:
                                            lightText("Open Map", color: white),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        lightText("$bookingAddress",
                                            size: 12, color: Colors.white),
                                        horizontalSpace(width: 4),
                                        Image.asset(
                                          "assets/edit_red.png",
                                          height: 11,
                                        )
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              buildDivider(),
              Row(
                children: [
                  mediumText(
                    "Win Condition",
                    color: white,
                    size: 17,
                  ),
                  Spacer(),
                  CustomBioDropDown(
                    selectedItem: winCondition,
                    item: [
                      "Best Out of 10",
                      "Best Out of 5",
                      "Best Out of 3",
                    ],
                    bgColor2: deepBlue,
                    bgColor: Colors.transparent,
                    textColor: Colors.white,
                    onItemChanged: (c) {
                      setState(() {
                        winCondition = c;
                      });
                    },
                  ),
                ],
              ),
              verticalSpace(),
              Row(
                children: [
                  mediumText(
                    "Gameplay",
                    color: white,
                    size: 17,
                  ),
                  Spacer(),
                  CustomBioDropDown(
                    selectedItem: gamePlay,
                    item: [
                      "First to Score wins",
                      "Highest Score wins",
                    ],
                    bgColor2: deepBlue,
                    bgColor: Colors.transparent,
                    textColor: Colors.white,
                    onItemChanged: (c) {
                      setState(() {
                        gamePlay = c;
                      });
                    },
                  ),
                ],
              ),
              verticalSpace(height: 32),
              proceedButton(
                isLoading: isLoading,
                text: "Book Now",
                onPressed: () {
                  gotoNext(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool canProceed(BuildContext context) {
    if (selectedBookingDate == null) {
      showSnack(context, "No booking date(s) selected");
      return false;
    }

    if (selectedBookingDate!.bookingTimes!.isEmpty) {
      showSnack(context, "No sesson time set");
      return false;
    }

    if (isPhysical && currentLocation == null) {
      showSnack(context, "Please selece a location on map for booking.");
      return false;
    }

    return true;
  }

  Future gotoNext(BuildContext context) async {
    if (!canProceed(context)) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    List dates = [];
    var d = dateToString2(selectedBookingDate!.date);
    for (var i in selectedBookingDate!.bookingTimes!) {
      var ii = DateFormat.Hm().format(i);
      var m = {"dates": "$d", "time": "$ii"};
      dates.add(m);
    }

    // print("Sending buddy...");

    try {
      GeneralResponse b = await updateChallengeBookingDetails(
        widget.userModel!.getAuthToken(),
        bDetails.id,
        b: CreateChallengeBookingClass(
          bookingDates: dateToString2(selectedBookingDate!.date),
          sessionMode: isPhysical ? "0" : "1",
          latOfBooking: isPhysical ? "${currentLocation!.latitude}" : "0.0",
          longOfBoking: isPhysical ? "${currentLocation!.longitude}" : "0.0",
          locationOfBooking: "$bookingAddress",
          bookingtime: jsonEncode(dates),
          player2Id: null,
          startTime: "${selectedBookingDate!.date!.millisecond}",
          gamePlay: "$gamePlay",
          sport: null,
          tryOut: "${winCondition.split("of ").last.trim()}",
        ),
      );
      if (b.status!) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      } else {
        showSnack(context, b.message);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // print("$e");

      setState(() {
        isLoading = false;
      });
    }

    // print("Sending buddy...fininsh");
  }
}
