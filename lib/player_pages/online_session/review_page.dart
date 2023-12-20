import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class PlayerBookingSessionReviewPage extends StatefulWidget {
  final UserModel? userModel;
  final coachId;
  final bookingId;

  const PlayerBookingSessionReviewPage({
    Key? key,
    required this.userModel,
    required this.bookingId,
    required this.coachId,
  }) : super(key: key);
  @override
  _PlayerBookingSessionReviewPageState createState() =>
      _PlayerBookingSessionReviewPageState();
}

class _PlayerBookingSessionReviewPageState
    extends State<PlayerBookingSessionReviewPage> {
  int selectedTimeIndex = 0;
  List<BNBItem> list = [
    BNBItem("On time", "10m"),
    BNBItem("10m later", "10m"),
    BNBItem("30m later", "30m"),
    BNBItem("> 2h later", "2h"),
  ];

  int selectedStartTime = 0;

  double expRating = 5;
  double venueRating = 5;
  double equipRating = 5;
  double commRating = 5;

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBaseScaffold(
          context: context, body: buildBody(context), title: "Write a review"),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        textRatingColumn(
          "How would you rate your experience? (Mandatory)",
          rating: expRating,
          onRatingChange: (r) {
            setState(() {
              expRating = r;
            });
          },
        ),
        buildTimeReview(),
        textRatingColumn(
          "Was the venue appropriate? (Optional)",
          rating: venueRating,
          onRatingChange: (r) {
            setState(() {
              venueRating = r;
            });
          },
        ),
        textRatingColumn(
          "How was the use of equipment? (Optional)",
          rating: equipRating,
          onRatingChange: (r) {
            setState(() {
              equipRating = r;
            });
          },
        ),
        textRatingColumn(
          "How was the communication? (Optional)",
          rating: commRating,
          onRatingChange: (r) {
            setState(() {
              commRating = r;
            });
          },
        ),
        buildInputBox(controller: controller),
        verticalSpace(height: 16),
        proceedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, NavigatePageRoute(context, HomeScreen()));
            },
            text: "Submit Review"),
        verticalSpace(),
        borderProceedButton(
            text: "Report",
            onPressed: () {
              showReportUserDialog();
            },
            color: deepRed),
        verticalSpace(height: 16),
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
                            "for your own/other persons' safety.",
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

  Widget buildTimeReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Did your session start on time? (optional)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        // verticalSpace(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              list.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    selectedStartTime = index;
                  });
                },
                child: buildIcon(
                    isSelected: index == selectedStartTime,
                    bottomText: list[index].title,
                    icon: index == 0 ? "" : null,
                    topText: list[index].icon),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIcon(
      {bool isSelected = false, bottomText: "On Time", icon, topText: ""}) {
    return Column(
      children: <Widget>[
        Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: isSelected ? blue : Colors.transparent,
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: !isSelected ? Colors.grey : Colors.transparent,
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon == null
                  ? Center(
                      child: mediumText(
                        topText,
                        color: !isSelected ? Colors.grey : Colors.black,
                      ),
                    )
                  : Icon(
                      Icons.access_time,
                      color: !isSelected ? Colors.grey : Colors.black,
                    ),
            )),
        verticalSpace(),
        Text(
          "$bottomText",
          style: isSelected
              ? TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
              : TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 12),
        ),
      ],
    );
  }

  Widget buildInputBox({controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Tell us about your experience",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        verticalSpace(),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              minLines: 8,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tell us about your experience"),
              maxLines: null,
            ),
          ),
        )
      ],
    );
  }
}

Widget textRatingColumn(String text,
    {required double rating, required onRatingChange}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      verticalSpace(),
      SmoothStarRating(
        onRatingChanged: onRatingChange,
        allowHalfRating: true,
        starCount: 5,
        rating: rating,
        color: Color.fromRGBO(255, 193, 7, 1), //rgba(255, 193, 7, 1)
        size: 48,
        borderColor: Color.fromRGBO(255, 193, 7, 1),
      ),
      verticalSpace(height: 16),
    ],
  );
}
