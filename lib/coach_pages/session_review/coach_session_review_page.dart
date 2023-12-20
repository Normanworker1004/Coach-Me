import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/session_review/iap.dart';
import 'package:cme/network/reviews.dart';
import 'package:cme/player_pages/online_session/review_page.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class CoachSessionReviewPage extends StatefulWidget {
  final CoachBookingDetail details;
  final int? playerId;
  final UserModel? userModel;

  const CoachSessionReviewPage({
    Key? key,
    required this.details,
    required this.playerId,
    required this.userModel,
  }) : super(key: key);

  @override
  _CoachSessionReviewPageState createState() => _CoachSessionReviewPageState();
}

class _CoachSessionReviewPageState extends State<CoachSessionReviewPage> {
  double ratePlayer = 5;
  double rateArea = 5;
  UserModel? userModel;

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, widg, model) {
        userModel = model;
        return buildBaseScaffold(
            leftIcon: Icons.close,
            context: context,
            body: buildBody(context),
            title: "Write a Review");
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        textRatingColumn(
          "How would you rate the player? (Mandatory)",
          rating: ratePlayer,
          onRatingChange: (r) {
            setState(() {
              ratePlayer = r;
            });
          },
        ),
        verticalSpace(height: 16),
        mediumText(
          "Area of development (Optional)",
          size: 15,
        ),
        // verticalSpace(),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: CustomBioDropDown(
        //       // selectedItem: "",
        //       // title: "Attitude",
        //       // color: Color.fromRGBO(229, 229, 229, 1),
        //       ),
        // ),
        verticalSpace(),
        SmoothStarRating(
          onRatingChanged: (c) {
            setState(() {
              rateArea = c;
            });
          },
          starCount: 5,
          size: 42,
          allowHalfRating: true,
          rating: rateArea,
          borderColor: Color.fromRGBO(255, 193, 7, 1),
          color: Color.fromRGBO(255, 193, 7, 1), //rgba(255, 193, 7, 1)
        ),
        verticalSpace(height: 16),
        mediumText(
          "Note to Player (Optional)",
          size: 15,
        ),
        verticalSpace(),
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 192,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(206, 206, 206, 1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: noteController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(fontFamily: App.font_name, fontSize: 14),
                hintText: "Tell us about your experience"),
          ),
        ),
        verticalSpace(height: 16),
        mediumText(
          "Voice note to Player (Optional)",
          size: 15,
        ),
        verticalSpace(),
        Card(
          elevation: 8,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.1), //rgba(0, 0, 0, 0.1)
          child: Row(
            children: [
              Expanded(child: Image.asset("assets/wave.png")),
              Container(
                height: 70,
                width: 68,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                    ),
                    child: Image.asset(
                      "assets/mic.png",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(),
        borderProceedButton(
          text: "Create AIP",
          onPressed: () {
            pushRoute(
                context,
                SetIAPPage(
                  playerId: widget.playerId,
                  userModel: userModel,
                ));
          },
          color: Color.fromRGBO(25, 87, 234, 1),
        ),
        verticalSpace(),
        proceedButton(
          isLoading: isLoading,
          text: "Submit Review",
          onPressed: () {
            submitReview();
          },
        ),
        verticalSpace(),
        borderProceedButton(
            text: "Report",
            onPressed: () {
              showReportUserDialog();
            },
            color: Color.fromRGBO(182, 9, 27, 1)),
      ],
    );
  }

  Widget buildReportUser() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: 520,
            child: Material(
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Row(),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Column(
                        children: [
                          Text(
                            "Please use this page ONLY to report "
                            "issues of a serious nature. This could "
                            "be for reasons such as (but not limited to)"
                            " presenting/acting inappropriately, "
                            "for your own/other person safety.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          verticalSpace(height: 22),
                          Container(
                              padding: EdgeInsets.only(left: 16),
                              height: 192,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(206, 206, 206, 1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontFamily: App.font_name,
                                        fontSize: 14),
                                    hintText: ""),
                              )),
                          verticalSpace(height: 22),
                          proceedButton(
                            text: "Submit Report",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          boldText("Report Player", size: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showReportUserDialog() {
    showDialog(
      context: this.context,
      builder: (c) => buildReportUser(),
    );
  }

  bool isLoading = false;
  void submitReview() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    CoachBookingDetail details = widget.details;
    var r = await createCoachReview(
      bookingid: details.id,
      rating: "$ratePlayer",
      bookingtype: "booking",
      comment: noteController.text.toString(),
      attitude: "$rateArea",
      expression: "5",
      fitness: "5",
      playerid: widget.playerId,
      token: userModel!.getAuthToken()!,
      voicenote: null,
    );

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }
}
