import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/session_review/coach_session_review_page.dart';
import 'package:cme/model/coach_booking_note_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/video_call_token.dart';
import 'package:cme/custom_chat/chat_page.dart';

import 'package:cme/ui_widgets/build_booking_list_tile.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/launch.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:cme/video_call/video_call_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:cme/player_pages/challenge/challenge_bookings_record.dart';

class AcceptedBooking extends StatefulWidget {
  final UserModel? userModel;
  final scafKey;

  const AcceptedBooking({
    Key? key,
    required this.userModel,
    required this.scafKey,
  }) : super(key: key);

  @override
  _AcceptedBookingState createState() => _AcceptedBookingState();
}

class _AcceptedBookingState extends State<AcceptedBooking> {
  List<CoachBookingDetail>? details = [];
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
        initialData: userModel!.getCoachBookings()[1],
        future: fetchBoking(userModel!.getAuthToken(), status: "accepted"),
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
              var s = snapshot.data!;
              if (s.status!) {
                details = s.details;
                userModel!.getCoachBookings()[1] = s;
              }
              if (details!.isEmpty) {
                return Center(
                  child: boldText(
                    "You do not have any accepted booking",
                    textAlign: TextAlign.center,
                    color: white,
                  ),
                );
              } else {
                return ListView(
                  children: [
                    verticalSpace(height: 16),
                    Column(
                      children: List.generate(
                        details!.length,
                        (index) {
                          CoachBookingDetail d = details![index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Accepted(
                              k: _key,
                              d: d,
                              userModel: userModel,
                              refresh: () {
                                // print("refresh");
                                setState(() {});
                              },
                              startSession: () => startVirtualSession(context, d),
                            ),
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

  endVirtualSession(CoachBookingDetail b) async {
    // print("End session.....");
    // GeneralResponse v = await

    Navigator.pop(context);
    endVirtualBooking(
      userModel!.getAuthToken(),
      bookingId: "${b.id}",
    );

    await pushRoute(
      context,
      CoachSessionReviewPage(
        details: b,
        userModel: userModel,
        playerId: b.userid,
      ),
    );

    setState(() {});
  }

  startVirtualSession(BuildContext context, CoachBookingDetail b) async {
    if (b.sessionmode == 1) {
      var r = await launchMap(lat: "${b.lat / 1.0}", long: "${b.lon / 1.0}");
      showSnack(context, "$r\n\n\n\n\n");
      return;
    }
    var bookingTime = coachBookingTimeStringToDateTime(
      b.bookingDates!,
      b.bookingtime!.split(":").first,
    );

     if (bookingTime.isBefore(DateTime.now().subtract(Duration(minutes: 60)))) {
       showSnack(context, "${bookingTime} ?? ${DateTime.now().subtract(Duration(minutes:30))}Session can't start now : err 11");
      return;
     }

    // if (canStart) {
    //   showSnack(context, "Session can't start now");
    //   return;
    // }

    await handleCameraAndMic();
    ProgressDialog dialog = new ProgressDialog(context, isDismissible: true);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var channelName = "booking_${b.id}_by_${b.coachId}";

    var token = await (genrateVideoToken( userModel!.getAuthToken(), channelName: channelName,isMainUser: true)  ) ?? "";

    if (token.isEmpty) {
      await dialog.hide();
      showSnack(context, "Generate Video Token Failed....Try again\n\n\n\n\n");
      return;
    }
     print("....recieved token...$token");

    GeneralResponse response = await startVirtualBooking(
      userModel!.getAuthToken(),
      bookingId: "${b.id}",
      videoToken: token,
    );

    if (response.status!) {
      await dialog.hide();
      await pushRoute(
        context,
        VideoCallPage(
          eventType: bookingEvent,
          role: agora.ClientRoleType.clientRoleBroadcaster,
          token: token,
          userId: userModel!.getUserDetails()!.id,
          channelName: channelName,
          endVirtualSession: () => endVirtualSession(b),
          audienceDetails: b.user,
          hostDetails: userModel!.getUserDetails(),
          chatMessagePath: generateChatRoomName(
            chatType: "booking",
            player1OrCoach1d: b.coachId,
            player2Id: b.userid,
            bookingId: b.id,
          ),
          sessionStartTime: bookingTime,
        ),
      );

      setState(() {});
    }

    await dialog.hide();
  }

  onDenyInvitation( BuildContext context, CoachBookingDetail d) async {
    var p =
        await rejectBooking(userModel!.getAuthToken(), bookid: d.id.toString());

    showSnack(
        context,
        p.status!
            ? "Booking Rejected\n\n\n\n\n"
            : "Booking Reject failed\n\n\n\n\n");
  }

  acceptInvitation(BuildContext context, CoachBookingDetail d) async {
    // print("accept");

    var p = await approveBooking(
      userModel!.getAuthToken(),
      bookid: d.id.toString(),
      location: d.location,
      lon: d.lon.toString(),
      lat: d.lat.toString(),
    );

    showSnack(
        context,
        p.status!
            ? "Booking Accepted\n\n\n\n\n"
            : "Booking Accept failed\n\n\n\n\n");
  }
}

class Accepted extends StatefulWidget {
  final CoachBookingDetail? d;
  final k;
  final UserModel? userModel;
  final Function? refresh;
  final startSession;

  const Accepted(
      {Key? key,
      this.d,
      this.k,
      this.userModel,
      this.refresh,
      required this.startSession})
      : super(key: key);

  @override
  _AcceptedState createState() => _AcceptedState();
}

class _AcceptedState extends State<Accepted> {
  TextEditingController writeNoteController = TextEditingController();
  CoachBookingDetail? d;

  @override
  void initState() {
    super.initState();

    d = widget.d;
  }

  @override
  Widget build(BuildContext context) {
    var coach = widget.userModel!.getUserDetails();

    return InkWell(
      onTap: widget.startSession,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                      onPressed: (c) {
                        showDialog(
                          context: context,
                          builder: (c) => buildNotes(widget.d!.coachnote, context),
                        );
                      },
                      backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                      foregroundColor: Colors.black,
                       icon: Icon(Icons.file_open).icon,
                      // icon:
                      // ImageIcon(
                      //   AssetImage( "assets/edit_red.png")
                      //  ),
                    ),

                    SlidableAction(
                      onPressed: (context){
                        pushRoute(
                          context,
                          ChatPage(
                            player1Details: coach,
                            player2Details: d!.user,
                            channelName: generateChatRoomName(
                              chatType: "booking",
                              player1OrCoach1d: d!.coachId,
                              player2Id: d!.userid,
                              bookingId: d!.id,
                            ),
                          ),
                        );
                      },
                      backgroundColor: normalBlue,
                      foregroundColor: Colors.white,
                      label: 'Message',
                      icon:Icons.chat_bubble
                    ),

                    SlidableAction(
                      onPressed: (context){
                        showDeleteDialogue(context,widget.d);
                      },
                      backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                      foregroundColor: Colors.black,
                      icon:Icons.delete

                    ),
                  ],
                ),
                child: SessionDetailListTile(
                  imgUrl: "${photoUrl + (d?.user?.profilePic ?? "") }",
                  level: "${getSportLevel(d!.user!)}",
                  name: "${d!.user!.name}",
                  date: "${d!.displayDate}", //"${toDate(d.bookingDates)}",
                  location: "${d!.location}",
                ),
              ),
            ),
          ),
          verticalSpace()
        ],
      ),
    );
  }

  Widget buildNotes(List<Coachnote>? notes, BuildContext context) {
    // print("$notes");
    if (notes == null) {
      notes = [];
    }
    writeNoteController.clear();
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
                          Expanded(
                            child: ListView(
                              children: List.generate(
                                notes.length,
                                (index) {
                                  Coachnote c = notes![index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.left,
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
                                                      text: "${c.date} "),
                                                  TextSpan(text: "${c.note}"
                                                      // "Please bring your water bottle and a towel with you. There will be lots cardio exercises.",
                                                      ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                      buildDivider(),
                                    ],
                                  );
                                },
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
                              controller: writeNoteController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontFamily: App.font_name, fontSize: 14),
                                hintText: "Write note to player",
                              ),
                            ),
                          ),
                          verticalSpace(),
                          proceedButton(
                            text: "Send Note",
                            onPressed: () async {
                              var j = Jiffy();
                              var date = "${j.day}/${j.month}/${j.year}";

                              await addBookingNote(
                                widget.userModel!.getAuthToken(),
                                bookid: widget.d!.id.toString(),
                                date: date,
                                note: writeNoteController.text.trim(),
                              );
                              widget.refresh!();
                              Navigator.of(context, rootNavigator: true).pop('dialog'); //Dialog Close Dialog
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: InkWell(
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

  showDeleteDialogue(BuildContext context, CoachBookingDetail? d) {
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
              var r = await deleteBooking(widget.userModel!.getAuthToken(),
                  bookid: d!.id.toString());
              showSnack(context, "${r.message}\n\n\n\n\n");
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
}
