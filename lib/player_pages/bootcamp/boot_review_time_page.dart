import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/player_pages/book_coach/find_coach_page.dart';
import 'package:cme/player_pages/bootcamp/bootcamp_payment_page.dart';
import 'package:cme/player_pages/book_coach/review_booking_time.dart';
import 'package:cme/ui_widgets/buildDots.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class PlayerBootCampReviewPage extends StatefulWidget {
  final BootCampDetails bootCampDetails;
  final UserModel? userModel;
  final List<Userdetails> otherUsers;

  const PlayerBootCampReviewPage({
    Key? key,
    required this.bootCampDetails,
    required this.userModel,
    required this.otherUsers,
  }) : super(key: key);

  @override
  _PlayerBootCampReviewPageState createState() =>
      _PlayerBootCampReviewPageState();
}

class _PlayerBootCampReviewPageState extends State<PlayerBootCampReviewPage> {
  late BootCampDetails bootCampDetails;
  UserModel? userModel;

  Profiledetails? coachProfile;
  Userdetails? coachDetails;

  late int totalSession;
  dynamic totalPrice;

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    bootCampDetails = widget.bootCampDetails;

    coachProfile = bootCampDetails.coachProfile;
    coachDetails = bootCampDetails.coachDetails;
    totalSession = bootCampDetails.bootcamptime!.length;

    totalPrice = totalSession * (bootCampDetails.price ?? 0 ) ;
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
      child: buildBaseScaffold(
        onBackPressed: () async {
          Navigator.pop(context);
          pushRoute(
            context,
            FindCoachPage(
              userModel: userModel,
            ),
          );
        },
        context: context,
        body: buildBody(context),
        title: "Bootcamp Schedule",
        // title: "Review Time",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        dot2(0),
        verticalSpace(height: 18),
        buildCard(Expanded(
          child: Row(
            children: <Widget>[
              CircularNetworkImage(
                imageUrl: photoUrl + coachDetails!.profilePic!,
              ),
              horizontalSpace(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${coachDetails!.name}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  verticalSpace(),
                  Text(
                    "${bootCampDetails.bootCampName}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  verticalSpace(),
                  Row(
                    children: [
                      iconTitle("assets/map_pin.png",
                          "${bootCampDetails.location}", blue),
                    ],
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.star,
                  //       color: Color.fromRGBO(182, 9, 27, 1),
                  //       size: 14,
                  //     ),
                  //     horizontalSpace(),
                  //     Text(
                  //       "${coachProfile.rating}",
                  //       style: TextStyle(fontWeight: FontWeight.w500),
                  //     )
                  //   ],
                  // ),

                  // Text(
                  //   "Range: ${coachProfile.radius}km", //107km", //TODO("CALCULATE RANGE")
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w500,
                  //       color: Color.fromRGBO(182, 9, 27, 1)),
                  // ),
                ],
              )
            ],
          ),
        )),
        verticalSpace(height: 16),
        buildCard(
          Expanded(
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
                          bootCampDetails.bootcamptime!.length,
                          (index) {
                            var date = bootCampDetails.bootcamptime![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${toDate(bootCampDetails.bootCampDate)} ", //"${dateToString(date.time)} ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontFamily: App.font_name2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${Jiffy(date.time, 'h:m').format('hh:mm a')}",
                                      // "${date.time.replaceAll("PM", "")} PM",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: App.font_name2,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(182, 9, 27, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        verticalSpace(height: 16),
        buildCard(Expanded(
          child: Column(
            children: <Widget>[
              iconTextText("assets/price.png", "Session Price",
                  "£${bootCampDetails.price}"),
              verticalSpace(height: 4),
              Divider(
                color: Colors.grey,
              ),
              verticalSpace(height: 4),
              iconTextText("assets/voucher.png", "Session", "$totalSession"),
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
                    "£$totalPrice",
                    style: TextStyle(fontFamily: App.font_name2),
                  ),
                ],
              ),
              verticalSpace(height: 4),
            ],
          ),
        )),
        Spacer(),
        verticalSpace(height: 16),
        proceedButton(
            text: "Next",
            onPressed: () {
              pushRoute(
                  context,
                  PlayerBootCampPaymentPage(
                    bootCampDetails: widget.bootCampDetails,
                    otherUsers: widget.otherUsers,
                    userModel: widget.userModel,
                    totalPrice: totalPrice,
                  ));
            }),
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
