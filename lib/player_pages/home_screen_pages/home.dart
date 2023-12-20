import 'package:cme/account_pages/subscriptions_page.dart';
import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/homescreen.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/fetch_player_home_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/account_pages/notifications_page.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/buddy_up.dart';
import 'package:cme/network/player/challenge.dart';
import 'package:cme/network/player/fetch_home.dart';
import 'package:cme/player_pages/book_coach/find_coach_page.dart';
import 'package:cme/player_pages/buddy_up/buddyup_edit_booking_page.dart';
import 'package:cme/player_pages/buddy_up/find_buddy_page.dart';
import 'package:cme/player_pages/challenge/challenge_edit_booking.dart';
import 'package:cme/player_pages/challenge/find_challenge.dart';
import 'package:cme/player_pages/home_screen_pages/bookings.dart';
import 'package:cme/player_pages/home_screen_pages/hours_of_training_graph_data.dart';

import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/player_list_tiles.dart';
import 'package:cme/ui_widgets/sport_icon_function.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_bottom_dialog.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:provider/provider.dart';

import '../../account_pages/edit_profile.dart';
import '../../app.dart';
import '../../model/fetch_notification_count_response.dart';
import '../../network/notifications.dart';
import '../../utils/custom_tooltip.dart';
import '../buddy_up/buddy_bookings_record.dart';
import '../challenge/challenge_bookings_record.dart';

class HomeSection extends StatefulWidget {
  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  List<BNBItem> bnbItemsList = [
    BNBItem("Home", Icons.home),
    BNBItem("Bookings", Icons.access_time),
    BNBItem("Stats", Icons.network_cell),
    BNBItem("Account", Icons.person_outline),
  ];

  List<BNBItem> topActionItemList = [];

  UserModel? userModel;

  List<PlayerHomeBookingDetails>? bookingDetails = [];
  List<PlayerHomeBookingDetails>? scheduledSessions = [];
  int? countNotifications = 0 ;
  PlayerStatisticsItem? hourOfTrainingData;

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  // CurrentSubManager currentSubManager;
  Future<void> permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.contacts,
      Permission.calendar,
      // Permission.p,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    updateSubScripTionStatus();
  }

  updateSubScripTionStatus() async {
    var u = context.read<UIProvider>();
    await u.setIsSubScribed();
  }

  @override
  Widget build(BuildContext context) {
     print("Build home section");
    print("am i in infinite loop ? ");
    return
      ScopedModelDescendant<UserModel>(
       builder: (co, wi, model) {
        userModel = model;
        topActionItemList = [
          BNBItem(
            "Buddy Up ",
            "assets/users.png",
            page: FindBuddyPage(
              userModel: userModel,
            ),
            height: 34.0,
            width: 30.0,
            free:false,
            explain:"Train with players at different levels"
          ),
          BNBItem(
            "Challenge",
            "assets/target.png",
            page: ChallengeSearchPage(
              userModel: userModel,
              showAnimation: true,
            ),
            height: 30.0,
            width: 30.0,
            explain: "Challenge other players with your own skill games"
          ),
          BNBItem(
            "My Fixtures",
            "assets/list.png",
            page:"fixtures", // AddStatsDataPage(userModel: userModel!, ),
            // page: LeaderBoardPage(
            //   userModel: userModel,
            // ),
            height: 29.0,
            width: 30.0,
            free:true,
          ),
          // BNBItem(
          //   "My Fixtures",
          //   "assets/list.png",
          //   page:AddStatsDataPage(userModel: userModel!, ),
          //   // page: LeaderBoardPage(
          //   //   userModel: userModel,
          //   // ),
          //   height: 29.0,
          //   width: 30.0,
          //   free:true,
           // ),

          // BNBItem(
          //   "League Table",
          //   "assets/list.png",
          //   page: LeaderBoardPage(
          //     userModel: userModel,
          //   ),
          //   height: 29.0,
          //   width: 30.0,
          //   free:true,
          //    explain:"See where you rank against other players"
          // ),
        ];
      //  print("TYPE USER ::: ${userModel.getUserDetails().usertype}");
       //topActionItemList.add(value)

        if("${userModel!.getUserDetails()!.usertype}"  == "coach"){
          topActionItemList.add(
              BNBItem(
                "Coach App",
                "assets/papp.png",
                page: CoachHomeScreen(),
                height: 30.0,
                width: 40.0,
                free: true
          ));
        }

        print("Before calling future FetchPlayerHomeBookingResponse");
        return Scaffold(
          key: _key,
          body: ListView(
            children: <Widget>[
              buildTop(),
              FutureBuilder<FetchPlayerHomeBookingResponse>(
                initialData:   userModel!.getPlayerHome(),
                future: fetchPlayerHomeBooking(userModel!.getAuthToken()),
                builder: (context, snapshot) {
                  print("test fetch home booking resp");

                  if (snapshot.data != null) {
                    var s = snapshot.data;
                    if (s?.status ?? false) {
                      bookingDetails = s!.details;
                      scheduledSessions = s.details?.where((element) => (element.data?.status == "accepted"
                          || element.data?.status == "bootcamp") &&
                          (element.data!.startDateTime?.millisecondsSinceEpoch ?? 0) >
                              DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch).toList();
                      hourOfTrainingData = s.statsData?.first;
                      print("aaaaaa ${bookingDetails?.length}");

                      userModel!.setPlayerHome(s);
                    } else {
                      bookingDetails = [];
                      scheduledSessions = [];
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     buildYourProgress(context),
                     buildScheduleSection(context),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildYourProgress(BuildContext context) {
    int completed = 0;
    var tempList = bookingDetails!.toList();
    for (var item in tempList) {
      if ("${item.data!.status}" == "completed") {
        completed += 1;
        // bookingDetails!.remove(item);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Your Progress",
            style: Style.sectionTitleTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: () {
                var u = context.read<UIProvider>();
                u.setCurrentScrenIndex(2);
              },
              child:
              OverlayTooltipItem(
                tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                displayIndex: 1,
                tooltip: (controller) =>
                    MTooltip(
                        title: 'Your progress',
                        subTitle: "Set your performance targets and monitor your progress",
                        controller: OverlayTooltipScaffold.of(context)!.controller),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildProgressSection(
                      "Booking Sessions Completed".toUpperCase(),
                      "$completed out of ${tempList.length}",
                      Center(
                        child: CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 8.0,
                          percent: (completed / tempList.length).toDouble(),
                          progressColor: Colors.white,
                          backgroundColor: Colors.grey[300]!.withOpacity(.7),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var u = context.read<UIProvider>();
                        u.setCurrentScrenIndex(2,subIndex: 1);
                      },
                      child: buildProgressSection(
                        "Hours of training".toUpperCase()+"${(hourOfTrainingData?.goal?.length ?? 0) == 0 ? "\nSet your goals":""}",
                        "$completed Hours ",
                        Container(
                          padding: EdgeInsets.all(4),
                          child: LineChart(
                            sampleData1(
                              hourOfTrainingData ??
                                  PlayerStatisticsItem(playerstatistics: []),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScheduleSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 100, top: 20),
      child:

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Scheduled Sessions",
            style: Style.sectionTitleTextStyle,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: scheduledSessions!.isEmpty
                ? [
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
                                      'Book your first Coach & me Session!!',
                                      size: 14,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    verticalSpace(),
                    Column(
                      children: List.generate(
                        scheduledSessions!.length,
                        (index) {
                          PlayerHomeBookingDetails bDetails = scheduledSessions![index];
                          Data? bData = bDetails.data;

                          Userdetails userDetails =
                              userModel!.getUserDetails()!; //bData.player1Details;
                          var myId = userModel!.getUserDetails()!.id;

                          // print("${bDetails.bookingtype}...$index");
                          String expLevel = "${getCoachSportLevel(userDetails)}";

                          switch (bDetails.bookingtype) {
                            case "bootcamp":
                              {
                                // print("bootcamp....");
                                BootCampDetails bd = bData!.bootCampDetails!;
                                userDetails = bData.coachinfo!;
                                expLevel = "${getCoachSportLevel(userDetails)}";
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: InkWell(
                                    onTap: (){
                                      print("booking....");
                                      var u = context.read<UIProvider>();
                                      u.setCurrentScrenIndex(1);
                                    },
                                    child: buildCard(
                                        Expanded(
                                          child: PlayerBookingsListTile(
                                            bookingTypeImgUrl: "assets/tent.png",
                                            imgUrl:
                                                "${photoUrl + userDetails.profilePic!}",
                                            dateText:
                                                "${toDateNormal(bd.bootCampDate)}",
                                            locationText: "${bd.location}",
                                            name: "${userDetails.name}",
                                            experienceLevel: "$expLevel",
                                            onDelete: () =>
                                                showDeleteDialogue(context),
                                            onEdit: null,
                                            onComment: (c) => Navigator.push(
                                                context,
                                                NavigatePageRoute(
                                                  context,
                                                  ChatPage(
                                                    player1Details:
                                                        userModel!.getUserDetails(),
                                                    player2Details: userDetails,
                                                    channelName:
                                                        'home_message_${bData.id}__',
                                                    isHost: false,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        innerPadding: 0),
                                  ),
                                );
                              }
                              break;
                            case "challenge":
                              {
                                // print("challenge....${bData.player2Details}");
                                if (myId != bData!.player1Id) {
                                  userDetails = bData.player1Details!;
                                } else {
                                  userDetails = bData.player2Details!;
                                }

                                expLevel = "${getSportLevel(userDetails)}";

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: InkWell(
                                    onTap: () {
                                      pushRoute(
                                          context,
                                          ChallengeBookingRecordPage(
                                            userModel: userModel,
                                            response: null,
                                          ));
                                    },
                                    child: buildCard(
                                        Expanded(
                                          child: PlayerBookingsListTile(
                                            bookingTypeImgUrl: "assets/target.png",

                                            imgUrl:
                                                "${photoUrl + userDetails.profilePic!}",
                                            dateText: bData
                                                .displayDate, //"${toDateNormal(bData.bookingDates)}",
                                            locationText: "${bData.location}",
                                            name: "${userDetails.name}",
                                            experienceLevel: "$expLevel",

                                            // imgUrl: ,
                                            onDelete: (c) async {
                                              GeneralResponse g =
                                                  await deleteChallengeBooking(
                                                userModel!.getAuthToken(),
                                                bookingid: bData.id,
                                              );

                                              showSnack(context, "${g.message}");

                                              setState(() {});
                                            },
                                            onEdit: (c) async {
                                              await pushRoute(
                                                context,
                                                ChallengeEditBookingEditorPage(
                                                  userModel: userModel,
                                                  bookingDetails:
                                                      ChallengeBookingDetails(
                                                    player1Details:
                                                        bData.player1Details,
                                                    player2Details:
                                                        bData.player2Details,
                                                    player1Profile:
                                                        bData.player1Profile,
                                                    player2Profile:
                                                        bData.player2Profile,
                                                    bookingDates: bData.bookingDates,
                                                    bookingtime: bData.bookingtime,
                                                    location: bData.location,
                                                    lon: bData.lon,
                                                    sessionmode: bData.sessionmode,
                                                    startTime: bData.startTime,
                                                    lat: bData.lat,
                                                    id: bData.id,
                                                  ),
                                                ),
                                              );

                                              setState(() {});
                                            },
                                            onComment: (c) => Navigator.push(
                                              context,
                                              NavigatePageRoute(
                                                context,
                                                ChatPage(
                                                  isChallenge: true,
                                                  player1Details:
                                                      userModel!.getUserDetails(),
                                                  player2Details: userDetails,
                                                  channelName: generateChatRoomName(
                                                    chatType: "challenge",
                                                    player1OrCoach1d: bData.player1Id,
                                                    player2Id: bData.player2Id,
                                                    bookingId: bData.id,
                                                  ),
                                                  isHost: false,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        innerPadding: 0),
                                  ),
                                );
                              }

                              break;
                            case "buddyup":
                              {
                                // print("buddyup.....${bData.player2Details}");
                                if (myId != bData!.player1Id) {
                                  userDetails = bData.player1Details!;
                                } else {
                                  userDetails = bData.player2Details!;
                                }
                                expLevel = "${getSportLevel(userDetails)}";

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: InkWell(
                                    onTap: () {
                                      pushRoute(
                                        context,
                                        BuddyBookingRecordPage(
                                          userModel: userModel,
                                          response: null,
                                        ),
                                      );
                                    },
                                    child: buildCard(
                                        Expanded(
                                          child: PlayerBookingsListTile(
                                            bookingTypeImgUrl: "assets/users.png",

                                            imgUrl:
                                                "${photoUrl + userDetails.profilePic!}",
                                            dateText: bData
                                                .displayDate, //"${toDateNormal(bData.bookingDates)}",
                                            locationText: "${bData.location}",
                                            name: "${userDetails.name}",
                                            experienceLevel: "$expLevel",

                                            // imgUrl: ,
                                            onDelete: (c) async {
                                              GeneralResponse g =
                                                  await deleteSentBuddyUpBooking(
                                                userModel!.getAuthToken(),
                                                bookingid: bData.id,
                                              );

                                              showSnack(context, "${g.message}");

                                              setState(() {});
                                            },
                                            onEdit: (c) async {
                                              await pushRoute(
                                                context,
                                                EditBuddyUpBookingPage(
                                                  userModel: userModel,
                                                  buddyUpBookingDetails:
                                                      BuddyUpBookingDetails(
                                                    player1User: bData.player1Details,
                                                    player2User: bData.player2Details,
                                                    player1Profile:
                                                        bData.player1Profile,
                                                    player2Profile:
                                                        bData.player2Profile,
                                                    bookingDates: bData.bookingDates,
                                                    bookingtime: bData.bookingtime,
                                                    location: bData.location,
                                                    lon: bData.lon,
                                                    sessionmode: bData.sessionmode,
                                                    startTime: bData.startTime,
                                                    lat: bData.lat,
                                                    id: bData.id,
                                                  ),
                                                ),
                                              );

                                              setState(() {});
                                            },
                                            onComment: (c) => Navigator.push(
                                                context,
                                                NavigatePageRoute(
                                                  context,
                                                  ChatPage(
                                                    player1Details:
                                                        userModel!.getUserDetails(),
                                                    player2Details: userDetails,
                                                    channelName: generateChatRoomName(
                                                      chatType: "buddy_up",
                                                      player1OrCoach1d:
                                                          bData.player1Id,
                                                      player2Id: bData.player2Id,
                                                      bookingId: bData.id,
                                                    ),
                                                    isHost: false,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        innerPadding: 0),
                                  ),
                                );
                              }
                              break;
                            case "booking":
                              {
                                // print("booking....");
                                userDetails = bData!.coachinfo!;
                                expLevel = "${getCoachSportLevel(userDetails)}";

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: buildCard(
                                      Expanded(
                                        child: PlayerBookingsListTile(
                                          bookingTypeImgUrl:
                                              "${getSportIcon(bData.sport)}",
                                          imgUrl:
                                              "${photoUrl + userDetails.profilePic!}",
                                          dateText: bData
                                              .displayDate, //"${toDateNormal(bData.bookingDates)}",
                                          locationText: "${bData.location}",
                                          name: "${userDetails.name}",
                                          experienceLevel: "$expLevel",

                                          // imgUrl: ,
                                          onDelete: (c) =>
                                              showDeleteDialogue(context),
                                          onEdit: null, //() => showNotes(context),
                                          onComment: (c) => Navigator.push(
                                            context,
                                            NavigatePageRoute(
                                              context,
                                              ChatPage(
                                                player1Details:
                                                    userModel!.getUserDetails(),
                                                player2Details: userDetails,
                                                channelName: generateChatRoomName(
                                                  chatType: "booking",
                                                  player1OrCoach1d: bData.coachId,
                                                  player2Id: bData.userid,
                                                  bookingId: bData.id,
                                                ),
                                                isHost: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      innerPadding: 0),
                                );
                              }
                              break;
                            default:
                              {
                                // print("default....");
                                userDetails = bData!.coachinfo!;
                                expLevel = "${getCoachSportLevel(userDetails)}";
                              }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: buildCard(
                                Expanded(
                                  child: PlayerBookingsListTile(
                                    bookingTypeImgUrl: "assets/boot_icon.png",

                                    imgUrl: "${photoUrl + userDetails.profilePic!}",
                                    dateText: "${toDateNormal(bData.bookingDates)}",
                                    locationText: "${bData.location}",
                                    name: "${userDetails.name}",
                                    experienceLevel: "$expLevel",

                                    // imgUrl: ,
                                    onDelete: (c) => showDeleteDialogue(context),
                                    onEdit: null, //() => showNotes(context),
                                    onComment: (c) => Navigator.push(
                                        context,
                                        NavigatePageRoute(
                                          context,
                                          ChatPage(
                                            player1Details:
                                                userModel!.getUserDetails(),
                                            player2Details: userDetails,
                                            channelName:
                                                'home_message_${bData.id}__',
                                            isHost: false,
                                          ),
                                        )),
                                  ),
                                ),
                                innerPadding: 0),
                          );
                        },
                      ),
                    ),
              Visibility(
                visible: (scheduledSessions?.length??1) < 2,
                child: InkWell(
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
                                  'Book your next session',
                                  size: 14,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                  ],
          ),
        ],
      ),
    );
  }

  Widget buildProgressSection(topText, bottomText, midWidget) {
    return Container(
      height: (MediaQuery.of(context).size.width * .4)+30,//166,
      decoration: BoxDecoration(
        color: Color.fromRGBO(182, 9, 27, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      width: MediaQuery.of(context).size.width * .43,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            topText,
            style: TextStyle(
                fontSize: 14,
                fontFamily: App.font_name,
                color: white,
                fontWeight: FontWeight.bold),
          ),
          Expanded(child: midWidget),
          Text(
            bottomText,
            style: TextStyle(
              fontSize: 16,
              fontFamily: App.font_name2,
              color: white,
            ),
          )
        ],
      ),
    );
  }

  Widget buildTop() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
          image: AssetImage("assets/ball.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(9, 28, 74, 1).withOpacity(.7),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ), //rgba(9, 28, 74, 1)
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: (){
                  pushRoute(
                      context,
                      EditProfilePage(
                        userModel: userModel,
                      ));
                },
                child: Row(
                  children: <Widget>[
                    CircularNetworkImage(
                      imageUrl:
                          "${photoUrl + userModel!.getUserDetails()!.profilePic!}",
                      size: 45,
                    ),
                    horizontalSpace(width: 4),
                    Text(
                      "Hi ${userModel!.getUserDetails()!.name}",
                      style: Style.appBarTextStyle,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        pushRoute(
                            context,
                            NotificationPage(
                              userModel: userModel,
                            ));
                      },
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("assets/notification_bell.png",
                                    width: 22, height: 29),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child:
                              Consumer<UIProvider>(
                                builder: (c, provider, i) {
                                return FutureBuilder<FetchNotificationsCountResponse>(
                                  initialData:  FetchNotificationsCountResponse(status: true, message: "",count: 0),
                                  future: fetchCountNotifications(token:userModel!.getAuthToken()??""),
                                  builder: (context, snapshot) {

                                    if (snapshot.data != null) {

                                      var s = snapshot.data;
                                      if (s?.status ?? false) {
                                        countNotifications = s!.count;
                                        print("NotificationCOUNT :: ${s.count}");
                                      } else {
                                        countNotifications  = 0 ;
                                      }
                                    }
                                    return  Visibility(
                                      visible: (countNotifications ?? 0 ) >0,
                                      child: CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.red,
                                        child: Center(
                                          child: Text(
                                            "${countNotifications??0}",
                                            style: Style.notificationTextStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),

                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              verticalSpace(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    FocusNode().requestFocus();
                    pushRoute(
                      context,
                      FindCoachPage(
                        userModel: userModel,
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(0),
                    // shape: StadiumBorder(),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        // alignLabelWithHint: true,
                        hintText: "Book a coach",
                        hintStyle: Style.hintTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpace(height: 7),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<UIProvider>(
                  builder: (c, provider, i) {
                    bool isSub = provider.isSubScribed();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          topActionItemList.length,
                          (index) {

                            var theChild =
                            InkWell(
                              onTap: () async {
                                if (isSub || topActionItemList[index].free == true) {

                                  if(topActionItemList[index].page == "fixtures") {
                                    var u = context.read<UIProvider>();
                                    u.setCurrentScrenIndex(2, subIndex: 2);
                                  }else{
                                    pushRoute( context, topActionItemList[index].page);
                                  }


                                } else {
                                  await showBottomDialogue(
                                      context: context,
                                      child: SubscriptionPage());
                                  updateSubScripTionStatus();
                                }
                                setState(() {});
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    topActionItemList[index].icon,
                                    height: topActionItemList[index].height,
                                    width: topActionItemList[index].width,
                                    color: (isSub ||
                                        topActionItemList[index].free == true)
                                        ? Colors.white
                                        : Color.fromRGBO(81, 114, 175, 1),
                                  ),
                                  verticalSpace(height: 4),
                                  mediumText(
                                    topActionItemList[index].title,
                                    size: 12,
                                    color: (isSub ||
                                        topActionItemList[index].free == true)
                                        ? Colors.white
                                        : Color.fromRGBO(81, 114, 175, 1),

                                    /*index == 0
                                        ? Color.fromRGBO(81, 114, 175, 1)
                                        : Colors.white,*/
                                  ),
                                ],
                              ),
                            );
                            if(topActionItemList[index].explain != ""){
                              return OverlayTooltipItem(
                                  tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                                  tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
                                  displayIndex: 2+index,
                                  tooltip: (controller) =>
                                  MTooltip(
                                      title: topActionItemList[index].title,
                                      subTitle: "${topActionItemList[index].explain} ${(topActionItemList[index].free == true) ?"":"(Paid version only)"}",
                                      controller: OverlayTooltipScaffold.of(context)!.controller),
                                  child:theChild );

                            }
                            return theChild;

                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  testaa(UserModel userModel)  {
    print(userModel.getUserDetails()!.name);

    //  Navigator.push(context, NavigatePageRoute(context, ChooseAvtar(
    //   userModel: userModel,
    // )));
  }
}
