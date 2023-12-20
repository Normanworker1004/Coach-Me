import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class App {
  static const font_name = "R-Flex";
  static const font_name2 = "ROBOTO";
  static const root = 'images/';
  static const assets = 'assets/';
  static const img_splash = '$root' + 'splash_screen.png';
  static const img_splash2 = '$assets' + 'pg1.png';
  static const onboarding_img = '$root' + 'img_onboarding2.png';
  static const ic_back = '$root' + 'ic_back.png';
  static const img_coach = '$root' + 'coach_img.png';
  static const img_player = '$root' + 'player_img.png';
  static const img_football_Sport = '$root' + 'sel_football_.png';
  static const img_level_sport = '$root' + 'level_img.png';
  static const img_age_over = '$root' + 'over16age.png';
  static const img_age_under = '$root' + 'under16age.png';
  static const img_upload_pic = '$root' + 'uploadPic.png';
  static const img_gender_nutral = '$root' + 'nutral_gender.png';
  //Avtar images.
  static const ic_funny_man = '$root' + 'avtar/funny-man.png';
  static const ic_women = '$root' + 'avtar/women.png';
  static const ic_women_pink = '$root' + 'avtar/women-ping.png';

  static const ic_man1 = '$root' + 'avtar/man1.png';
  static const ic_man2 = '$root' + 'avtar/man2.png';
  static const ic_man3 = '$root' + 'avtar/man3.png';

  static const onboarding_player = '$assets' + 'onboarding_player.jpg';
  static const onboarding_coach = '$assets' + 'onboarding_coach.jpg';

//asset images

}

String testToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA0NzQyMjEyLCJleHAiOjE2MDQ4Mjg2MTJ9.tywItfoHgsfuP_Ls5wXhofQ6RBkd3K82R7R3VfXZNIU";

String coachTestToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNjA0NzQxMzI3LCJleHAiOjE2MDQ4Mjc3Mjd9.kjdfK5QnTEfoW5V2fL4pXwgp-87nrwj11Ow8Pbyen0M";

Color starRatingColor = Color.fromRGBO(255, 193, 7, 1);
Color blue = Color.fromRGBO(25, 87, 234, 1);
Color red = Color.fromRGBO(182, 9, 27, 1);
Color bgGrey = Color.fromRGBO(245, 245, 245, 1); //(0xFFF5F5F5);
Color normalBlue = Color(0xFF1957EA);
Color deepBlue = Color(0xFF0A1B3B); //FF1957EA);
Color white = Color(0xFFFFFFFF);
Color deepRed = Color(0xffB6091B);
Color black = Color(0x00000000);

Color colorHomeBg = Color(0x00ffE1DAEB);
Color colorBg = Color(0x00ffF9F9F9);
Color colorBg1 = Color(0x00ffECE8F2);
Color colorTextHead = Color(0x00ff191B21);
Color colorBrown = Colors.brown;
Color colorTextPara = Color(0x00ff73777F);
Color colorSectionHead = Color(0xffB6091B);
Color colorDark = Color(0x00ff4E2A84);
Color colorOvalBorder2 = Color(0x00ff940BC7);
Color colorOvalBorder = Color(0x00ffECE8F2);
Color colorLightRound = Color(0x00ffECE8F2);
Color colorHover = Color(0x00ff8BC33C);
Color colorBlack = Color(0x00ff000000);
Color colorWhite = Color(0x00ffffffff);
Color colorSelectedItem = Color(0x00ffB6E8DC);
Color? colorSelectedMenu = Colors.green[300];
Color colorSubTextPera = Color(0x00ff878787);
Color colorDisable = Color(0x00ffC3C3C3);

Color colorInActiveProgress = Color(0x00ffE8E8E8);
Color colorActiveProgress = Color(0x00ff1957EA);
Color colorActiveBtn = Color(0xffB6091B);
Color themeBkg = Color(0xffFAFAFA);

Color mapPinBlue = Color.fromRGBO(25, 87, 234, 1);

//Text styles
abstract class Style {
  static const Color activeBNBColor = Colors.blue;
  static const Color inactiveBNBColor = Colors.black;

  static const TextStyle selectTimeTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16);
  static const TextStyle selectTimeTextStyle2 =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.blue);
  static const TextStyle bookingsAppBarTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.white,
  );
  static const TextStyle appBarTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle sectionTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);
  static const TextStyle titleTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15);
  static const TextStyle tilte2TitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    fontSize: 12,
  );
// static const TextStyle titleTitleTextStyle =
//       TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);

  static const TextStyle topBarTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );
  static const TextStyle progressTextStyle = TextStyle(
    color: Colors.white,
    letterSpacing: 2,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Colors.grey,
  );
  static const TextStyle notificationTextStyle =
      TextStyle(color: Colors.white, fontSize: 10);

  // static const Color activeBNBColor = Colors.blue;
}

Widget verticalSpace({double height = 8}) {
  return SizedBox(
    height: height,
  );
}

Widget horizontalSpace({double width = 8}) {
  return SizedBox(
    width: width,
  );
}

alert(context, String text) {
  return Alert(
    context: context,
    type: AlertType.error,
    title: "Coach & Me ALERT",
    desc: "$text",
    // buttons: [
    //   DialogButton(
    //     child: Text(
    //       text,
    //       style: TextStyle(color: Colors.white, fontSize: 20),
    //     ),
    //     onPressed: () => Navigator.pop(context),
    //     width: 120,
    //   )
    // ],
  ).show();
}

toast(String msg, {length: Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: length,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0);
}

enum Period { WEEKLY, MONTHLY, YEARLY }
