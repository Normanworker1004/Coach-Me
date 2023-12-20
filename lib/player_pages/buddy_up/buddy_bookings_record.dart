import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/buddy_up.dart';
import 'package:cme/network/video_call_token.dart';
import 'package:cme/player_pages/buddy_up/buddyup_edit_booking_page.dart';
import 'package:cme/player_pages/buddy_up/find_buddy_page.dart';
import 'package:cme/player_pages/challenge/challenge_bookings_record.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/ui_widgets/bookings_list_tile_with_slidable.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/dropdowns/border_dropdown.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_booking_list_tile.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
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
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

 class BuddyBookingRecordPage extends StatefulWidget {
  final UserModel? userModel;
  final FetchPlayerBuddyUpResponse? response;
  final bool? shouldStartWithInvited  ;

  const BuddyBookingRecordPage({
    Key? key,
    required this.userModel,
    this.response,
    this.shouldStartWithInvited  ,
  }) : super(key: key);

  @override
  _BuddyBookingRecordPageState createState() => _BuddyBookingRecordPageState();
}

class _BuddyBookingRecordPageState extends State<BuddyBookingRecordPage> {
  int selectedIndex = 0;
  List<String> c = [
    "SCHEDULED",
    "INVITED",
    "HISTORY",
  ];
  List<String> level = [
    "Grassroots",
    "Semi Pro",
    "Professional",
    "Expert",
  ];
  String selectedLevel = "";

  UserModel? userModel;

  List<BuddyUpBookingDetails>? detailsList = [];

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if(widget.shouldStartWithInvited ?? false) selectedIndex = 1 ;
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
            FindBuddyPage(
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
              FindBuddyPage(
                userModel: widget.userModel,
              ),
            );
            return false;
          },
          context: context,
          color: white,
          textColor: Colors.black,
          rightIconWidget: InkWell(
            onTap: () {},
            child: filterIcon(color: red),
          ),
          body: buildBody(context),
          title: "Buddy Up - Bookings",
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
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
                        color: blue, borderRadius: BorderRadius.circular(16))
                    : BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: mediumText(
                    c[index],
                    size: 15,
                    color: selectedIndex == index ? white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        verticalSpace(height: 16),
        Visibility(
          visible: selectedIndex == 1,
          child: Row(
            children: [
              mediumText(
                "Block Invites From:",
                size: 17,
              ),
              Spacer(),
              Container(height: 32, child: CustomDropDown()),
            ],
          ),
        ),
        verticalSpace(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});

              await Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
              child: FutureBuilder<FetchPlayerBuddyUpResponse>(
                initialData: widget.response,
                future: fetchPlayerBuddyUpBooking(userModel!.getAuthToken()),
                builder: (context, snapshot) {
                  if (snapshot == null) {
                    return Container(
                        child: Center(
                      child: mediumText("Unable to load buddy up"),
                    ));
                  } else {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    } else {
                      var r = snapshot.data!;
                      if (r.status!) {
                        detailsList = r.details;
                      } else {
                        return Container(
                          child: Center(
                            child: boldText(
                              "Unbale to fetch bookings....Check your internet connection and try again",
                            ),
                          ),
                        );
                      }
                      return selectedIndex == 0
                          ? scheduledList(context, detailsList!)
                          : selectedIndex == 1
                              ? invitedList(context, detailsList!)
                              : historyList(context, detailsList!);
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget scheduledList(BuildContext context, List<BuddyUpBookingDetails> dl) {
    List<BuddyUpBookingDetails> l = [];
    for (BuddyUpBookingDetails item in dl) {
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
                ),
              ),
              verticalSpace(),
              boldText("You do not have anything scheduled"),
              // Spacer(),
            ],
          )
        : Column(
            children: List.generate(
              l.length,
              (index) {
                BuddyUpBookingDetails b = l[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () => startVirtualSession(context, b, myId),
                    child: buildCard(
                      Expanded(
                        child: ScheduledChallengeBookingsListTile(
                          myId: myId,
                          onDelete: () => deleteSentInvitation(context, b),
                          onComment: () => pushRoute(
                            context,
                            ChatPage(
                              player1Details: myId == b.player1Id
                                  ? b.player1User
                                  : b.player2User,
                              player2Details: myId != b.player1Id
                                  ? b.player1User
                                  : b.player2User,
                              channelName: generateChatRoomName(
                                chatType: "buddy_up",
                                player1OrCoach1d: b.player1Id,
                                player2Id: b.player2Id,
                                bookingId: b.id,
                              ),
                            ),
                          ),
                          onEdit: () async {
                            await pushRoute(
                              context,
                              EditBuddyUpBookingPage(
                                userModel: userModel,
                                buddyUpBookingDetails: b,
                              ),
                            );

                            setState(() {});
                          },
                          bookingDetails: b,
                        ),
                      ),
                      innerPadding: 0,
                    ),
                  ),
                );
              },
            ),
          );
  }

  startVirtualSession(BuildContext context, BuddyUpBookingDetails b, int? myId) async {
    var bookingTime =
        bookingTimeStringToDateTime(b.bookingDates!, "${b.startTime}");

    if (b.sessionmode == 0) {
      var r = await launchMap(lat: "${b.lat / 1.0}", long: "${b.lon / 1.0}");
      showSnack(context, r);
      return;
    }

    // var v = jsonDecode(b.bookingtime);
    // bool canStart = false;
    // for (var i in v) {
    //   canStart = !sessionCanStart(
    //     i['dates'],
    //     i['time'].toString().split(":").first,
    //   );
    //   if (canStart) {
    //     break;
    //   }
    // }

    if (bookingTime.isBefore(DateTime.now().subtract(Duration(minutes: 5)))) {
      showSnack(context, "Session can't start now");
      return;
    }

    var channelName = "buddyup_${b.id}_by_${b.player1User!.id}";
    await handleCameraAndMic();

    if (b.player1User!.id == myId) {
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

      GeneralResponse v = await startVirtualBuddyUp(userModel!.getAuthToken(),
          buddyUpId: "${b.id}", videoToken: token);

      if (v.status!) {
        await dialog.hide();
        pushRoute(
          context,
          VideoCallPage(
            eventType: buddyUpEvent,
            role: agora.ClientRoleType.clientRoleBroadcaster,
            token: token,
            userId: myId,
            channelName: channelName,
            endVirtualSession: () => endVirtualSession(b),
            audienceDetails: b.player2User,
            hostDetails: b.player1User,
            chatMessagePath: generateChatRoomName(
              chatType: "buddy_up",
              player1OrCoach1d: b.player1Id,
              player2Id: b.player2Id,
              bookingId: b.id,
            ),
            sessionStartTime: bookingTime,
          ),
        );
      }

      await dialog.hide();
    } else {
      var token = await (genrateVideoToken( userModel!.getAuthToken(), channelName: channelName)  ) ?? "";
      if (b.virtualstatus == eventStarted) {
        pushRoute(
          context,
          VideoCallPage(
            eventType: buddyUpEvent,
            role:agora.ClientRoleType.clientRoleBroadcaster,
            token: token,
            userId: myId,
            channelName: channelName,
            endVirtualSession: () {
              Navigator.pop(context);
              // pushRoute(
              //     context,
              //     SessionReviewPage(
              //       audienceDetails: b.player2User,
              //       hostDetails: b.player1User,
              //     ));
            },
            audienceDetails: b.player2User,
            hostDetails: b.player1User,
            chatMessagePath: '',
            sessionStartTime: bookingTime,
          ),
        );
      } else if (b.virtualstatus == eventCompleted) {
        showSnack(context, "Host has ended session");
      } else {
        showSnack(context, "Host not stated session");
      }
    }
  }

  endVirtualSession(BuddyUpBookingDetails b) async {
    print("End session.....");
    // GeneralResponse v = await
    endVirtualBuddyUp(
      userModel!.getAuthToken(),
      buddyUpId: "${b.id}",
    );
    Navigator.pop(context);

    // pushRoute(
    //     context,
    //     SessionReviewPage(
    //       audienceDetails: b.player2User,
    //       hostDetails: b.player1User,
    //     ));
  }

  Widget invitedList(BuildContext context, List<BuddyUpBookingDetails> dl) {
    List<BuddyUpBookingDetails> l = [];
    for (BuddyUpBookingDetails item in dl) {
      if (item.status == "pending") {
        l.add(item);
      }
    }

    List<BuddyUpBookingDetails> sent = [];
    List<BuddyUpBookingDetails> recv = [];

    var myId = userModel!.getUserDetails()!.id;
    for (BuddyUpBookingDetails item in l) {
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
                      ),
                      mediumText("No invitations recieved."),
                    ],
                  ),
                ),
              )
            : Column(
                children: List.generate(
                  recv.length,
                  (index) {
                    BuddyUpBookingDetails b = recv[index];
                    var p2 = b.player1User!;
                    return InkWell(
                      onTap: () {
                        // pushRoute(context, ChallengeMAtchUpPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: buildCard(
                            Expanded(
                              child: ChallengeBookingsListTile(
                                points: "${b.player1Profile != null ? calculatePlayerPoints2(b.player1Profile!) : 0}",
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
                            innerPadding: 0),
                      ),
                    );
                  },
                ),
              ),
        verticalSpace(),
        mediumText("Your sent invitations"),
        buildDivider(),
        sent.isEmpty
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.send_outlined,
                        size: 64,
                      ),
                      mediumText("No Invitations Sent."),
                    ],
                  ),
                ),
              )
            : Column(
                children: List.generate(
                  sent.length,
                  (index) {
                    BuddyUpBookingDetails b = sent[index];
                    var p2 = b.player2User!;
                    return InkWell(
                      onTap: () {
                        // pushRoute(context, ChallengeMAtchUpPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: buildCard(
                            Expanded(
                              child: ChallengeBookingsListTile(
                                onDelete: () => deleteSentInvitation(context, b),
                                points: "${b.player1Profile != null ? calculatePlayerPoints2(b.player1Profile!) : 0}",
                                imgUrl: photoUrl + p2.profilePic!,
                                name: p2.name,
                                expLevel: "${getSportLevel(p2)}",
                                dateText:  b.displayDate,
                                locationText: b.location,
                              ),
                            ),
                            innerPadding: 0),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget historyList(BuildContext context, List<BuddyUpBookingDetails> dl) {
    // print("total recieved.....${dl.length}");
    List<BuddyUpBookingDetails> l = [];
    for (BuddyUpBookingDetails item in dl) {
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
                ),
              ),
              verticalSpace(),
              boldText("Booking History is empty."),
              // Spacer(),
            ],
          )
        : Column(
            children: List.generate(
              l.length,
              (index) {
                BuddyUpBookingDetails b = l[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: buildCard(
                    Expanded(
                      child: ScheduledlListTile(
                        b: b,
                        myId: myId,
                      ),
                    ),
                    innerPadding: 0,
                  ),
                );
              },
            ),
          );
  }

  acceptInvitation(BuildContext context, BuddyUpBookingDetails b) async {
    GeneralResponse g = await approveBuddyUpBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }

  declineInvitation(BuildContext context, BuddyUpBookingDetails b) async {
    GeneralResponse g = await declineBuddyUpBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }

  deleteSentInvitation(BuildContext context, BuddyUpBookingDetails b) async {
    GeneralResponse g = await deleteSentBuddyUpBooking(
      userModel!.getAuthToken(),
      bookingid: b.id,
    );

    showSnack(context, "${g.message}");

    setState(() {});
  }
}
