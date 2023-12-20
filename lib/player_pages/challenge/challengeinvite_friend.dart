import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/player_pages/challenge/find_challenge.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/textfield_with_card.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChallengeInviteFriendPage extends StatefulWidget {
  final UserModel? userModel;

  const ChallengeInviteFriendPage({Key? key, required this.userModel})
      : super(key: key);
  @override
  _ChallengeInviteFriendPageState createState() =>
      _ChallengeInviteFriendPageState();
}

class _ChallengeInviteFriendPageState extends State<ChallengeInviteFriendPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  bool canCheckContact = false;
  checkContactPermission() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      var c = await Permission.contacts.request();
      if (c == PermissionStatus.granted) {
        isGranted = true;
      }
    }

    if (isGranted) {
      // loadRegisteredOnContactList();
    }

    setState(() {
      canCheckContact = isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          body: canCheckContact
              ? buildBody(context)
              : Center(child: mediumText("Permisions needed", color: white)),
          context: context,
          color: deepBlue,
          textColor: white,
          rightIconWidget: filterIcon(),
          title: "Invite Friend",
        ),
      ),
    );
  }

  // Future<List<String>> filterContacts() async {
  //   Iterable<Contact> test =
  //       await ContactsService.getContacts(withThumbnails: false);
  //   var contactPhone = test.map((e) {
  //     var r = e.phones.toList();
  //     String phone = "";
  //     for (var i = 0; i < r.length; i++) {
  //       var item = r[i].value.replaceAll("-", "").replaceAll(" ", "");

  //       phone += i + 1 < r.length ? "$item," : "$item";
  //     }
  //     return phone;
  //   }).toList();

  //   // print("total:$contactPhone");
  //   return contactPhone;
  // }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Stack(
        children: <Widget>[
          buildCardedTextField(hintText: "Search your friend"),
          Padding(
            padding: EdgeInsets.only(top: 64),
            child: FutureBuilder<Iterable<Contact>>(
                future: ContactsService.getContacts(withThumbnails: false),
                builder: (context, snapshot) {
                  if (snapshot == null) {
                    return Center(
                      child: mediumText("Unable to load contact"),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return Center(
                        child: mediumText("Unable to load contact"),
                      );
                    } else {
                      List<Contact> cList = snapshot.data!.toList();
                      return ListView(
                        children: <Widget>[
                          buildContactTileTop(),
                          Wrap(
                            children: List.generate(cList.length, (index) {
                              var c = cList[index];
                              return buildContactTile(
                                  name: c.displayName,
                                  phoneNo: c.phones?.first.value ??
                                      "Error number");
                            }),
                          ),
                          verticalSpace(height: 16),
                          proceedButton(
                            text: "Invite Now",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget buildContactTile({
    String? name: "Christine Smith",
    String phoneNo: "+44 1829 122 92",
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "$name",
                    style: TextStyle(
                      fontSize: 12,
                      color: white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "$phoneNo",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                height: 32,
                width: 32,
                child: Visibility(
                    visible: false, child: Icon(Icons.check, color: blue)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  // color: blue,
                  border: Border.all(color: white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactTileTop() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Christine Smith",
                    style: TextStyle(
                      fontSize: 12,
                      color: white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "+44 1829 122 92",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
                ],
              ),
              Image.asset(
                "assets/check2.png",
                color: white,
                scale: 1.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
