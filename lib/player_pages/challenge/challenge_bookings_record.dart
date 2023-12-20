import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/challenge.dart';
import 'package:cme/network/video_call_token.dart';
import 'package:cme/player_pages/challenge/challenge_edit_booking.dart';
import 'package:cme/player_pages/challenge/find_challenge.dart';
import 'package:cme/ui_widgets/bookings_list_tile_with_slidable.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/dropdowns/block_challenge_dropdown.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/launch.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:cme/video_call/video_call_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ChallengeBookingRecordPage extends StatefulWidget {
  final UserModel? userModel;
  final FetchChallengeBookingResponse? response;

  const ChallengeBookingRecordPage(
      {Key? key, required this.userModel, this.response})
      : super(key: key);

  @override
  _ChallengeBookingRecordPageState createState() =>
      _ChallengeBookingRecordPageState();
}

class _ChallengeBookingRecordPageState
    extends State<ChallengeBookingRecordPage> {
  int selectedIndex = 0;
  List<String> c = [
    "CHALLENGED",
    "SCHEDULED",
    "HISTORY",
  ];
  List<String> level = [
    "Grassroots",
    "Semi Pro",
    "Professional",
    "Expert",
  ];

  UserModel? userModel;
  String selectedLevel = "";

  List<ChallengeBookingDetails>? detailsList = [];

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    selectedLevel = level[0];
    return Scaffold(
      key: _key,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          pushRoute(
            context,
            ChallengeSearchPage(
              userModel: widget.userModel,
            ),
          );
          return false;
        },
        child: buildBaseScaffold(
          onBackPressed: () async {
            Navigator.pop(context);
            pushRoute(
              context,
              ChallengeSearchPage(
                userModel: widget.userModel,
              ),
            );
            return false;
          },
          context: context,
          color: deepBlue,
          textColor: white,
          rightIconWidget: filterIcon(color: white),
          body: buildBody(context),
          title: "Challenge - Bookings",
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            c.length,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: selectedIndex == index
                    ? BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16))
                    : BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: mediumText(c[index], color: white, size: 15),
                ),
              ),
            ),
          ),
        ),
        verticalSpace(),
        Visibility(
          visible: selectedIndex == 0,
          child: Row(
            children: [
              mediumText(
                "Block Challenges From:",
                color: white,
                size: 17,
              ),
              Spacer(),
              Container(
                height: 32,
                child: BlockChallengeFromDropDown(
                  bgColor: deepBlue,
                  textColor: white,
                  onItemChanged: (c) {},
                  currentlyBlocked:
                      userModel!.getUserProfileDetails()?.levelBlocker ?? [],
                  token: userModel!.getAuthToken(),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(height: 16),
        FutureBuilder<FetchChallengeBookingResponse>(
            future: fetchPlayerChallengeBooking(userModel!.getAuthToken()),
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Container(
                  child: Center(
                    child: mediumText("Unable to fetch bookings."),
                  ),
                );
              } else {
                if (snapshot.data == null) {
                  return Container(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  var c = snapshot.data!;
                  if (c.status!) {
                    detailsList = c.details;
                  } else {
                    return Container(
                      child: Center(
                        child: boldText(
                          "Unbale to fetch bookings....Check your internet connection and try again",
                          color: white,
                        ),
                      ),
                    );
                  }

                  return selectedIndex == 0
                      ? buildChallenged(context,detailsList!)
                      : selectedIndex == 1
                          ? buildScheduled(context,detailsList!)
                          : historyList(context,detailsList!);
                }
              }
            })
      ],
    );
  }

  Widget historyList(BuildContext context, List<ChallengeBookingDetails> dl) {
    // print("total recieved.....${dl.length}");
    List<ChallengeBookingDetails> l = [];
    for (ChallengeBookingDetails item in dl) {
      if (item.status == "completed") {
        l.add(item);
      }
    }

    var myId = userModel!.getUserDetails()!.id;
    return l.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpace(height: 200),
              Center(
                child: Icon(
                  Icons.history,
                  size: 64,
                  color: white,
                ),
              ),
              verticalSpace(),
              boldText(
                "Booking History is empty.",
                color: white,
              ),
              // Spacer(),
            ],
          )
        : Column(
            children: List.generate(
              l.length,
              (index) {
                ChallengeBookingDetails b = l[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shadowColor: Colors.black.withOpacity(.5),
                      child: ChallengeScheduledlListTile2(
                        myId: myId,
                        bookingDetails: b,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildScheduled(BuildContext context, List<ChallengeBookingDetails> dl) {
    // print("total recieved.....${dl.length}");
    List<ChallengeBookingDetails> l = [];
    for (ChallengeBookingDetails item in dl) {
      if (item.status == "accepted") {
        l.add(item);
      }
    }

    var myId = userModel!.getUserDetails()!.id;
    return l.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalSpace(height: 200),
              Center(
                child: Icon(
                  Icons.schedule_outlined,
                  size: 64,
                  color: white,
                ),
              ),
              verticalSpace(),
              boldText(
                "You do not have anything scheduled",
                color: white,
              ),
              // Spacer(),
            ],
          )
        : Column(
            children: List.generate(
              l.length,
              (index) {
                ChallengeBookingDetails b = l[index];
                return InkWell(
                  onTap: () => startVirtualSession(context, b, myId),
                  child: ScheduledChallengeBookingsListTile2(
                    onEdit: () async {
                      await pushRoute(
                        context,
                        ChallengeEditBookingEditorPage(
                          userModel: userModel,
                          bookingDetails: b,
                        ),
                      );

                      setState(() {});
                    },
                    onComment: () {
                      pushRoute(
                        context,
                        ChatPage(
                          isChallenge: true,
                          player1Details: myId == b.player1Id
                              ? b.player1Details
                              : b.player2Details,
                          player2Details: myId != b.player1Id
                              ? b.player1Details
                              : b.player2Details,
                          channelName: generateChatRoomName(
                            chatType: "challenge",
                            player1OrCoach1d: b.player1Id,
                            player2Id: b.player2Id,
                            bookingId: b.id,
                          ),
                        ),
                      );
                    },
                    onDelete: () => deleteSentInvitation(context, b),
                    bookingDetails: b,
                    myId: myId,
                  ),
                );
              },
            ),
          );
  }

  startVirtualSession(BuildContext context, ChallengeBookingDetails b, int? myId) async {
    userModel!.setCurrentChallenge(b);
    userModel!.setShowChallengeResult(false);
    userModel!.setmatchUpP1Contoller(
        List.generate(b.tryout!, (index) => TextEditingController(text: "")));
    userModel!.setmatchUpP2Contoller(
        List.generate(b.tryout!, (index) => TextEditingController(text: "")));

    if (b.sessionmode == 0) {
      var r = await launchMap(lat: "${b.lat / 1.0}", long: "${b.lon / 1.0}");
      showSnack(context, r);
      return;
    }

    var bookingTime =
        bookingTimeStringToDateTime(b.bookingDates!, "${b.startTime}");
    if (b.startDateTime!
        .isBefore(DateTime.now().subtract(Duration(minutes: 5)))) {
      showSnack(context, "Session can't start now. Err 33");
      return;
    }

    var channelName = "challenge_${b.id}_by_${b.player1Details!.id}";
    await handleCameraAndMic();

    if (b.player1Details!.id == myId) {
      ProgressDialog dialog = new ProgressDialog(context, isDismissible: true);
      dialog.style(message: 'Please wait...');
      await dialog.show();

      var token = await (genrateVideoToken(userModel!.getAuthToken(), channelName: channelName, isMainUser: true));

      if (token == null || token.isEmpty) {
        await dialog.hide();
        showSnack(context, "Generate Video Token Failed....Try again");
        return;
      }
      print("....recieved token...$token");

      GeneralResponse v = await startVirtualChallenge(userModel!.getAuthToken(),
          challengeId: "${b.id}", videoToken: token);

      if (v.status!) {
        await dialog.hide();
        pushRoute(
            context,
            VideoCallPage(
              eventType: challengeEvent,
              role: ClientRoleType.clientRoleBroadcaster,
              token: token,
              userId: myId,
              channelName: channelName,
              endVirtualSession: () => endVirtualSession(b),
              audienceDetails: b.player2Details,
              hostDetails: b.player1Details,
              chatMessagePath: generateChatRoomName(
                chatType: "challenge",
                player1OrCoach1d: b.player1Id,
                player2Id: b.player2Id,
                bookingId: b.id,
              ),
              sessionStartTime: bookingTime,
            ));
      }

      await dialog.hide();
    } else {
      if (b.virtualstatus == eventStarted) {
        var token = await (genrateVideoToken(userModel!.getAuthToken(), channelName: channelName, isMainUser: false));

        pushRoute(
          context,
          VideoCallPage(
            chatMessagePath: generateChatRoomName(
              chatType: "challenge",
              player1OrCoach1d: b.player1Id,
              player2Id: b.player2Id,
              bookingId: b.id,
            ),
            sessionStartTime: bookingTime,
            eventType: challengeEvent,
            role: ClientRoleType.clientRoleBroadcaster,
            token: token,
            userId: myId,
            channelName: channelName,
            endVirtualSession: () {
              endVirtualSession(b);
            },
            audienceDetails: b.player2Details,
            hostDetails: b.player1Details,
          ),
        );
      } else if (b.virtualstatus == eventCompleted) {
        showSnack(context, "Host has ended session");
      } else {
        showSnack(context, "Host not stated session");
      }
    }
  }

  endVirtualSession(ChallengeBookingDetails b) async {
    print("End session.....");
    // GeneralResponse v = await

    Navigator.pop(context);

    await endVirtualChallenge(
      userModel!.getAuthToken(),
      challengeId: "${b.id}",
    );
    // pushRoute(
    //     context,
    //     SessionReviewPage(
    //       audienceDetails: b.player2Details,
    //       hostDetails: b.player1Details,
    //     ));
  }

  Widget buildChallenged(BuildContext context, List<ChallengeBookingDetails> dl) {
    List<ChallengeBookingDetails> l = [];
    for (ChallengeBookingDetails item in dl) {
      if (item.status == "pending") {
        l.add(item);
      }
    }

    List<ChallengeBookingDetails> sent = [];
    List<ChallengeBookingDetails> recv = [];

    var myId = userModel!.getUserDetails()!.id;
    for (ChallengeBookingDetails item in l) {
      if (item.player1Id == myId) {
        sent.add(item);
      } else {
        recv.add(item);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        recv.isEmpty
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.mail,
                        size: 64,
                        color: white,
                      ),
                      mediumText(
                        "No invitations recieved.",
                        color: white,
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: List.generate(
                  recv.length,
                  (index) {
                    ChallengeBookingDetails b = recv[index];
                    var p2 = b.player1Details!;
                    return InkWell(
                      onTap: () {
                        // pushRoute(context, ChallengeMAtchUpPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ChallengeBookingsListTile(
                          points: "${b.player2Profile != null ? calculatePlayerPoints2(b.player2Profile!) : 0}",
                          onAccept: () {
                            acceptInvitation(context, b);
                          },
                          onDelete: () {
                            declineInvitation(context, b);
                          },
                          imgUrl: photoUrl + p2.profilePic!,
                          name: p2.name,
                          expLevel: "${getSportLevel(p2)}",
                          dateText: b.displayDate,
                          locationText: b.location,
                        ),
                      ),
                    );
                  },
                ),
              ),
        verticalSpace(),
        mediumText(
          "Your sent invitations",
          color: white,
        ),
        buildDivider(),
        sent.isEmpty
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.send_outlined,
                        size: 64,
                        color: white,
                      ),
                      mediumText(
                        "No Invitations Sent.",
                        color: white,
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: List.generate(
                  sent.length,
                  (index) {
                    ChallengeBookingDetails b = sent[index];
                    var p2 = b.player2Details!;
                    return InkWell(
                      onTap: () {
                        // pushRoute(context, ChallengeMAtchUpPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ChallengeBookingsListTile(
                          onDelete: () => deleteSentInvitation(context, b),
                          imgUrl: photoUrl + p2.profilePic!,
                          name: p2.name,
                          expLevel: "${getSportLevel(p2)}",
                          dateText: b.displayDate,
                          locationText: b.location,
                          points: "${b.player2Profile != null ? calculatePlayerPoints2(b.player2Profile!) : 0}",
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  deleteSentInvitation(BuildContext context,ChallengeBookingDetails b) async {
    GeneralResponse g = await deleteChallengeBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }

  acceptInvitation(BuildContext context,ChallengeBookingDetails b) async {
    GeneralResponse g = await approveChallengeBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }

  declineInvitation(BuildContext context,ChallengeBookingDetails b) async {
    GeneralResponse g = await declineChallengeBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }
}

Future<void> handleCameraAndMic() async {
  try {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
  } catch (e) {
    print("..permission reques....error...$e");
  }
}
