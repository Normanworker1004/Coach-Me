import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach_booking_note_response.dart';
import 'package:cme/model/fetch_player_boot_camp_list.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/player/booking.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/player_pages/book_coach/find_coach_page.dart';

import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/launch.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BootCampListPage extends StatefulWidget {
  final UserModel userModel;

  const BootCampListPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _BootCampListPageState createState() => _BootCampListPageState();
}

class _BootCampListPageState extends State<BootCampListPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  UserModel? userModel;

  List<BootCampDetails?> bootCampList = []; //BootCampDetails bootcampdetails

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
        onBackPressed: () async {
          Navigator.pop(context);
          pushRoute(
            context,
            FindCoachPage(
              userModel: userModel,
            ),
          );
          return false;
        },
        hideBack: false,
        backgroundImage: "assets/bg1.png",
        backgroudOpacity: .79,
        bottomPadding: 32,
        textColor: white,
        // rightIconWidget: filterIcon(),
        context: context,
        body: buildBody(context),
        title: "Bootcamp",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FutureBuilder<FetchPlayerBootCampListResponse>(
            future: fetchPlayerBootCampList(userModel!.getAuthToken()),
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container(
                  child: Center(
                    child: mediumText("Unable to fetch booking"),
                  ),
                );
              } else {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                } else {
                  var r = snapshot.data!;
                  if (r.status!) {
                    var d = r.details!;
                    bootCampList = List.generate(
                        d.length, (index) => d[index].bootcampdetails);
                  } else {
                    return Container(
                      child: Center(
                        child: mediumText("Error occured...", color: white),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: bootCampList.length,
                    itemBuilder: (b, index) {
                      var d = bootCampList[index]!;
                      // var coach = d.coachinfo;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: InkWell(
                          onTap: () async {
                            var r = await launchMap(
                                lat: "${d.lat / 1.0}", long: "${d.lon / 1.0}");
                            showSnack(context, r);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: InkWell(
                              onTap: () async {
                                var r = await launchMap(
                                    lat: "${d.lat / 1.0}",
                                    long: "${d.lon / 1.0}");
                                showSnack(context, r);
                              },
                              child: Card(
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
                                        onPressed: (context){
                                          pushRoute(
                                            context,
                                            ChatPage(
                                              isChallenge: true,
                                              player1Details:
                                              userModel!.getUserDetails(),
                                              player2Details:
                                              userModel!.getUserDetails(),
                                              channelName: generateChatRoomName(
                                                chatType: "bootcamp",
                                                player1OrCoach1d:
                                                "", // d.coachDetails.id,
                                                player2Id: "",
                                                bookingId: d.id,
                                              ),
                                            ),
                                          );
                                        },
                                        backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
                                        foregroundColor: Colors.black,
                                        label: 'Message',
                                        // icon:
                                        // ImageIcon(
                                        //   AssetImage( "assets/message.png")
                                        //  ),
                                      ),


                                    ],
                                  ),
                                  child:   Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircularImage(
                                          imageUrl: "assets/boot_icon.png",
                                          size: 48,
                                        ),
                                        horizontalSpace(),
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                mediumText("${d.bootCampName}"),
                                                verticalSpace(height: 4),
                                                Row(
                                                  // direction: Axis.horizontal,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: iconTitleExpanded(
                                                          "assets/booking_clock.png",
                                                          "${toDateNormal(d.bootCampDate)}",
                                                          Colors.red),
                                                    ),
                                                    horizontalSpace(width: 4),
                                                    Expanded(
                                                      child: iconTitleExpanded(
                                                          "assets/map_pin.png",
                                                          "${d.location}",
                                                          mapPinBlue),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                ),


                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            }),
      ),
    );
  }

  deleteCoachBooking(BuildContext context, id) async {
    Navigator.pop(context);
    var r = await deleteBooking(userModel!.getAuthToken(), bookid: "$id");
    showSnack(context, r.message);
  }
}

Widget buildNotes(context, List<Coachnote> notes) {
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
                            notes.length,
                            (index) {
                              var n = notes[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              text: "${n.date} "),
                                          TextSpan(text: "${n.note}"),
                                        ]),
                                  ),
                                  buildDivider(),
                                ],
                              );
                            },
                          ),
                        ),
                        verticalSpace(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog'); //Dialog Close Dialog
                      },
                      child: Image.asset(
                        "assets/close2.png",
                        width: 14,
                        height: 14,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mediumText("Notes from your Coach", size: 20),
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

showNotes(context, List<Coachnote> notes) {
  showDialog(
    context: context,
    builder: (c) => buildNotes(context, notes),
  );
}

showDeleteDialogue(context) {
  showDialog(
    context: context,
    builder: (c) => Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: 246,
            width: 343,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Row(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: App.font_name,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            children: [
                              TextSpan(
                                  text:
                                      "Are you sure you want to cancel the booking? \n"),
                              TextSpan(
                                style: TextStyle(
                                  color: Color.fromRGBO(153, 153, 153, 1),
                                  fontFamily: App.font_name,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                text:
                                    "Please be aware of refund policy. Once booking has been completed the booking will be removed and archived in history.",
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(195, 195, 195, 1),
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16)),
                                ),
                                height: 55,
                                child: Center(
                                  child: mediumText(
                                    "Cancel",
                                    color: red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(195, 195, 195, 1),
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: mediumText(
                                    "Yes",
                                    color: Color.fromRGBO(195, 195, 195, 1),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/*
                         PlayerBookingsListTile(
                          experienceLevel: "${getCoachSportLevel(coach)}",
                          dateText: "${toDate(d.bootCampDate)}",
                          locationText: "${d.location}",
                          name: "${d.coachinfo.name}",
                          imgUrl: "${photoUrl + coach.profilePic}",
                          status: d.status == "pending"
                              ? "Awaiting Confirmation"
                              : d.status == "accepted"
                                  ? "Booked"
                                  : "",
                          count: d.coachnote.length,
                          onDelete: () => showDeleteDialogue(context),
                          onEdit: () => pushRoute(context, BookingEditorPage()),
                          onComment: () => Navigator.push(
                              context,
                              NavigatePageRoute(
                                context,
                                ChatPage(
                                  player1Details: userModel.getUserDetails(),
                                  player2Details: d.coachinfo,
                                  channelName:
                                      'booking_message_${d.id}_${d.coachId}_',
                                  isHost: false,
                                ),
                              )),
                        ),

                        */
