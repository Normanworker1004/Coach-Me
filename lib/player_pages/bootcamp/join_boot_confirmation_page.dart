import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/player/booking.dart';
import 'package:cme/player_pages/book_coach/booking_payment_add_card_page.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/calendar_functions.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';

class JoinBootCampConfirmationPage extends StatefulWidget {
  final BootCampDetails bootCampDetails;
  final UserModel userModel;

  const JoinBootCampConfirmationPage({
    Key? key,
    required this.bootCampDetails,
    required this.userModel,
  }) : super(key: key);
  @override
  _JoinBootCampConfirmationPageState createState() =>
      _JoinBootCampConfirmationPageState();
}

class _JoinBootCampConfirmationPageState
    extends State<JoinBootCampConfirmationPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  Userdetails? coachDetails;
  Profiledetails? coachProfile;
  late BootCampDetails bootCampDetails;

  TextEditingController nameController = TextEditingController();
  TextEditingController reletionshipController = TextEditingController();
  TextEditingController heathStatusController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    bootCampDetails = widget.bootCampDetails;

    coachDetails = bootCampDetails.coachDetails;
    coachProfile = bootCampDetails.coachProfile;
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
      ),
    );
  }

  addToCalendar(BuildContext context) async {
    BookingDates bc = toBootCampBookingDates(bootCampDetails);
    var coachName = bootCampDetails.coachDetails!.name;
    var calendars = await retrieveCalendars();

    for (var i in bc.bookingTimes!) {
      for (var cal in calendars!) {
        var v = await addEventsToCalendar(
          calendar: cal,
          eventId: "bootcamp_${UniqueKey()} ",
          eventTitle: "Boot Camp Booking with $coachName",
          eventStartTime: i,
          eventDescription:
              "Boot Camp Booking Session with $coachName on Coach & Me App",
        );

        print("${v ? "succes" : "failed"}");
      }
    }

    showSnack(context, "Booking Added To Calendar");
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
            child: Image.asset(
          "assets/confirm_note.png",
          height: 72,
        )),
        verticalSpace(),
        Center(
          child: Text(
            "Booking is Confirmed!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
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
                            CircularImage(),
                            horizontalSpace(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${coachDetails!.name}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // verticalSpace(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: red,
                                      ),
                                      horizontalSpace(),
                                      rMediumText("${coachProfile?.rating ?? 0}",
                                          size: 10)
                                    ],
                                  ),
                                  Text(
                                    "${getCoachSportLevel(coachDetails!)}",
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
                            // verticalSpace(),
                            rMediumText(
                              "${toDate(bootCampDetails.bootCampDate)}",
                              size: 13,
                            ),
                            rMediumText(
                                "${bootCampDetails.bootcamptime![0].time}"
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                                size: 13,
                                color: red),
                            iconTitleExpanded("assets/map_pin.png",
                                "${bootCampDetails.location}", blue)
                          ],
                        ),
                      )
                    ],
                  ),
                  verticalSpace(height: 16),
                  proceedButton(
                    text: "Add to Calendar",
                    onPressed: () => addToCalendar(context),
                  ),
                  verticalSpace(),
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText("Notes from Coach"),
                              Text(
                                "Bring water, moulded boots only. 2nd line of notes goes here",
                                style: TextStyle(
                                  fontFamily: App.font_name,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(),
                ],
              ),
            ),
          ),
          innerPadding: 0,
        ),
        verticalSpace(height: 16),
        Text((userModel.getUserProfileDetails()!.bookingPt ?? 0) < 1
                ? "Congratulations on your first booking you are on your way!"
                    "\nYour health and safety is extremely important ot your coach and us,"
                    // " please provide the details below to your coach in advance of your booking."
                    "Contact info required. Who should be contacted in the event of an accident?"
                : "\nYour health and safety is extremely important ot your coach and us,"
                    "Contact info required. Who should be contacted in the event of an accident?"

            // "Please provide the details below to your coach in advance of your booking.",
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
                  style: TextStyle(fontFamily: App.font_name2),
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
          text: "Continue",
          onPressed: nameController.text.isEmpty
              ? null
              : () {
                  updateBooking();
                  // Final.setId(0);
                  // pushRoute(context, VideoSessionPage1());
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
            color: Color.fromRGBO(182, 9, 27, 1),
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

  void updateBooking() async {
    var health = heathStatusController.text;
    updateBookingPlayer(
      widget.userModel.getAuthToken(),
      nok: "${nameController.text}",
      nokRelationship: "${reletionshipController.text}",
      nokPhone: "${phoneController.text}",
      healthstatus: health.split("\n"),
      bookingid: widget.bootCampDetails.id,
    );

    Navigator.pop(context);
  }
}
