import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach_booking_note_response.dart';
import 'package:cme/model/fetch_player_booking_resopnse.dart';
import 'package:cme/model/fetch_player_boot_camp_list.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/booking.dart';
import 'package:cme/network/video_call_token.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/player_pages/home_screen_pages/bookimgs_sub_pages/editor_page.dart';
import 'package:cme/player_pages/online_session/review_page.dart';
import 'package:cme/register/tandc.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/player_list_tiles.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/launch.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:cme/video_call/video_call_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../book_coach/find_coach_page.dart';

class BookingsSection extends StatefulWidget {
  final UserModel userModel;

  const BookingsSection({Key? key, required this.userModel}) : super(key: key);
  @override
  _BookingsSectionState createState() => _BookingsSectionState();
}

class _BookingsSectionState extends State<BookingsSection> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  UserModel? userModel;

  List<BookingDetails>? detailsList = [];
  List<BootCampDetails?> bootCampList = [];

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  Widget buildBootCampList(BuildContext context) {
    return FutureBuilder<FetchPlayerBootCampListResponse>(
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
                shrinkWrap: true,
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
                                lat: "${d.lat / 1.0}", long: "${d.lon / 1.0}");
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
                                  // SlidableAction(
                                  //   onPressed: onEdit,
                                  //   backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                                  //   foregroundColor: Colors.black,
                                  //   label: 'Edit',
                                  //   // icon:
                                  //   // ImageIcon(
                                  //   //   AssetImage( "assets/edit_red.png")
                                  //   //  ),
                                  // ),
                                  SlidableAction(
                                    onPressed: (context) {
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

                                  // SlidableAction(
                                  //   onPressed: onDelete,
                                  //   backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                                  //   foregroundColor: Colors.black,
                                  // //  label: 'Delete',
                                  //   icon:  Icon(Icons.delete).icon ,
                                  //
                                  //   // icon:
                                  //   // ImageIcon(
                                  //   //   AssetImage( "assets/trash.png")
                                  //   //  ),
                                  // ),
                                ],
                              ),
                              child: Padding(
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
                              ),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        hideBack: true,
        backgroundImage: "assets/bg1.png",
        backgroudOpacity: .79,
        bottomPadding: 32,
        textColor: white,
        rightIconWidget: filterIcon(),
        context: context,
        body: buildBody(context),
        title: "Bookings",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 48),
          child: FutureBuilder<FetchPlayerBookingResponse>(
              initialData: userModel!.getPlayerBookings(),
              future: fetchPlayerBooking(userModel!.getAuthToken()),
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
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    var r = snapshot.data!;
                    if (r.status!) {
                      detailsList = r.details;
                      userModel!.setPlayerBookings(r);
                    }
                     return
                      detailsList!.length == 0 ?
                      InkWell(
                        onTap: () {
                          pushRoute(
                            context,
                            FindCoachPage(
                              userModel: userModel,
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircularImage(
                                  imageUrl: 'assets/logo.png',
                                ),
                                horizontalSpace(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      boldText(
                                        'No bookings are currently scheduled.\nBook your next session ',
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                          :
                      ListView.builder(
                      shrinkWrap: true,
                      itemCount: detailsList!.length,
                      itemBuilder: (b, index) {
                        var d = detailsList![index];
                        var coach = d.coachinfo!;
                        var status = "";
                        if (d.status == "pending") {
                          status = "Awaiting Confirmation";
                        } else if (d.status == "accepted") {
                          if (d.virtualstatus != null) {
                            status = "${d.virtualstatus}";
                          } else {
                            status = "Booked";
                          }
                        } else if (d.status == "completed") {
                          status = "$eventCompleted";
                        }else if(d.status == "cancel"){
                          status = "Cancelled";
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              joinVirtualMeeting(context, d);
                            },
                            child: PlayerBookingsListTile(
                              experienceLevel: "${getCoachSportLevel(coach)}",
                              dateText: "${d.displayDate}",
                              locationText: "${d.location}",
                              name: "${d.coachinfo!.name}",
                              imgUrl: "${photoUrl + coach.profilePic!}",
                              status: status,
                              count: d.coachnote!.length,
                              onDelete: (c) => showDeleteDialogue(
                                context,
                                onDelete: () async {
                                  // Navigator.pop(context);
                                  await deleteCoachBooking("${d.id}");
                                  setState(() {});
                                },
                              ),
                              onEdit: (c) =>
                                  pushRoute(context, BookingEditorPage()),
                              onComment: (c) => Navigator.push(
                                  context,
                                  NavigatePageRoute(
                                    context,
                                    ChatPage(
                                      player1Details:
                                          userModel!.getUserDetails(),
                                      player2Details: d.coachinfo,
                                      channelName: generateChatRoomName(
                                        chatType: "booking",
                                        player1OrCoach1d: d.coachId,
                                        player2Id: d.userid,
                                        bookingId: d.id,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              }),
        ),
        buildBootCampList(context),
      ],
    );
  }

  deleteCoachBooking(id) async {
    Navigator.pop(context);
    var r = await //deleteBookingPlayer
        deleteBooking(userModel!.getAuthToken(), bookid: "$id");
    print(r.message);
    showSnack(context, r.message);
    setState(() {});
  }

  leaveVirtualSession(BookingDetails b) async {
    Navigator.pop(context);

    await pushRoute(
        context,
        PlayerBookingSessionReviewPage(
          userModel: userModel,
          coachId: b.coachId,
          bookingId: b.id,
        ));
    setState(() {});
  }

  joinVirtualMeeting(BuildContext context, BookingDetails b) async {
    // leaveVirtualSession(b);

    // return;
    var bookingTime = coachBookingTimeStringToDateTime(
      b.bookingDates!,
      b.bookingtime!.split(":").first,
    );

    if (b.sessionmode == 1) {
      var r = await launchMap(lat: "${b.lat / 1.0}", long: "${b.lon / 1.0}");
      showSnack(context, r);
      setState(() {});
      return;
    }
    var channelName = "booking_${b.id}_by_${b.coachId}";
    var token = await (genrateVideoToken( userModel!.getAuthToken(), channelName: channelName)  ) ?? "";

    if (b.virtualstatus == eventStarted) {
      await pushRoute(
        context,
        VideoCallPage(
          eventType: buddyUpEvent,
          role: agora.ClientRoleType.clientRoleBroadcaster,
          token: token, //changed for token user.
          userId: userModel!.getUserDetails()!.id,
          channelName: channelName,
          endVirtualSession: () => leaveVirtualSession(b),
          audienceDetails: userModel!.getUserDetails(),
          hostDetails: b.coachinfo,
          chatMessagePath: generateChatRoomName(
            chatType: "booking",
            player1OrCoach1d: b.coachId,
            player2Id: b.userid,
            bookingId: b.id,
          ),
          sessionStartTime: bookingTime,
        ),
      );
    } else if (b.virtualstatus == eventCompleted) {
      // showNotes(context, b.coachnote);
      showSnack(context, "Host has ended session\n\n\n\n\n\n");
    } else {
      showNotes(context, b.coachnote);
      showSnack(context, "Host not stated Session\n\n\n\n\n\n");
    }
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
                     //   Navigator.pop(context);
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

showNotes(context, List<Coachnote>? notes) {
  showDialog(
    context: context,
    builder: (c) => buildNotes(context, notes!),
  );
}

showDeleteDialogue(context, {onDelete}) {
  showDialog(
    context: context,
    builder: (c) => Center(
      child: Container(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            width: 343,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          RichText(
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
                                  text: "Are you sure you want to cancel the booking?"
                                    " Cancelling the session within 24hrs of the confirmed booked session"
                                      " will result in non refund and full payment to the coach",
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                pushRoute(context, TermsPage());
                              },
                              child:
                              mediumText(
                                "Open Term and conditions",
                                color: red,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(c);
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
                            // Navigator.pop(context);
                            onDelete();
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
            ),
          ),
        ),
      ),
    ),
  );
}
