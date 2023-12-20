import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/homescreen.dart';
import 'package:cme/controllers/location_controller.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

class AllowPermissionsPage extends StatefulWidget {
  @override
  _AllowPermissionsPageState createState() => _AllowPermissionsPageState();
}

class _AllowPermissionsPageState extends State<AllowPermissionsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  late UserModel userModel;
  late bool isCoach;

  updateData() async {
      l = [
        BNBItem(
          "Share your location",
          "assets/allow1.png",
          page: !isCoach? "We need this to put you in touch with local coaches":"We need this to put you in touch with local players and coaches",
          height: Permission.location,

        ),
        BNBItem(
          "Turn on notifications",
          "assets/allow2.png",
          page:
              "Stay up to date with alerts/bookings",
          height: Permission.notification,

        ),
        BNBItem(
          "Access phone contacts",
          "assets/allow3.png",
          page: "Allow phone contacts to share Coach & Me with your friends",
          height: Permission.contacts,

        ),
      ];

  }
  /* updateData() async {
    if (!isCoach) {
      l = [
        BNBItem(
          "Allow your location",
          "assets/allow1.png",
          page:
              "Allows you to find your coach more. Used for buddy and challenge modes features.",
          height: Permission.location,
        ),
        BNBItem(
          "Allow your notification",
          "assets/allow2.png",
          page:
              "Stay up to date with alerts. Chat with buddy messaging, bookings.",
          height: Permission.notification,
        ),
        BNBItem(
          "Allow your phone contacts",
          "assets/allow3.png",
          page: "Allow phone contacts used for buddy up.",
          height: Permission.contacts,
        ),
      ];
    } else {
      l = [
        BNBItem(
          "Allow your location",
          "assets/allow1.png",
          page:
              "Allow you to find your coach more.Used for buddy and challenge mode features.",
          height: Permission.location,
        ),
        BNBItem(
          "Allow your notification",
          "assets/allow2.png",
          page:
              "Stay up to date with alerts.\nChat with buddy messaging, booking",
          height: Permission.notification,
        ),
        BNBItem(
          "Allow your phone contacts",
          "assets/allow3.png",
          page: "Allow phone contacts used for buddy.",
          height: Permission.contacts,
        ),
      ];
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        isCoach = userModel.getUserDetails()!.usertype == "coach";
        updateData();
        return Scaffold(
          key: _key,
          body: buildBaseScaffold(
            context: context,
            body: buildBody(context),
            title: "Set Permissions",
            // title: "Allow Permissions",
          ),
        );
      },
    );
  }

  List<BNBItem> l = [];



  // var i;
  @override
  void initState() {
    super.initState();
   }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: List.generate(3, (index) {
            var i = l[index];
            Permission perm = i.height;
            return FutureBuilder<PermissionStatus>(
                future: perm.status,
                initialData: PermissionStatus.denied,
                builder: (context, snapshot) {
                  bool status = snapshot.data == PermissionStatus.granted;
                  return Column(
                    children: [
                      buildCard(
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  i.icon,
                                  width: 38,
                                  height: 50,
                                ),
                                horizontalSpace(),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    boldText(i.title, size: 14),
                                    lightText(i.page,
                                        maxLines: 10, color: Colors.grey),
                                  ],
                                )),
                                horizontalSpace(),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: CupertinoSwitch(
                                      value: status,
                                      activeColor: normalBlue,
                                      onChanged: (bool v) async {
                                        status = await requestPermssion(perm);
                                        setState(() {
                                          v = status;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          innerPadding: 0),
                      verticalSpace(height: 16),
                    ],
                  );
                });
          }),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: proceedButton(
              text: "Next",
              onPressed: () {
                // var i = Final.getId();
                updateData();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pop(context);
                if (!isCoach) {
                  pushRoute(context, HomeScreen());
                } else {
                  Navigator.pop(context);
                  pushRoute(context, CoachHomeScreen());
                }
              }),
        )
      ],
    );
  }

  Future<bool> requestPermssion(Permission perm) async {
    print("Requesting Perm${perm}");
     Map<Permission, PermissionStatus> statuses = await [
      perm,
    ].request();
     // await Permission.locationWhenInUse.request()
    print("Requesting Perm ${ statuses[perm]!.isGranted}");
    if(statuses[perm]!.isGranted){
      Get.find<LocationController>().updatePosition();
    }
    return statuses[perm]!.isGranted;
     setState(() {  });
  }
}
