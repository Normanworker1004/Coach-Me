import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/bootcamp/bootcamp_page.dart';
import 'package:cme/coach_pages/coach_leaderboard.dart';
import 'package:cme/coach_pages/coach_bio/edit_bio.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/coach_session_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/account_pages/notifications_page.dart';
import 'package:cme/custom_chat/chat_page.dart';

import 'package:cme/player_pages/home_screen_pages/bookimgs_sub_pages/editor_page.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/subscription/sub_model.dart';
import 'package:cme/subscription/subfunctions.dart';

import 'package:cme/ui_widgets/bookings_list_tile_with_slidable.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/notificarion_bell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:scoped_model/scoped_model.dart';

class CoachHome extends StatefulWidget {
  @override
  _CoachHomeState createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  CoachSessionResponse? res;
  var m;

  late List<BNBItem> topActionItemList;

  UserModel? userModel;
  bool isBasic = true;

   isBasicSub() async{
    CurrentSubManager currentSubManager = await getOldPurchases();
    var isCoachBasicActive = currentSubManager.isCoachBasicActive;
    var isCoachAdvActive = currentSubManager.isCoachAdvActive;
    if(isCoachAdvActive  ) isCoachBasicActive = false;
    isBasic = isCoachBasicActive ;
    print("ISBASIIIIIC $isBasic");
   }
  @override
  void initState() {
    super.initState();
    isBasicSub();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
       //  print("USER MODEL ${userModel.getUserDetails().subscriptionId}");
        topActionItemList = [
          BNBItem(
            "Your Bio",
            "assets/bio.png",
            page: EditBioPage(
              userModel: userModel,
            ),
            height: 30.0,
            width: 23.0,
          ),
          BNBItem(
            "Boot Camp",
            "assets/boot.png",
            page: BootCampPage(),
            height: 30.0,
            width: 30.0,
            // basic: false
          ),
          BNBItem(
            "Leaderboard",
            "assets/league.png",
            page: CoachLeaderBoardPage(
              userModel: userModel,
            ),
            height: 29.0,
            width: 30.0,
          ),
          BNBItem(
            "Player App",
            "assets/papp.png",
            page: HomeScreen(),
            height: 30.0,
            width: 40.0,
          ),
        ];
        return ListView(
          children: <Widget>[
            buildTop(),
            FutureBuilder<CoachSessionResponse>(
              future: fetchSessions(userModel!.getAuthToken()!),
              builder: (context, snapshot) {
                if (snapshot == null) {
                  // return Center(child: Text("Unable to load schedule"));
                } else {
                  if (snapshot.data == null) {
                  } else {
                    res = snapshot.data;
                    m = res!.message;
                    // m.totalbooking;
                  }
                }
                return Column(
                  children: <Widget>[
                    buildScheduleCount(
                      total: m == null ? 0 : m.totalbooking,
                      completed: m == null ? 0 : m.booking.length,
                    ),
                    buildScheduleSection(m == null ? [] : m.booking)
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildScheduleCount({int total: 3, int completed: 2}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Bookings ",
                      style: TextStyle(
                        fontFamily: App.font_name,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      //Style.sectionTitleTextStyle,
                    ),
                    TextSpan(
                      text: "for today",
                      style: TextStyle(
                        fontFamily: App.font_name,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: App.font_name,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: "$completed",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " of ",
                        ),
                        TextSpan(
                          text: "$total",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " completed",
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Center(
            child: CircularPercentIndicator(
              radius: 69.0,
              lineWidth: 4.0,
              percent: completed / total,
              center: Text(
                "$completed",
                style: TextStyle(
                    color: Color.fromRGBO(182, 9, 28, 1),
                    fontSize: 32,
                    fontFamily: "ROBOTO"),
              ),
              progressColor: Color.fromRGBO(182, 9, 28, 1),
              backgroundColor: Color.fromRGBO(229, 229, 231, 1),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScheduleSection(List<Booking> list) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Upcoming Sessions",
              style: Style.sectionTitleTextStyle,
            ),
            verticalSpace(),
            Column(
              children: List.generate(
                list.length,
                (index) {
                  var b = list[index];
                  var coach = userModel!.getUserDetails();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: buildCard(
                      Expanded(
                        child: BookingsListTile(
                          booking: b,
                          onDelete: () => showDeleteDialogue(),
                          onEdit: () => Navigator.push(
                            context,
                            NavigatePageRoute(
                              context,
                              BookingEditorPage(),
                            ),
                          ),
                          onComment: () => Navigator.push(
                            context,
                            NavigatePageRoute(
                              context,
                              ChatPage(
                                player1Details: coach,
                                player2Details: b.user,
                                channelName:
                                    'booking_message_${b.id}_${coach!.id}_',
                                isHost: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      innerPadding: 0,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProgressSection(topText, bottomText, midWidget) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color.fromRGBO(182, 9, 27, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      width: MediaQuery.of(context).size.width * .4,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            topText,
            style: Style.progressTextStyle,
          ),
          Expanded(child: midWidget),
          Text(
            bottomText,
            style: Style.progressTextStyle,
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
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: Color.fromRGBO(9, 28, 74, 1).withOpacity(.7),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  userModel!.getUserDetails()!.profilePic == null
                      ? CircularImage(
                          size: 45,
                          imageUrl: "images/avtar/funny-man.png",
                        )
                      : CircularNetworkImage(
                          imageUrl:
                              "${userModel!.getUserDetails()!.profilePic!}",
                          size: 45,
                        ),
                  horizontalSpace(width: 4),
                  Text(
                    "Hi ${userModel!.getUserDetails()!.name}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      pushRoute(
                        context,
                        NotificationPage(
                          userModel: userModel,
                        ),
                      );
                    },
                    child: NotificationBell(),
                  )
                ],
              ),
            ),
            verticalSpace(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  topActionItemList.length,
                  (index) => Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () { //TODO DEBUG HERE JEREMY
                         //   pushRoute(context, AllowPermissionsPage());
                         //   return;
                            if (topActionItemList[index].page == null) {
                              return;
                            }
                            if(!(topActionItemList[index].basic ?? true ) && isBasic) return;
                            pushRoute(context, topActionItemList[index].page);
                          },
                          child:
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  topActionItemList[index].icon,
                                  height: topActionItemList[index].height,
                                  width: topActionItemList[index].width,
                                  color: !(!(topActionItemList[index].basic ?? true ) && isBasic)
                                      ? Colors.white
                                      : Color.fromRGBO(81, 114, 175, 1),
                                ),
                                verticalSpace(height: 9.9),
                                Text(
                                  topActionItemList[index].title,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color:  !(!(topActionItemList[index].basic ?? true ) && isBasic)
                                          ? Colors.white
                                          : Color.fromRGBO(81, 114, 175, 1)  ,

                                      fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          )

                          //CoachTopIcon(item:  topActionItemList[index]),
                        ),
                      )),
            ),
            verticalSpace(height: 32),
          ],
        ),
      ),
    );
  }

  showDeleteDialogue() {
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
            onPressed: () {
              Navigator.pop(context);
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
