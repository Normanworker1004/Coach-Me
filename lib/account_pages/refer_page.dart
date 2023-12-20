import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReferPage extends StatefulWidget {
  final UserModel userModel;

  const ReferPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _ReferPageState createState() => _ReferPageState();
}

class _ReferPageState extends State<ReferPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  var text = "";

  /// SHARE ON FACEBOOK CALL
  shareOnFacebook() async {
    try {
      await Share.share(text);
    } catch (e) {}
  }

  /// SHARE ON INSTAGRAM CALL
  shareOnInstagram() async {
    try {
      await Share.share(text);
    } catch (e) {}
  }

  /// SHARE ON WHATSAPP CALL
  shareWatsapp() async {
    await Share.share(text);
  }

  /// SHARE ON WHATSAPP CALL
  shareTwitter() async {
    try {
      await Share.share(text);
    } catch (e) {
      print("Twitter errir $e");
    }
  }

  late List<BNBItem> items;

  @override
  void initState() {
    super.initState();

    text =
        "Hi ${widget.userModel.getUserDetails()!.name} is inviting you to the worlds best Sports coaching app."
        " Great features including book a qualified coach, challenge your friends"
        " to skills games, buddy up (train with another player) and much more."
        " Sign up now to benefit from 1 months free subscription."
        "\nUse affiate code: ${widget.userModel.getUserDetails()!.affiliateCode}";
    items = [
      BNBItem("assets/fb.png", () => shareOnFacebook()),
      BNBItem("assets/wa.png", () => shareWatsapp()),
      BNBItem("assets/ig.png", () => shareOnInstagram()),
      BNBItem("assets/twitter.png", () => shareTwitter()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
          color: themeBkg,
          lrPadding: 0,
          context: context,
          body: buildBody(context),
          title: "Refer friends"),
    );
  }

  Widget buildBody(BuildContext context) {
    try {
      return ListView(
        children: <Widget>[
          Image.asset(
            "assets/refer.png",
            height: 100,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: Text(
              "Invite your friends, and for every 3 activated (Subscribed) friends we will give you 1 month free subscription.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          buildButtonsGrid(),
          verticalSpace(),
          Center(
            child: InkWell(
              onTap: () => shareOnFacebook(),
              child: mediumText(
                "Use your unique affiliate code:\n ${widget.userModel.getUserDetails()!.affiliateCode}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      return Container();
    }
  }

  buildButtonsGrid() {
    return GridView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(32.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1,
      ),
      children: List.generate(
        items.length,
        (index) {
          return InkWell(
            onTap: items[index].icon,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 8)
              ]),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset(items[index].title),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAppBar() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        Text(
          "Refer Friend",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
