import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/create_buddy_up_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/buddy_up.dart';
import 'package:cme/player_pages/book_coach/booking_payment_add_card_page.dart';
import 'package:cme/player_pages/buddy_up/buddy_bookings_record.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/calendar_functions.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';

class BuddyUpConfirmBookingPage extends StatefulWidget {
  final Userdetails playerDetails;
  final BookingDates? bookingDates;
  final bool isPhysical;
  final UserModel? userModel;
  final locationdata;
  final CreateBuddyBookingResponse bookingResponse;

  const BuddyUpConfirmBookingPage({
    Key? key,
    required this.bookingResponse,
    required this.bookingDates,
    required this.locationdata,
    required this.isPhysical,
    required this.playerDetails,
    required this.userModel,
  }) : super(key: key);
  @override
  _BuddyUpConfirmBookingPageState createState() =>
      _BuddyUpConfirmBookingPageState();
}

class _BuddyUpConfirmBookingPageState extends State<BuddyUpConfirmBookingPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController reletionshipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late Userdetails playerDetails;
  late CreateBuddyBookingResponse booking;
  BookingDates? bookingDates;
  TextEditingController heathStatusController = TextEditingController();

  bool isLoading = false;

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    bookingDates = widget.bookingDates;
    playerDetails = widget.playerDetails;
    booking = widget.bookingResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        context: context,
        leftIcon: Icons.close,
        body: buildBody(context),
        title: "Booking Confirmed",
        color: white,
        textColor: Colors.black,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/confirm_note.png",
            height: 79,
            width: 66,
          ),
        ),
        verticalSpace(),
        Center(
          child: mediumText(
            "Booking is Confirmed!",
            size: 24,
          ),
        ),
        verticalSpace(),
        buildCard(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    // direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CircularNetworkImage(
                              imageUrl:
                                  "${photoUrl + playerDetails.profilePic!}",
                            ),
                            horizontalSpace(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${playerDetails.name}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/bar_chart.png",
                                        height: 14,
                                      ),
                                      horizontalSpace(width: 4),
                                      boldText(
                                        "${calculatePlayerPoints(playerDetails)}",
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${getSportLevel(playerDetails)}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(182, 9, 27, 1)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      horizontalSpace(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            mediumText(
                              "Session Details",
                              size: 15,
                            ),
                            rMediumText(
                              "${dateToString(bookingDates!.date)}",
                              size: 13,
                            ),
                            rMediumText(
                              bookingTimeRange(
                                  widget.bookingDates!.bookingTimes!.first),
                              size: 13,
                              color: red,
                            ),
                            iconTitleExpanded(
                              "assets/map_pin.png",
                              "${widget.locationdata[0]}",
                              blue,
                              fontName: App.font_name2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  verticalSpace(height: 16),
                  proceedButton(
                      text: "Add to Calendar",
                      onPressed: () => addToCalendar()),
                  verticalSpace(),
                ],
              ),
            ),
          ),
          innerPadding: 0,
        ),
        verticalSpace(height: 16),
        lightText(
          (userModel!.getUserProfileDetails()?.bookingPt ?? 0) < 1
              ? "Congratulations on your first booking you are on your way!"
                  // "\nYour health and safety is extremely important to us, Please provide the details below."
                  "Contact info required. Who should be contacted in the event of an accident?"
              : "Contact info required. Who should be contacted in the event of an accident?",
          // "\nYour health and safety is extremely important to us, Please provide the details below.",
          color: Colors.black,
          size: 14,
          maxLines: 10,
        ),
        verticalSpace(),
        buildCard(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: heathStatusController,
                  maxLines: 3,
                  minLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(195, 195, 195, 1)),
                    hintText: "Asthma\nHypertension\nArthritis",
                  ),
                ),
              ),
            ),
            innerPadding: 0),
        verticalSpace(height: 16),
        boldText("Next of Kin Information", color: Colors.black),
        lightText("Contact Info required in event of accident."),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              buildInputWidget("Full name", nameController, (c) {
                setState(() {});
              }),
              verticalSpace(),
              buildInputWidget("Relationship", reletionshipController, (c) {
                setState(() {});
              }),
              verticalSpace(),
              buildInputWidget(
                "Phone Number",
                phoneController,
                (c) {
                  setState(() {});
                },
                keyboardType: TextInputType.phone,
              ),
              verticalSpace(),
            ],
          ),
        ),
        verticalSpace(height: 16),
        proceedButton(
          isLoading: isLoading,
          text: "Continue",
          onPressed: () {
            updateBooking();
          },
        ),
      ],
    );
  }

  Widget iconTextText(IconData icon, String text1, String text2,
      {var color = Colors.black}) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 22,
            color: Colors.blue,
          ),
          horizontalSpace(),
          Text(
            text1,
            style: TextStyle(
              fontWeight: FontWeight.w100,
            ),
          ),
          Spacer(),
          horizontalSpace(),
          Text(
            text2,
            style: TextStyle(fontWeight: FontWeight.w100, color: color),
          ),
        ],
      ),
    );
  }

  addToCalendar() async {
    var calendars = await retrieveCalendars();

    for (var i in widget.bookingDates!.bookingTimes!) {
      for (var cal in calendars!) {
        var v = await addEventsToCalendar(
          calendar: cal,
          eventId: "buddy_up_${UniqueKey()} ",
          eventTitle: "Buddy Up Booking with ${widget.playerDetails.name}",
          eventStartTime: i,
          eventDescription:
              "Buddy Up Booking with ${widget.playerDetails.name} on Coach & Me App",
        );

        print("${v ? "succes" : "failed"}");
      }
    }

    showSnack(context, "Booking Added To Calendar");
  }

  void updateBooking() async {
    setState(() {
      isLoading = true;
    });
    var health = heathStatusController.text;

    try {
      // print("update.....");
      GeneralResponse res = await updateBuddyUpBooking(
        widget.userModel!.getAuthToken(),
        nok: "${nameController.text}",
        nokRelationship: "${reletionshipController.text}",
        nokPhone: "${phoneController.text}",
        healthstatus: health.split("\\n"),
        bookingid: booking.details!.id,
      );
      // print("update.....finnsh");

      if (res.status!) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        pushRoute(
          context,
          BuddyBookingRecordPage(userModel: widget.userModel, shouldStartWithInvited: true),
        );
      } else {
        showSnack(context, res.message);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print("Error....$e");
    }
  }
}
