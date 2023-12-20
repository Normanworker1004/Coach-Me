import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/booking_date_class.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/player_pages/book_coach/booking_payment_method.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';

class BookCoachReviewTimePage extends StatefulWidget {
  final Userdetails coachDetails;
  final List<BookingDates> bookingDates;
  final bool isPhysical;
  final List<Userdetails> otherUsers;
  final UserModel? userModel;
  final locationdata;

  final BioSubDetail? currentDetails;

  const BookCoachReviewTimePage({
    Key? key,
    required this.bookingDates,
    required this.locationdata,
    required this.currentDetails,
    required this.isPhysical,
    required this.otherUsers,
    required this.coachDetails,
    required this.userModel,
  }) : super(key: key);
  @override
  _BookCoachReviewTimePageState createState() =>
      _BookCoachReviewTimePageState();
}

class _BookCoachReviewTimePageState extends State<BookCoachReviewTimePage> {
  late Userdetails coachDetails;
  late List<BookingDates> bookingDates;

  int totalSessions = 0;
  double? sessionPrice = 0;
  double totalPrice = 0;
  @override
  void initState() {
    super.initState();

    coachDetails = widget.coachDetails;
    bookingDates = widget.bookingDates;
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      context: context,
      body: buildBody(context),
      title: "Confirm session(s) you want to book",
      // title: "Review Time",
    );
  }

  Widget buildBody(BuildContext context) {
    totalSessions = 0;
    for (var item in bookingDates) {
      totalSessions += item.bookingTimes!.length;
    }
    // print("${coachDetails.profile.sessionPrice}");
    sessionPrice = widget.currentDetails!.bioPrice / 1.0;
    totalPrice = totalSessions * sessionPrice! / 1.0;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 138.0),
          child: ListView(
            children: <Widget>[
              dot(1),
              verticalSpace(height: 18),
              buildCard(Expanded(
                child: Row(
                  children: <Widget>[
                    CircularNetworkImage(
                      imageUrl: photoUrl + coachDetails.profilePic!,
                    ),
                    horizontalSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${coachDetails.name}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        verticalSpace(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Color.fromRGBO(182, 9, 27, 1),
                              size: 14,
                            ),
                            horizontalSpace(),
                            Text(
                              "${coachDetails.profile?.rating ?? 0}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Text(
                          "Range: ${calculateDistanceBtw(widget.userModel!.getUserDetails()!, coachDetails)}", //"Range: ${coachDetails.profile.radius}km", //107km",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(182, 9, 27, 1)),
                        ),
                      ],
                    )
                  ],
                ),
              )),
              verticalSpace(height: 16),
              buildCard(Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/calendar.png",
                      width: 15,
                      height: 15,
                    ),
                    horizontalSpace(),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Session Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            verticalSpace(),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  bookingDates.length,
                                  (index) {
                                    var date = bookingDates[index];
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          date.bookingTimes!.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${dateToString(date.date)} ",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          App.font_name2,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${bookingTimeRange(date.bookingTimes![index])}", //

                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          App.font_name2,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          182, 9, 27, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ))
                          ]),
                    )
                  ],
                ),
              )),
              verticalSpace(height: 16),
              buildCard(Expanded(
                child: Column(
                  children: <Widget>[
                    iconTextText("assets/price.png", "Session Price",
                        "£${sessionPrice!.toStringAsFixed(2)}"),
                    verticalSpace(height: 4),
                    Divider(
                      color: Colors.grey,
                    ),
                    verticalSpace(height: 4),
                    iconTextText(
                        "assets/voucher.png", "Session", "$totalSessions"),
                    verticalSpace(height: 4),
                    Divider(
                      color: Colors.grey,
                    ),
                    verticalSpace(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        horizontalSpace(),
                        Text(
                          "£${(totalPrice).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: App.font_name2,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(height: 4),
                  ],
                ),
              )),
              // verticalSpace(height: 100),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Edit Booking",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(182, 9, 27, 1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                verticalSpace(height: 16),
                proceedButton(
                  text: "Next",
                  onPressed: () {
                    pushRoute(
                        context,
                        BookingPaymentMethod(
                          locationdata: widget.locationdata,
                          totalAmount: totalPrice,
                          coachDetails: widget.coachDetails,
                          bookingDates: widget.bookingDates,
                          isPhysical: widget.isPhysical,
                          otherUsers: widget.otherUsers,
                          userModel: widget.userModel,
                          currentDetails: widget.currentDetails,
                        ));
                  },
                ),
              ],
            )),
      ],
    );
  }

  Widget buildCard(Widget body) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.2),
          blurRadius: 16,
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Card(
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                body,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget iconTextText(String icon, String text1, String text2,
    {var color = Colors.black}) {
  return Container(
    width: double.infinity,
    child: Row(
      children: <Widget>[
        Image.asset(
          icon,
          width: 15,
          height: 15,
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
          style: TextStyle(
            color: color,
            fontFamily: App.font_name2,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    ),
  );
}
