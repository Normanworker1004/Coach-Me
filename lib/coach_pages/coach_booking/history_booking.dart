import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

class CompletedBooking extends StatefulWidget {
  final UserModel? userModel;
  final scafKey;

  const CompletedBooking({
    Key? key,
    required this.userModel,
    required this.scafKey,
  }) : super(key: key);

  @override
  _CompletedBookingState createState() => _CompletedBookingState();
}

class _CompletedBookingState extends State<CompletedBooking> {
  UserModel? userModel;
  var _key;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    _key = widget.scafKey;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoachBookingResponse>(
        initialData: userModel!.getCoachBookings()[2],
        future: fetchBoking(userModel!.getAuthToken(), status: "completed"),
        builder: (context, snapshot) {
          if (snapshot == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var c = snapshot.data!;
              List<CoachBookingDetail>? details = [];

              if (c.status!) {
                details = c.details;
                userModel!.getCoachBookings()[2] = c;
              }

              if (details!.isEmpty) {
                return Center(
                  child: boldText(
                    "You do not have any completed booking",
                    textAlign: TextAlign.center,
                    color: white,
                  ),
                );
              } else {
                return ListView(
                  children: [
                    verticalSpace(height: 16),
                    Wrap(
                      children: List.generate(
                        details.length,
                        (index) {
                          CoachBookingDetail d = details![index];
                          return Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                child: Card(
                                    // elevation: 16,
                                    margin: EdgeInsets.all(0),
                                    shadowColor: Colors.black.withOpacity(.5),
                                    child: History(
                                      bookingDetails: d,
                                      playerDetails: d.user,
                                    )),
                              ),
                              verticalSpace()
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
          }
        });
  }
}

class History extends StatelessWidget {
  final Userdetails? playerDetails;
  final CoachBookingDetail bookingDetails;

  const History({
    Key? key,
    required this.playerDetails,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircularNetworkImage(
            imageUrl: "${photoUrl + playerDetails!.profilePic!}",
            size: 45,
          ),
          horizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${playerDetails!.name}",
                  style: Style.titleTitleTextStyle,
                ),
                // verticalSpace(height: 4),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: <Widget>[
                    Text("${getSportLevel(playerDetails!)}",
                        style: Style.tilte2TitleTextStyle),
                    horizontalSpace(),
                  ],
                ),
                verticalSpace(height: 4),
                Row(
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    iconTitle("assets/booking_clock.png",
                        "${toDate(bookingDetails.bookingDates)}", Colors.red),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: iconTitle("assets/map_pin.png",
                          "${bookingDetails.location}", mapPinBlue),
                    ),
                  ],
                ),
                verticalSpace(height: 8),
                Row(
                  children: [
                    Expanded(child: rating(5, "You Recieved")),
                    horizontalSpace(),
                    Expanded(child: rating(5, "You Gave")),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rating(double rating, text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmoothStarRating(
          starCount: 5,
          size: 20,
          //isReadOnly: true,
          rating: rating ,
          borderColor: Color.fromRGBO(255, 193, 7, 1),
          color: Color.fromRGBO(255, 193, 7, 1), //rgba(255, 193, 7, 1)
        ),
        lightText(text, color: Colors.grey)
      ],
    );
  }
}
