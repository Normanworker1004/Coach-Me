import 'dart:convert';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/map/pick_location.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dropdowns/border_dropdown.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/utils/address_function.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateBootCampPage extends StatefulWidget {
  @override
  _CreateBootCampPageState createState() => _CreateBootCampPageState();
}

class _CreateBootCampPageState extends State<CreateBootCampPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<DateTime> timeSlots = [];
  List<DateTime>? selectedTimeSlotList = [];

  String selectedPlayerCapacity = "10";

  late UserModel userModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool isLoading = false;
  BookingDates? selectedBookingDate;
  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();

  LatLng? currentLocation;
  String? bookingAddress = "Virtual";

  Future<void> handleMapPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
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
              this.setState(() {
                selectedBookingDate = BookingDates(date, bookingTimes: []);
                timeSlots = buildBookingTimeList(selectedBookingDate!.date);
              });
            },
            //selectedDateTime: currentDate,
            //targetDateTime: targetDate,
            weekendTextStyle: TextStyle(color: Colors.black),
            weekdayTextStyle: TextStyle(color: Colors.black),
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

  @override
  void initState() {
    super.initState();

    timeSlots = buildBookingTimeList(DateTime.now());
    selectedBookingDate = BookingDates(currentDate, bookingTimes: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: ScopedModelDescendant<UserModel>(
        builder: (c, widget, model) {
          userModel = model;
          return buildBaseScaffold(
            context: context,
            body: buildBody(context),
            title: "Setup Boot camp",
            leftIcon: Icons.close,
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        calendar(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildDivider(),
              mediumText("Name of Boot Camp", size: 14),
              verticalSpace(height: 4),
              buildCard(
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: App.font_name2,
                    ),
                  ),
                ),
                innerPadding: 2,
              ),
              verticalSpace(),
              mediumText("Description", size: 14),
              verticalSpace(height: 4),
              buildCard(
                Expanded(
                  child: TextField(
                    controller: desController,
                    minLines: 4,
                    maxLines: 10,
                    style: TextStyle(
                      fontFamily: App.font_name2,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                innerPadding: 2,
              ),
              verticalSpace(),
              mediumText("Price", size: 14),
              verticalSpace(height: 4),
              buildCard(
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontFamily: App.font_name2,
                    ),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: InputDecoration(
                      prefix: mediumText("£ "),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                innerPadding: 2,
              ),
              verticalSpace(),
              buildDivider(),
              verticalSpace(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Choose location",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    // Spacer(),
                    horizontalSpace(),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          handleMapPermissions();

                          var d = userModel.getUserDetails()!;
                          var cc = LatLng((int.tryParse(d.lat) ?? 51.5074) / 1.0,
                              (int.tryParse(d.lon) ?? 0.1278) / 1.0);
                          var c = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (con) => PickLoactionPage(
                                currentLocation: cc,
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
                            // print(
                            //     "$bookingAddress....new location=>>>>>> lat: ${currentLocation.latitude}  lon: ${currentLocation.longitude}");
                          }
                        },
                        child: currentLocation == null
                            ? Row(
                                children: [
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 16, 4),
                                      child: lightText("Open Map"),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: rLightText("$bookingAddress",
                                        size: 12, color: Colors.black),
                                  ),
                                  horizontalSpace(width: 4),
                                  Image.asset(
                                    "assets/edit_red.png",
                                    height: 11,
                                  )
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              ),
              verticalSpace(),
              buildDivider(),
              verticalSpace(),
              Row(
                children: <Widget>[
                  Text(
                    "Player Capacity",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  CustomDropDown(
                    onItemChanged: (c) {
                      setState(() {
                        selectedPlayerCapacity = c;
                      });
                    },
                    textColor: Colors.black,
                    // bgColor2: Colors.black,
                    selectedItem: selectedPlayerCapacity,
                    item: ["10", "20", "30"],
                  )
                ],
              ),
              verticalSpace(),
              buildDivider(),
              verticalSpace(height: 16),
              Row(
                children: <Widget>[
                  Text(
                    "Select Time",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
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
                      buildCard(
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: white)),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedTimeSlotList!.contains(time)) {
                                    selectedTimeSlotList!.remove(time);
                                  } else {
                                    selectedTimeSlotList!.add(time);
                                  }
                                  // selectedTimeSlot = t;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      timeRangeText,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 32,
                                      width: 32,
                                      child: Visibility(
                                          visible: selectedTimeSlotList!
                                              .contains(time),
                                          child:
                                              Icon(Icons.check, color: white)),
                                      decoration: selectedTimeSlotList!
                                              .contains(time)
                                          ? BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              color: blue,
                                              // border: Border.all(color: white),
                                            )
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        innerPadding: 0,
                      ),
                      verticalSpace()
                    ],
                  );
                }),
              ),
              verticalSpace(height: 32),
              proceedButton(
                  isLoading: isLoading,
                  text: "Setup Boot Camp",
                  onPressed: () => createNewBootCamp(context)),
            ],
          ),
        ),
      ],
    );
  }

  bool canProceed(BuildContext context) {
    if (nameController.text.isEmpty) {
      showSnack(context, "Enter Boot Camp Name");
      return false;
    }
    if (desController.text.isEmpty) {
      showSnack(context, "Enter Boot Camp Description");
      return false;
    }
    var p = double.tryParse(priceController.text);
    if (priceController.text.isEmpty) {
      showSnack(context, "Enter Boot Camp Price");
      return false;
    } else if (p == null) {
      showSnack(context, "Enter a valid Boot Camp Price");
      return false;
    }
    if (selectedBookingDate == null) {
      showSnack(context, "No booking date(s) selected");
      return false;
    }

    if (selectedBookingDate!.bookingTimes!.isEmpty) {
      showSnack(context, "No sesson time set");
      return false;
    }

    if (currentLocation == null) {
      showSnack(context, "Please selece a location on map for booking.");
      return false;
    }

    return true;
  }

  createNewBootCamp(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!canProceed(context)) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    List time = [];
    for (var i in selectedBookingDate!.bookingTimes!) {
      var ii = DateFormat.Hm().format(i);
      var m = {"time": "$ii"};
      time.add(m);
    }

    try {
      GeneralResponse2 b = await createBootCamp(
        token: userModel.getAuthToken(),
        bootCampDate: dateToString2(selectedBookingDate!.date),
        name: nameController.text.trim(), //,
        price: priceController.text,
        description: desController.text.trim(),
        capacity: selectedPlayerCapacity,

        bootcamptime: jsonEncode(time), lat: currentLocation!.latitude ,
        location: bookingAddress,
        lon: currentLocation!.longitude ,
      );
      setState(() {
        isLoading = false;
      });

      if (b.status!) {
        Navigator.pop(context);
      }
      // print("crateing .... done");
      showSnack(context, b.message);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print("error .... $e");
      showSnack(context, "Error occured");
    }
  }
}
