import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/coach_booking/accepted_booking.dart';
import 'package:cme/coach_pages/coach_booking/history_booking.dart';
import 'package:cme/coach_pages/coach_booking/pending_booking.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_booking_list_tile.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class CoachBookingsSection extends StatefulWidget {
  final UserModel? userModel;

  const CoachBookingsSection({Key? key, required this.userModel})
      : super(key: key);
  @override
  _CoachBookingsSectionState createState() => _CoachBookingsSectionState();
}

class _CoachBookingsSectionState extends State<CoachBookingsSection> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int catIndex = 0;
  UserModel? userModel;

  List<String> apiKeys = [
    "pending",
    "accepted",
    "completed",
  ];

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        color: Colors.transparent.withOpacity(.5),
        textColor: white,
        backgroundImage: "assets/bg1.png",
        hideBack: true,
        backgroudOpacity: .79,
        context: context,
        body: buildBody(context),
        title: "Bookings",
        rightIconWidget: filterIcon(),
      ),
    );
  }

  Widget buildNotes(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: 429,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Row(),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Column(
                        children: [
                          Wrap(
                            children: List.generate(
                              2,
                              (index) => Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontFamily: "ROBOTO",
                                          fontSize: 10,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    29, 90, 235, 1)),
                                            text: "10/03/20 "),
                                        TextSpan(
                                          text:
                                              "Please bring your water bottle and a towel with you. There will be lots cardio exercises.",
                                        ),
                                      ],
                                    ),
                                  ),
                                  buildDivider(),
                                ],
                              ),
                            ),
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
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontFamily: App.font_name,
                                        fontSize: 14),
                                    hintText: "Write note to player"),
                              )),
                          verticalSpace(),
                          proceedButton(
                            text: "Send Note",
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop('dialog'); //Dialog Close Dialog
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: Image.asset(
                        "assets/close2.png",
                        width: 14,
                        height: 14,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          mediumText("Notes To Player", size: 20),
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

  showNotes(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => buildNotes(context),
    );
  }

  showDeleteDialogue(BuildContext context, CoachBookingDetail d) {
    showCupertinoDialog(
      context: this.context,
      builder: (c) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to delete this Booking?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Text(
          "Note: all content will be deleted",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(182, 9, 27, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var r = await deleteBooking(userModel!.getAuthToken(),
                  bookid: d.id.toString());
              showSnack(context, r.message);
            },
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    List<String> l = [
      "Invited",
      "Accepted",
      "history",
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  catIndex = index;
                });
              },
              child: catIndex == index
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: normalBlue //Color.fromRGBO(182, 9, 27, 1),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                        child: lightText(
                          l[index].toUpperCase(),
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : lightText(
                      l[index].toUpperCase(),
                      size: 15,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
        Expanded(
          child: catIndex == 0
              ? PendingBooking(userModel: userModel, scafKey: _key)
              : catIndex == 1
                  ? AcceptedBooking(userModel: userModel, scafKey: _key)
                  : CompletedBooking(userModel: userModel, scafKey: _key),
        ),
      ],
    );
  }
}

Widget rating(text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SmoothStarRating(
        starCount: 5,
        size: 16,
        rating: 5,
        color: Colors.yellow,
      ),
      lightText(text)
    ],
  );
}

class Invited extends StatelessWidget {
  final CoachBookingDetail details;
  final Function onAccept;
  final Function onDeny;

  const Invited({
    Key? key,
    required this.onAccept,
    required this.onDeny,
    required this.details,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Card(
            // elevation: 16,
            margin: EdgeInsets.all(0),
            shadowColor: Colors.black.withOpacity(.5),
            child:
            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                // All actions are defined in the children parameter.
                children:   [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: onAccept as void Function(BuildContext)?,
                    backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
                    foregroundColor: Colors.black,
                    label: 'Message',
                    icon: Icons.check,
                  ),

                  SlidableAction(
                    onPressed: onDeny as void Function(BuildContext)?,
                    backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                    foregroundColor: Colors.white,
                    label: 'Delete',
                    icon:Icons.close
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/trash.png")
                    //  ),
                  ),
                ],
              ),
              child: SessionDetailListTile(
                imgUrl: "${photoUrl + details.user!.profilePic!}",
                level: "${getSportLevel(details.user!)}",
                name: "${details.user!.name}", //"Jason Smith",
                date: "${details.displayDate}",
                location: details.sessionmode == 0 ? "Virtual" : "Not set.",
              ),
            ),
          ),
        ),
        verticalSpace()
      ],
    );
  }
}
