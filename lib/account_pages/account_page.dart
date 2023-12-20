import 'package:cme/app.dart';
import 'package:cme/account_pages/c_me_points.dart';
import 'package:cme/account_pages/edit_profile.dart';
import 'package:cme/account_pages/faqs_page.dart';
import 'package:cme/account_pages/gift_card_page.dart';
import 'package:cme/account_pages/notifications_page.dart';
import 'package:cme/account_pages/payment_history_page.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/payment/payment_method.dart';
import 'package:cme/account_pages/refer_page.dart';
import 'package:cme/account_pages/security_page.dart';
import 'package:cme/account_pages/subscriptions_page.dart';
import 'package:cme/intro/splashscreen.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final UserModel userModel;

  const AccountPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late List<AccountItem> itemList;

  @override
  void initState() {
    super.initState();

    itemList = [
      AccountItem(
        "Profile & Account",
        "Edit your profile",
        "assets/a1.png",
        // MaterialIcons.person,
        EditProfilePage(
          userModel: widget.userModel,
        ),
        "",
      ),
      AccountItem(
        "Coach & Me Points",
        "View your earnt points",
        "assets/a4.png",
        // MaterialIcons.school,
        CMEPointsPage(
          userModel: widget.userModel,
        ),
        "",

      ),
      AccountItem(
        "Refer friends",
        "Get free membership",
        "assets/a5.png",
        // MaterialIcons.people,
        ReferPage(
          userModel: widget.userModel,),
        "",

      ),
      // AccountItem(
      //   "Payment Method",
      //   "Set or add your Payment Card",
      //   "assets/a6.png",
      //   // MaterialIcons.credit_card,
      //   PaymentMethod(),
      //   "",
      //
      // ),
      AccountItem(
        "Subscription",
        "Subscribe to unlock more features",
        "assets/a7.png",
        //  MaterialIcons.subscriptions,
        SubscriptionPage(),
        "",

      ),
      AccountItem(
        "Gift Card",
        "Send Gift cards to friend and family",
        "assets/a8.png",
        // MaterialIcons.attach_money,
        GiftCardPage(
          userModel: widget.userModel,
        ),
        "",

      ),
      AccountItem(
        "Payment History",
        "Set or add your Payment Card",
        "assets/a9.png",
        // MaterialIcons.payment,
        PaymentHistoryPage(),
        "",

      ),
      AccountItem(
        "Notifications",
        "Manage notifications",
        "assets/a10_.png",
        //   MaterialIcons.notifications,
        NotificationPage(
          userModel: widget.userModel,
        ),
        "",

      ),
      AccountItem(
        "Security",
        "Enable fingerprint & Face Unlock",
        "assets/a10.png",
        //  MaterialIcons.security,
        SecurityPage(),
        "",

      ),
      AccountItem(
        "FAQs",
        "Frequently Asked Questions",
        "assets/a11.png",
        //  MaterialIcons.question_answer,
        FAQsPage(),
        "",

      ),
      AccountItem(
        "Rate App",
        "if you like our app please rate it",
        "assets/a12.png",
        //    MaterialIcons.rate_review,
        null,
        "",

      ),
      AccountItem(
        "Logout",
        "",
        "",
        //    MaterialIcons.rate_review,
        null,
        "assets/logout.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        bottomPadding: 64,
        body: buildBody(context),
        hideBack: true,
        context: context,
        title: "Account");
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: List.generate(
            itemList.length,
            (index) => buildItem(context, itemList[index]),
          ),
        ),
        // verticalSpace(height: 16),
        // InkWell(
        //     onTap: () {
        //       showLogOutDialogue();
        //       // print("Log ut pressed....");
        //     },
        //     child: boldText("Log out", color: Color.fromRGBO(182, 9, 27, 1))),
        verticalSpace(height: 32),
      ],
    );
  }

  showLogOutDialogue(BuildContext context) async {
    await showCupertinoDialog<bool>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to logout of Coach&Me?",
            style: TextStyle(
              fontFamily: App.font_name,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(c, false);
              return ;
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: App.font_name,
                color: Color.fromRGBO(182, 9, 27, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(c, false);
              Navigator.pop(c, false);
              Navigator.pushReplacement(  context, NavigatePageRoute(context, GetStartedPage()));
            },
            child: Text(
              "Yes",
              style: TextStyle(
                fontFamily: App.font_name,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    // print("Log out value  $v");
  }

  Widget buildItem(BuildContext context, AccountItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          if(item.title == "Logout"){
            showLogOutDialogue(context);
            return;
          }

          if (item.page == null) {
            return;
          }
          pushRoute(context, item.page);
        },
        child: buildCard(Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: item.icon != "" ,
              child:
              Image.asset(
                item.icon,
                width: 32,
              ),

            ),
            horizontalSpace(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  boldText(item.title, size: 14),
                  verticalSpace(height: 4),
                  lightText(item.subTitle, color: Colors.grey, size: 14)
                ],
              ),
            ),
            horizontalSpace(),

            item.iconRight == "" ?

            Icon(
               CupertinoIcons.forward  ,
              color: Colors.grey,
            )
                : ImageIcon(
              AssetImage(item.iconRight),
              color: Color.fromRGBO(182, 9, 27, 1),
            ),

          ],
        ))),
      ),
    );
  }
}

class AccountItem {
  final String title;
  final String subTitle;
  final String icon;
  final Widget? page;
  final String iconRight;

  AccountItem(
    this.title,
    this.subTitle,
    this.icon,
    this.page,
    this.iconRight,

      );
}
