import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/map/pick_location.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/contact_filter_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/dairy/dairy_function.dart';
import 'package:cme/network/coach/dairy/diary_request.dart';
import 'package:cme/network/contact_filter.dart';
import 'package:cme/player_pages/book_coach/find_coach_page.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dropdowns/custom_time_drodown.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/address_function.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'review_booking_time.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';

class BookCoachChooseTimePage extends StatefulWidget {
  final Userdetails currentCoach;
  final UserModel? userModel;
  final BioSubDetail? currentDetails;

  const BookCoachChooseTimePage(
      {Key? key,
      required this.currentCoach,
      required this.userModel,
      required this.currentDetails})
      : super(key: key);
  @override
  _BookCoachChooseTimePageState createState() =>
      _BookCoachChooseTimePageState();
}

class _BookCoachChooseTimePageState extends State<BookCoachChooseTimePage> {
  bool canCheckContact = false;

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  bool isPhysical = false;

  List<DateTime>? timeSlots = [];
  String selectedDropDownDate = "";
  String? itemSelected  ;
  List<DateTime>? selectedTimeSlotList = [];
  int selectedBookingIndex = 0;
  List<BookingDates> bookingDates = [];
  List<DateTime> selectedList = [];
  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();

  List<Userdetails> contactsAdded = [];
  List<Userdetails>? registeredContact = [];
  LatLng? currentLocation;

  String? bookingAddress = "";

//Coach dairy sync
  var dairyJsonResopnse;
  List<DateTime>? selectedDatesList = [];
  DayReport? displayDateReport;

  UserModel? userModel;

  Widget calendar() {
    return Container(
      child: Column(
        children: [
          CalendarCarousel<Event>(
            minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
            pageSnapping: false,
            todayBorderColor:Colors.transparent,
            todayButtonColor:Colors.transparent,
            todayTextStyle: TextStyle(color: Colors.black),
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
              var detailDaySelected = filterDairyForDay(  dairyJsonResopnse, date: dateToString3(date));
               print(" detailDaySelected ${detailDaySelected?.unAvailableAllDay }");

              if(detailDaySelected?.unAvailableAllDay == true ) return false;
              this.setState(() {
                if (selectedList.contains(date)) {
                  selectedList.remove(date);
                } else {
                  selectedList.add(date);
                }

                bool isFound = false;
                for (int i = 0; i < bookingDates.length; i++) {
                  if (bookingDates[i].date == date) {
                    bookingDates.removeAt(i);
                    isFound = true;
                    break;
                  }
                }


                if (!isFound) {
                  bookingDates.add(BookingDates(date, bookingTimes: []));
                  setState(() {});
                }
              });
            },
            // selectedDateTime: currentDate,

            // //targetDateTime: targetDate,
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
              // if(!isThisMonthDay) isSelectable = false;
              // if(!isThisMonthDay) return Container();

              if (selectedList.contains(day)) {
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
              var detailDaySelected = filterDairyForDay(  dairyJsonResopnse, date: dateToString3(day));
              if (!isSelectable || selectedDatesList!.contains(day) && detailDaySelected?.unAvailableAllDay == true ) {
                return Container(
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: Colors.grey,
                  // ),
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle(color: Color.fromRGBO(217, 217, 217, 1.0),),
                    ),
                  ),
                );
              }

              if (isSelectable  ) { //&& selectedDatesList!.contains(day) && detailDaySelected?.unAvailableAllDay != true
                return Container(
                  decoration:

                  BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(25, 87, 234, 1),
                        width: 1.0,
                        style: BorderStyle.solid
                    ),
                     borderRadius: BorderRadius.circular(40),
                    // color: Color.fromRGBO(25, 87, 234, 1),
                  ),
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: TextStyle(color: Colors.black,),
                    ),
                  ),
                );
              }

              return null;
            },
            weekFormat: false,
            height: 360.0,
            daysHaveCircularBorder: true,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    checkContactPermission();

    timeSlots = buildBookingTimeList(DateTime.now());

    var d = DateTime.now();
    DateTime displayDate = DateTime(d.year, d.month, d.month);
    displayDateReport = DayReport(date: displayDate);
    displayDateReport!.data = <DairyData?>[];
  }

  loadRegisteredOnContactList() async {
    FilterContactResponse c = await filterUserContact(
      token: widget.userModel!.getAuthToken()!,
      countryCode: widget.userModel!.getUserDetails()!.countryId,
    );
    if (c.status!) {
      setState(() {
        registeredContact = c.details;
      });
    }
  }

  checkContactPermission() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      var c = await Permission.contacts.request();
      if (c == PermissionStatus.granted) {
        isGranted = true;
      }
    }

    if (isGranted) {
      loadRegisteredOnContactList();
    }

    setState(() {
      canCheckContact = isGranted;
    });
  }

  buildBody(BuildContext context) {
    return ListView(
      children: [
        dot(0),
        Column(
          children: <Widget>[
            FutureBuilder(
                future: fetchMothCoachDairyUnavailabilityById(
                  userModel!.getAuthToken()!,
                  coachId: widget.currentCoach.id,
                  date: dateToString2(currentDate),
                ),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    print("data...loaded ${snapshot.data}");
                    dairyJsonResopnse = snapshot.data;

                    selectedDatesList =
                        filterDairyBookingDates(dairyJsonResopnse);
                    displayDateReport = filterDairyForDay(
                      dairyJsonResopnse,
                      date: dateToString3(displayDateReport!.date),
                    );
                  }
                  return dairyJsonResopnse == null
                      ? Container(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoActivityIndicator(),
                                verticalSpace(),
                                boldText("Fetching coach schedule..")
                              ],
                            ),
                          ),
                        )
                      : calendar();
                }),
            Visibility(
              visible: selectedList.length > 0 ,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(
                  children: <Widget>[
                    buildDivider(),
                    Row(
                      children: <Widget>[
                        Text(
                          "Select Time",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Container(
                          height: 29,
                          child: CustomBioDropDown(
                            selectedItem: selectedDropDownDate,
                            onItemChanged: (c) {

                              for (var i = 0; i < bookingDates.length; i++) {
                                var item = bookingDates[i];
                                if (c == dateToString(item.date)) {
                                  //Update day report
                                  displayDateReport = filterDairyForDay(
                                    dairyJsonResopnse,
                                    date: dateToString3(item.date),
                                  );

                                  timeSlots = filterCoachAvailableTimeInDay(
                                    dairyJsonResopnse,
                                    date: dateToString3(item.date),
                                  ); //buildBookingTimeList(item.date);
                                  selectedTimeSlotList = item.bookingTimes;
                                  setState(() {
                                    itemSelected = dateToString3(item.date);
                                     selectedBookingIndex = i;
                                  });
                                }
                              }
                            },
                            item: List.generate(
                              selectedList.length,
                              (index) {
                                return dateToString(selectedList[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(),
                    Visibility(
                      visible: itemSelected != null,
                      child: Wrap(
                        children: List.generate(
                          timeSlots!.length,
                          (index) {
                            DateTime time = timeSlots![index];
                            String timeRangeText = bookingTimeRange(time);

                            if (bookingDates.isEmpty) {
                              selectedTimeSlotList = [];
                            } else {
                              if (selectedBookingIndex >= bookingDates.length) {
                                selectedTimeSlotList = [];
                              } else {
                                selectedTimeSlotList =
                                    bookingDates[selectedBookingIndex].bookingTimes;
                              }
                            }
                            return Column(
                              children: <Widget>[
                                buildCard(
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        border: Border.all(color: white),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (selectedTimeSlotList!
                                                .contains(time)) {
                                              selectedTimeSlotList!.remove(time);
                                            } else {
                                              selectedTimeSlotList!.add(time);
                                            }
                                            // selectedDropDownDate= t;
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
                                                    child: Icon(Icons.check,
                                                        color: white)),
                                                decoration: selectedTimeSlotList!
                                                        .contains(time)
                                                    ? BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                        color: Color.fromRGBO(
                                                            25, 87, 234, 1),
                                                      )
                                                    : BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
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
                          },
                        ),
                      ),
                    ),
                    buildDivider(),
                    Row(
                      children: <Widget>[
                        Text(
                          "Mode of Session",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              "Virtual",
                              style: TextStyle(
                                color: isPhysical ? Colors.grey : Color.fromRGBO(    25, 87, 234, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Transform.scale(
                              scale: .8,
                              child: CupertinoSwitch(
                                  activeColor: Color.fromRGBO(
                                      25, 87, 234, 1), //rgba(25, 87, 234, 1)
                                  value: isPhysical,
                                  onChanged: (c) {
                                    setState(() {
                                      isPhysical = c;
                                    });
                                  }),
                            ),
                            Text(
                              "Physical",
                              style: TextStyle(
                                color: !isPhysical ? Colors.grey : Color.fromRGBO(    25, 87, 234, 1),
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
                        child: Row(
                          children: [
                            mediumText("Choose Location", size: 14),
                            horizontalSpace(),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  var d = widget.userModel!.getUserDetails();
                                  var c = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (con) => PickLoactionPage(
                                        currentLocation: LatLng(
                                            (d!.lat ?? 51.5074) / 1.0,
                                            (d.lon ?? 0.1278) / 1.0),
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
                                  child: currentLocation == null
                                      ? Row(
                                          children: [
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)),
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 4, 16, 4),
                                                child: lightText("Open Map"),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: lightText(
                                                "$bookingAddress",
                                                size: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            horizontalSpace(width: 4),
                                            Image.asset(
                                              "assets/edit_red.png",
                                              height: 11,
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    buildDivider(),
                    Consumer<UIProvider>(
                      builder: (c, provider, widget) => Visibility(
                          visible: provider.isSubScribed(),
                          child: buildGroupBooking()),
                    ),
                    verticalSpace(),
                    proceedButton(
                      text: "Next",
                      onPressed: () => gotoNext(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        pushRoute(
          context,
          FindCoachPage(
            userModel: userModel,
          ),
        );
        return false;
      },
      child: Scaffold(
        key: _key,
        body: buildBaseScaffold(
            onBackPressed: () async {
              Navigator.pop(context);
              pushRoute(
                context,
                FindCoachPage(
                  userModel: userModel,
                ),
              );
            },
            leftIcon: Icons.close,
            context: context,
            body: buildBody(context),
            title: "Choose Time"),
      ),
    );
  }

  Widget buildGroupBooking() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Group Booking",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          verticalSpace(),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(.3), blurRadius: 16),
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Card(
                margin: EdgeInsets.all(0),
                // shape: StadiumBorder(),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    // alignLabelWithHint: true,
                    hintText: "Search your friend",
                    hintStyle: Style.hintTextStyle,
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(height: 30),
          canCheckContact
              ? Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: ListView(
                    children: List.generate(registeredContact!.length, (index) {
                      var i = registeredContact![index];
                      return buildContactTile(i,
                          isSelected: contactsAdded.contains(i), onPressed: () {
                        setState(() {
                          if (contactsAdded.contains(i)) {
                            contactsAdded.remove(i);
                          } else {
                            contactsAdded.add(i);
                          }
                        });
                      });
                    }),
                  ),
                )
              : InkWell(
                  onTap: () {
                    checkContactPermission();
                  },
                  child: mediumText("Allow Permission to Read Contacts"),
                ),
        ],
      ),
    );
  }

  bool canProceed(BuildContext context) {
    if (bookingDates.isEmpty) {
      showSnack(context, "No booking date(s) selected");
      return false;
    }
    for (var item in bookingDates) {
      if (item.bookingTimes!.isEmpty) {
        showSnack(context, "No sesson time set for ${dateToString(item.date)}");
        return false;
      }
    }

    if (isPhysical && currentLocation == null) {
      showSnack(context, "Please selece a location on map for booking.");
      return false;
    }

    return true;
  }

  gotoNext(BuildContext context) {
    if (!canProceed(context)) {
      return;
    }

    pushRoute(
      context,
      BookCoachReviewTimePage(
        locationdata: isPhysical
            ? [
                "$bookingAddress",
                "${currentLocation!.longitude}",
                "${currentLocation!.latitude}"
              ]
            : ["Virtual", "0.0", "0.0"],
        userModel: widget.userModel,
        coachDetails: widget.currentCoach,
        bookingDates: bookingDates,
        isPhysical: isPhysical,
        otherUsers: contactsAdded,
        currentDetails: widget.currentDetails,
      ),
    );
  }
}

Widget buildContactTile(
  Userdetails d, {
  bool isSelected: false,
  onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: GestureDetector(
      onTap: onPressed,
      child: buildCard(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "${d.name}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${d.phone}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                height: 32,
                width: 32,
                child: Visibility(
                    visible: isSelected, child: Icon(Icons.check, color: blue)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  // color: blue,
                  border: Border.all(color: blue),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
