import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/final.dart';
import 'package:cme/model/previous_user.dart';
import 'package:cme/model/user_class.dart';
import 'package:cme/network/auth.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/register/choose_avtar.dart';
import 'package:cme/register/tandc.dart';
import 'package:cme/register/upload_profile_pic.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/register_widgets/input.dart';
import 'package:cme/ui_widgets/register_widgets/password_input.dart';
import 'package:cme/ui_widgets/register_widgets/phone_number_input.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/date_input.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cme/app.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:email_validator/email_validator.dart';

import '../network/mail_gardian.dart';
import '../ui_widgets/dropdowns/dropdown.dart';

class NeedGardian extends StatefulWidget {
  final bool needGuardian;
  NeedGardian({Key? key, this.needGuardian: true}) : super(key: key);

  @override
  _NeedGardianState createState() => _NeedGardianState();
}

class _NeedGardianState extends State<NeedGardian> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController dobController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrirmPasswordController = TextEditingController();
  TextEditingController affiliateCodeController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  //Guardian info

  TextEditingController gfullNameController = TextEditingController();
  TextEditingController gemailController = TextEditingController();
  TextEditingController gphoneController = TextEditingController();
  TextEditingController gdobController = TextEditingController();

  var i;
  String verificationId = "";
  String otpCodeSent = "";
  String countryCode = "";
  String gcountryCode = "";
  String aboutUs = "Search Engine";
  bool isLoading = false;
  UserModel? userModel;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  int totalSeconds = 119; //5minutes

  bool showResendOTP = false;
  bool needGuardian = false;
  bool isCoach = false;
  List aboutUsList = [
    "Search Engine",
    "Google Ads",
    "Facebook Ads",
    "Youtube Ads",
    "Other paid social media advertising",
    "Facebook post/group",
    "Twitter post",
    "Instagram post/story",
    "Other social media",
    "Email",
    "Radio",
    "TV",
    "Newspaper",
    "Word of mouth",
  ];
  LatLng? cc;
  setLocation() async {
    var c = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    cc = LatLng(c.latitude, c.longitude);

    // print("lat: ${cc.latitude}  lon: ${cc.longitude}");
  }

  @override
  void initState() {
    super.initState();
    i = Final.getId();
    setLocation();

    isCoach = i == 1;
    _stopWatchTimer.secondTime.listen((value) {
      if (value == totalSeconds) {
        setState(() {
          showResendOTP = true;
        });
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        _stopWatchTimer.setPresetSecondTime(0);
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      } else {
        setState(() {
          showResendOTP = false;
        });
      }
    });

    needGuardian = widget.needGuardian;
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Scaffold(
                    key: _key,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: themeBkg,
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              i == 1 ? "Steps 4/7" : "Steps 5/10",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w100),
                            ),
                            StepProgressIndicator(
                              totalSteps: 10,
                              currentStep: 5,
                              size: 6.0,
                              padding: 0,
                              selectedColor: colorActiveProgress,
                              unselectedColor: colorInActiveProgress,
                              roundedEdges: Radius.circular(10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text("Need a",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          Center(
                            child: Text("Parent/Guardian",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Center(
                              child: Text(
                                  // "Join the community of over one million \npeople",
                                  "As you are under 13, you will require a Parent/Guardian to create their own login and book your coaching sessions for you.",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: App.font_name,
                                      fontWeight: FontWeight.w100),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),



                          Column(
                            children: [
                              buildRegisterInputField(
                                  controller: fullNameController,
                                  topLabel: "Your Full Name"),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 8, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Guardian information",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: App.font_name,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 8, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "Would you like us to send a text to your Parent/Guardian, if so please enter their e-mail and we will an invitation",
                                     style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: App.font_name,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              buildRegisterInputField(
                                  controller: gfullNameController,
                                  topLabel: "Full Name"),

                              buildRegisterInputField(
                                  controller: gemailController,
                                  topLabel: "Email Address"),
                              PhonePicker(
                                  onPhoneNumberChange: (String p,
                                  String internationalizedPhoneNumber,
                                  String isoCode) {
                                    setState(() {
                                      gcountryCode = isoCode;
                                      gphoneController = TextEditingController(
                                          text: internationalizedPhoneNumber);
                                    });
                              }),
                              // phoneNumberInput((String p,
                              //     String internationalizedPhoneNumber,
                              //     String isoCode) {
                              //   setState(() {
                              //     gcountryCode = isoCode;
                              //     gphoneController = TextEditingController(
                              //         text: internationalizedPhoneNumber);
                              //   });
                              //
                              // }),
                            ],
                          ),
                          Container(
                              child: TextButton(
                            onPressed: isLoading
                                ? () {}  : () =>  SendMessageGardian(context),

                                style:TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),

                             child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: colorActiveBtn,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: colorActiveBtn, width: 1.1)),
                                child: Container(
                                  constraints: BoxConstraints(minHeight: 60.0),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        )
                                      : Text(
                                          "Send",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily: App.font_name,
                                              fontWeight: FontWeight.w700),
                                        ),
                                ),
                              ),
                            ),
                          )),

                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: themeBkg,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: backArrow(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }




  goToNext() async {
    if (!isCoach) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    Navigator.popUntil(context,(Route<dynamic> route) => route.isFirst);
     // Navigator.push(
    //   context,
    //   NavigatePageRoute(
    //     context,
    //     widget.needGuardian
    //         ? ChooseAvtar(
    //             userModel: userModel,
    //           )
    //         : UploadProfilePic(),
    //   ),
    // );
  }



  void SendMessageGardian(BuildContext context) async {
    if (!EmailValidator.validate(gemailController.text.trim())) {      showSnack(context, "Email is invalid"); return; }
    if ((gfullNameController.text.trim().length ) < 3 ) {      showSnack(context, "Gardian name is invalid"); return; }
    if (gphoneController.text.isEmpty ) {      showSnack(context, "Phone number invalid"); return; }

      print("+complete....+++++");
      List<BNBItem> list = SignInDetals.sportExperience;
      List<int?> expLevel = [];
      List<String> sports = [];

      for (BNBItem item in list) {
        expLevel.add(item.title + 1);
        sports.add("${item.page}".toLowerCase());
      }

      UserClass r = await sendMailGardian(
        name: fullNameController.text.trim(),
        guardCountryId: gcountryCode,
        guardianEmail: gemailController.text.trim(),
        guardianName: gfullNameController.text.trim(),
        guardianPhone: gphoneController.text.trim(),
      );

      print("++++++++${r.message}");
      if (r.message == "Email Sent") {
        showSnack(context, r.message);
        goToNext();
      } else {
        showSnack(context, r.message);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

  }
}
