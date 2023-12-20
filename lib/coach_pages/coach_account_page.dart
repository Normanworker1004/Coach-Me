import 'package:cme/account_pages/acc_select_sport.dart';
import 'package:cme/app.dart';
import 'package:cme/account_pages/c_me_points.dart';
import 'package:cme/account_pages/earning_page.dart';
import 'package:cme/account_pages/edit_profile.dart';
import 'package:cme/account_pages/faqs_page.dart';
import 'package:cme/account_pages/feedback_page.dart';
import 'package:cme/account_pages/free_session.dart';
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

class CoachAccountPage extends StatefulWidget {
  final UserModel? userModel;

  const CoachAccountPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _CoachAccountPageState createState() => _CoachAccountPageState();
}

class _CoachAccountPageState extends State<CoachAccountPage> {
  late List<AccountItem> itemList;

  @override
  void initState() {
    super.initState();

    itemList = [
      AccountItem(
        "Profile & Account",
        "Edit your profile",
        "assets/a1.png",
        EditProfilePage(
          userModel: widget.userModel,
        ),
      ),
      AccountItem(
        "Sports",
        "Select Your Sport",
        "assets/a2.png",
        AcctSelectSport(
          userModel: widget.userModel,
        ),
      ),
      AccountItem(
        "Earnings",
        "Game Points",
        "assets/a3.png",
        EarningPage(),
      ),
      AccountItem(
        "Coach & Me Points",
        "Game Points",
        "assets/a4.png",
        CMEPointsPage(
          userModel: widget.userModel,
        ),
      ),
      AccountItem(
        "Refer friends",
        "Get free membership",
        "assets/a5.png",
        ReferPage(userModel: widget.userModel!),
      ),
      // AccountItem(
      //   "Payment Method",
      //   "set or add your payment card",
      //   "assets/a6.png",
      //   PaymentMethod(),
      // ),
      AccountItem(
        "Subscription",
        "Subscribe to unlock more features",
        "assets/a7.png",
        SubscriptionPage(),
      ),
      AccountItem(
        "Free Session",
        "Invite contacts for free taster session",
        "assets/a8.png",
        FreeSessionPage(),
      ),
      AccountItem(
        "Payment History",
        "Set or add your Payment Card",
        "assets/a9.png",
        PaymentHistoryPage(),
      ),
      // AccountItem(
      //   "Notifications",
      //   "View and set push notifications",
      //   "assets/moon.png",
      //   //   MaterialIcons.notifications,
      // NotificationPage(),
      // ),
      AccountItem(
        "Security",
        "Enable fingerprint & Face Unlock",
        "assets/a10.png",
        //  MaterialIcons.security,
        SecurityPage(),
      ),
      AccountItem(
        "FAQs",
        "Frequently Asked Questions",
        "assets/a11.png",
        //  MaterialIcons.question_answer,
        FAQsPage(),
      ),
      AccountItem(
        "Feedback",
        "Love to hear your feedback",
        "assets/a12.png",
        //    MaterialIcons.rate_review,
        FeedBackPage(),
      ),
      AccountItem(
        "Rate App",
        "if you like our app please rate it",
        "assets/a12.png",
        //    MaterialIcons.rate_review,
        null,
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
            (index) => buildItem(itemList[index]),
          ),
        ),
        verticalSpace(height: 16),
        InkWell(
            onTap: () {
              showLogOutDialogue();
            },
            child: boldText("Log out", color: Color.fromRGBO(182, 9, 27, 1))),
        verticalSpace(height: 32),
      ],
    );
  }

  showLogOutDialogue() {
    showCupertinoDialog(
      context: this.context,
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
              Navigator.pop(context);
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
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, NavigatePageRoute(c, GetStartedPage()));
            },
            child: Text(
              "Yes",
              style: TextStyle(
                fontFamily: App.font_name,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(AccountItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          if (item.page == null) {
            return;
          }
          pushRoute(context, item.page);
        },
        child: buildCard(Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              item.icon,
              width: 32,
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
            Icon(
              CupertinoIcons.forward,
              color: Colors.grey,
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

  AccountItem(
    this.title,
    this.subTitle,
    this.icon,
    this.page,
  );
}
