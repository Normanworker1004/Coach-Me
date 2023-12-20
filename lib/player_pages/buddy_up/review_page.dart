import 'package:cme/app.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class BuddySessionReviewPage extends StatefulWidget {
  @override
  _BuddySessionReviewPageState createState() => _BuddySessionReviewPageState();
}

class _BuddySessionReviewPageState extends State<BuddySessionReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBaseScaffold(
          leftIcon: Icons.close,
          context: context,
          body: buildBody(context),
          title: "Write a review"),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 150.0),
          child: ListView(
            children: <Widget>[
              textRatingColumn(
                  "How would you rate your experience? (Mandatory)"),
              textRatingColumn("did you reach your target?  (Optional)"),
              buildTimeReview(),
              buildInputBox(),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Column(
            children: <Widget>[
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
                    showReportDialogue();
                  },
                  color: deepRed),
            ],
          ),
        )
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

  showReportDialogue() {
    showCupertinoDialog(
      context: this.context,
      builder: (c) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Report coach",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Column(
          children: <Widget>[
            Text(
              "Please use this page ONLY to report issues of serious nature. This could be fro reasons such as [but not limited to] presenting/acting inappropriately, for your own/other persons' safety.",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpace(),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    minLines: 8,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tell us about your experience"),
                    maxLines: null,
                  ),
                ),
              ),
            ),
            verticalSpace(height: 16),
            proceedButton(
                text: "Submit Report",
                onPressed: () {
                  Navigator.pop(context);
                }),
            verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget buildTimeReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        mediumText(
          "Did your session start on time? (optional)",
          // "Did your requst start on time? (optional)",
          size: 15,
        ),
        // verticalSpace(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeIndex = index;
                  });
                },
                child: buildIcon(
                  index,
                  index == selectedTimeIndex,
                  list[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int selectedTimeIndex = 0;
  List<BNBItem> list = [
    BNBItem("On time", "10m"),
    BNBItem("10m later", "10m"),
    BNBItem("30m later", "30m"),
    BNBItem("> 2h later", "2h"),
  ];

  Widget buildIcon(index, bool isSelected, BNBItem item) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 56,
            width: 56,
            decoration: isSelected
                ? BoxDecoration(
                    color: blue,
                    // border: Border.all(color: Colors.gre),
                    borderRadius: BorderRadius.circular(8))
                : BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: index == 0
                  ? Image.asset(
                      "assets/booking_clock.png",
                      color:
                          isSelected ? white : Color.fromRGBO(153, 153, 153, 1),
                      scale: 1.5,
                      height: 10,
                      width: 10,
                    )
                  : Center(
                      child: rMediumText(item.icon,
                          size: 14,
                          color: isSelected
                              ? white
                              : Color.fromRGBO(153, 153, 153, 1)),
                    ),
            ),
          ),
          verticalSpace(),
          boldText(item.title,
              color:
                  isSelected ? Colors.black : Color.fromRGBO(153, 153, 153, 1),
              size: 12),
        ],
      ),
    );
  }

  Widget buildInputBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Tell us about your experience (Optional)",
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
              minLines: 4,
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

Widget textRatingColumn(String text) {
  double rating = 3;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      mediumText(text, size: 15),
      verticalSpace(),
      SmoothStarRating(
        allowHalfRating: true,
        starCount: 5,
        rating: rating,
        color: starRatingColor, //rgba(255, 193, 7, 1)
        size: 48,
        borderColor: starRatingColor,
      ),
      verticalSpace(height: 16),
    ],
  );
}
