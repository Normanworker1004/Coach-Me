import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_notification_response.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/notifications.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../auth_scope_model/ui_provider.dart';

class NotificationPage extends StatefulWidget {
  final UserModel? userModel;

  const NotificationPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var isOn = false;
  UserModel? userModel;

  List<NotificationDetails>? nList = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Jiffy.locale("en");
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        body: buildBody(context),
        context: context,
        title: "Notifications",
        rightIconWidget: filterIcon(color: deepRed),
      ),
    );
  }

  deleteNotifications(BuildContext context, List<int?> l) async {
    var r = await clearNotifications(
      token: userModel!.getAuthToken()!,
      idList: l,
    );

    showSnack(context, r.message);
    var u = context.read<UIProvider>();
    await u.setRefreshNotifications();
    setState(() {});
  }

  Widget buildList(BuildContext context, AsyncSnapshot<FetchNotificationResponse> snapshot) {
    if (snapshot == null) {
      return Container(
        child: Center(
          child: mediumText("Unable to fetch notifications"),
        ),
      );
    } else {
      if (snapshot.data == null) {
        return Container(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      } else {
        var d = snapshot.data!;
        if (d.status!) {
          nList = d.details;
        }
        var todayDate = DateTime.now().subtract(Duration(days: 1));
        List<NotificationDetails> todayList = [];
        var tempList = nList!.toList();
        nList!.clear();
        for (var i in tempList) {
          var d = stringToDateTime(i.createdAt!);
          if (d.isAfter(todayDate)) {
            todayList.insert(0, i);
            nList!.remove(i);
          } else {
            nList!.insert(0, i);
          }
        }
        return Column(
          children: [
            Visibility(
              visible: todayList.isNotEmpty,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      boldText("Today"),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          var l = List.generate(
                              todayList.length, (index) => todayList[index].id);
                          deleteNotifications(context, l);
                        },
                        child: lightText(
                          "Clear",
                          color: Color.fromRGBO(182, 9, 27, 1),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: List.generate(
                      todayList.length,
                      (index) {
                        var i = todayList[index];
                        var t = Jiffy(i.createdAt).fromNow();
                        return buildNotification(
                             context:context,
                            id: i.id,
                            imgUrl: i.pics,
                            time: "$t",
                            title: i.message);
                      },
                    )),
                  ),
                ],
              ),
            ),
            verticalSpace(),
            Visibility(
              visible: nList!.isNotEmpty,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      boldText("Earlier"),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          var l = List.generate(
                              nList!.length, (index) => nList![index].id);
                          deleteNotifications(context, l);
                        },
                        child: lightText(
                          "Clear",
                          color: Color.fromRGBO(182, 9, 27, 1),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: List.generate(
                      nList!.length,
                      (index) {
                        var i = nList![index]; //nList.length - index-1];
                        print("...$i");
                        var t = Jiffy(i.createdAt).fromNow();

                        return buildNotification(
                            context: context,
                            id: i.id,
                            imgUrl: i.pics,
                            time: "$t",
                            title: i.message);
                      },
                    )),
                  ),
                ],
              ),
            ),
            verticalSpace(),
          ],
        );
      }
    }
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder<FetchNotificationResponse>(
        future: fetchNotificationsData(token: userModel!.getAuthToken()!),
        builder: (context, snapshot) {
          return ListView(children: [
            buildPush(),
            verticalSpace(height: 24),
            buildList(context, snapshot),
          ]);
        });
  }

  Widget buildNotification({
    required BuildContext context,
    required String? imgUrl,
    required String? title,
    required String time,
    required int? id,
  }) {
    return Column(
      children: <Widget>[
        Dismissible(
          key: UniqueKey(),
          onDismissed: (c) {
            deleteNotifications(context, [id]);
          },
          child: buildCard(
            Expanded(
              child: Row(
                children: <Widget>[
                  "$imgUrl".isNotEmpty
                      ? CircularNetworkImage(
                          imageUrl: "${photoUrl + imgUrl!}", size: 45)
                      : Image.asset(
                          "assets/bookmark.png",
                          width: 36,
                          // color: Color.fromRGBO(25, 87, 234, 1),
                        ),
                  horizontalSpace(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        lightText("$title", size: 14, maxLines: 3),
                        lightText(
                          "$time",
                          size: 14,
                          color: blue,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        verticalSpace(height: 16),
      ],
    );
  }

  buildPush() {
    return buildCard(Expanded(
        child: Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/bell.png",
              width: 23,
              height: 25,
            )),
        horizontalSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Push Notifications",
                style: TextStyle(
                    fontFamily: App.font_name,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              lightText(
                "Set up notifications",
                size: 13,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        horizontalSpace(),
        FutureBuilder<bool>(
            future: getNotif(),
            builder: (context, snapshot) {
              return CupertinoSwitch(
                  value: snapshot.data ?? true,
                  activeColor: blue,
                  onChanged: (c) async {
                    isOn = c;
                    await saveNotif(c);
                    setState(() {});
                  });
            })
      ],
    )));
  }
}
