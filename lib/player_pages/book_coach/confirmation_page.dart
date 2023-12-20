import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/create_booking_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
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

class BookingConfirmationPage extends StatefulWidget {
  final CreateBookingResponse booking;
  final Userdetails coachDetails;
  final UserModel? userModel;
  final List<BookingDates>? bookingDates;
  final locationdata;

  const BookingConfirmationPage({
    Key? key,
    required this.booking,
    required this.coachDetails,
    required this.userModel,
    required this.bookingDates,
    required this.locationdata,
  }) : super(key: key);
  @override
  _BookingConfirmationPageState createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late Userdetails coachDetails;
  CreateBookingResponse? booking;

  TextEditingController nameController = TextEditingController();
  TextEditingController reletionshipController = TextEditingController();
  TextEditingController heathStatusController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    coachDetails = widget.coachDetails;
    booking = widget.booking;
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
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CircularNetworkImage(
                              imageUrl: "${photoUrl + coachDetails.profilePic!}",
                            ),
                            horizontalSpace(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${coachDetails.name}",
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
                                      rMediumText(
                                          "${(coachDetails.profile!.rating).toStringAsFixed(2)}",
                                          size: 10)
                                    ],
                                  ),
                                  Text(
                                    "${getCoachSportLevel(coachDetails)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(182, 9, 27, 1),
                                    ),
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
                              buildBookingDateRange(widget.bookingDates!),
                              // "${booking.details.map((e) => e.bookingDates.split("T").first).toList()}",
                              size: 13,
                            ),
                            rMediumText(
                                bookingTimeRange(widget
                                    .bookingDates!.first.bookingTimes!.first),
                                // "04:15 PM - 05:00pm",
                                size: 13,
                                color: red),
                            iconTitleExpanded("assets/map_pin.png",
                                "${widget.locationdata[0]}", blue)
                          ],
                        ),
                      )
                    ],
                  ),
                  verticalSpace(height: 16),
                  proceedButton(
                      text: "Add to Calendar",
                      onPressed: () => addToCalendar(context)),
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
        Text(
          (userModel!.getUserProfileDetails()!.bookingPt ?? 0) < 1
              ? "Congratulations on your first booking. You are on your way!"
                  "\nYour health and safety is extremely important to your coach and us, "
                 " Please complete the details below to your coach in advance of your booking."
               " Contact info required. Who should be contacted in the event of an accident?"

              : "\nYour health and safety is extremely important ot your coach and us,"
               " Contact info required. Who should be contacted in the event of an accident? "
                    " Please complete the details below to your coach in advance of your booking.",
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
              buildInputWidget("Phone Number", phoneController, (c) {
                setState(() {});
              }, keyboardType: TextInputType.phone),
              verticalSpace(),
            ],
          ),
        ),
        verticalSpace(height: 16),
        proceedButton(
          text: "Continue",
          isLoading: isLoading,
          onPressed: nameController.text.isEmpty
              ? null
              : () {
                  updateBooking();
                },
        ),
      ],
    );
  }

  addToCalendar(BuildContext context) async {
    var calendars = await retrieveCalendars();

    for (var b in widget.bookingDates!) {
      for (var i in b.bookingTimes!) {
        for (var cal in calendars!) {
          var v = await addEventsToCalendar(
            calendar: cal,
            eventId: "booking_${UniqueKey()} ",
            eventTitle: "Booking with ${widget.coachDetails.name}",
            eventStartTime: i,
            eventDescription:
                "Booking With Coach ${widget.coachDetails.name} on Coach & Me App",
          );

          print("${v ? "succes" : "failed"}");
        }
      }
    }

    showSnack(context, "Booking Added To Calendar");
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
    try {
      var booking = widget.booking.details!;
      // print(booking);
      var health = heathStatusController.text;
      updateBookingPlayer(
        widget.userModel!.getAuthToken(),
        nok: "${nameController.text}",
        nokRelationship: "${reletionshipController.text}",
        nokPhone: "${phoneController.text}",
        healthstatus: health.split("\n"),
        bookingid: List.generate(
          booking.length,
          (index) => booking[index].id,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      // print("eror....$e");
    }
  }
}
