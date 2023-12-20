import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/controllers/location_controller.dart';
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
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../ui_widgets/dropdowns/dropdown.dart';

class CreateNewAct extends StatefulWidget {
  final bool needGuardian;
  CreateNewAct({Key? key, this.needGuardian: false}) : super(key: key);

  @override
  _CreateNewActState createState() => _CreateNewActState();
}

class _CreateNewActState extends State<CreateNewAct> {
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
    LocationController locationController = Get.find<LocationController>();

    cc = LatLng(locationController.lat.value, locationController.lng.value);

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
                            child: Text("Create",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          Center(
                            child: Text("New Account",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                                // "Join the community of over one million \npeople",
                                "Join the Coach&Me community",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w100),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildRegisterInputField(
                              controller: fullNameController,
                              topLabel: "Firstname / Surname"),
                          Visibility(
                            visible: false, //isCoach,
                            child: buildRegisterInputField(
                              controller: userNameController,
                              topLabel: "Alias",
                            ),
                          ),
                          customDateInput(
                            value: dobController.text,
                            onConfirmed: (DateTime date) {
                              FocusScope.of(context).requestFocus(FocusNode());

                              bool over16 = isOver16(date);
                              bool under13 = !isOver13(date);

                              print("is over 16....$over16.....");

                              if (needGuardian) {
                                if (over16) {
                                  print("above...age");
                                  showSnack(
                                      context,
                                      // "Choose Age Below 18years",
                                      'You have entered a birth date above 16.\nPlease re-enter OR Please GO BACK and click \"I\'m over 13 years\"',
                                      seconds: 5);
                                  return;
                                }
                                if (under13) {
                                  print("above...age");
                                  showSnack(
                                      context,
                                      // "Choose Age Below 18years",
                                      'You have entered a birth date under 13.\nIn order to use Coach & Me, you will be require permission from your parent/guardian to complete the remaining account setup information',
                                      seconds: 10);
                                  return;
                                }
                              } else {
                                if (!over16) {
                                  print("below...age");
                                  showSnack(
                                      context,
                                      // "Choose Age Above 18years",
                                      'You have entered a birth date below 16.\nPlease re-enter OR Please GO BACK and click \"I\'m under 13 years\"',
                                      seconds: 5);
                                  return;
                                }
                              }
                              setState(() {
                                dobController.text =
                                    "${date.day}-${date.month}-${date.year}";
                              });
                            },
                            context: context,
                          ),
                          buildRegisterInputField(
                              controller: emailController,
                              topLabel: "Email Address"),
                          phoneNumberInput((String p,
                              String internationalizedPhoneNumber,
                              String isoCode) {
                            setState(() {
                              countryCode = isoCode;
                              phoneController = TextEditingController(
                                  text: internationalizedPhoneNumber);
                            });
                            print(
                                "number:...$internationalizedPhoneNumber... ${phoneController.text}$isoCode");
                          }),
                          CustomPasswordField(
                            controller: passwordController,
                          ),
                          CustomPasswordField(
                            controller: confrirmPasswordController,
                            labelText: "Re-enter Password",
                          ),
                          Visibility(
                            visible: needGuardian,
                            child: Column(
                              children: [
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
                                  child: Text(
                                    "If you're under 16, you need to add the details of your parent/guardian.",
                                     style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: App.font_name,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                buildRegisterInputField(
                                    controller: gfullNameController,
                                    topLabel: "Full Name"),
                                customDateInput(
                                  value: gdobController.text,
                                  onConfirmed: (DateTime date) {
                                    if (!isOver21(date)) {
                                      print("below...age");
                                      showSnack(
                                          context, "Choose Age Above 21 years");
                                      return;
                                    }
                                    setState(() {
                                      gdobController.text =
                                          "${date.day}-${date.month}-${date.year}";
                                    });
                                  },
                                  context: context,
                                ),
                                buildRegisterInputField(
                                    controller: gemailController,
                                    topLabel: "Email Address"),
                                phoneNumberInput((String p,
                                    String internationalizedPhoneNumber,
                                    String isoCode) {
                                  setState(() {
                                    gcountryCode = isoCode;
                                    gphoneController = TextEditingController(
                                        text: internationalizedPhoneNumber);
                                  });
                                  // print(
                                  //     "number:...$internationalizedPhoneNumber... ${gphoneController.text}$isoCode");
                                }),
                              ],
                            ),
                          ),

                          buildRegisterInputWidget(
                            topLabel: "How Did You Hear About Us",
                            childWidget:  Container(
                                width: double.infinity,
                                child: buildDropDownNoLabel(aboutUs  , aboutUsList, (e){ // ?? aboutUsList.first
                                  aboutUs = e;
                                  setState(() {
                                  });
                                }))  ,
                          ),

                           buildRegisterInputField(
                              controller: affiliateCodeController,
                              topLabel: "Affiliate Code"),
                          Container(
                              child: TextButton(
                            onPressed: isLoading
                                ? () {
                              showOTPDialogue(context);
                                  }
                                : () => //completeRegistration(),

                                    startCreateAccount(context),
                                style : TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
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
                                          "Register",
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
                          InkWell(
                            onTap: () {
                              pushRoute(context, TermsPage());
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                  fontFamily: App.font_name,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'By clicking Sign up you agree to our '),
                                  TextSpan(
                                      text: 'Terms\n',
                                      style: TextStyle(
                                          color: colorActiveProgress)),
                                  TextSpan(
                                      text: 'and Conditions ',
                                      style: TextStyle(
                                          color: colorActiveProgress)),
                                ],
                              ),
                            ),
                          ),
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

  void showOTPDialogue(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    otpController = TextEditingController();
    showModalBottomSheet(
        context: context,
        // isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (BuildContext bc) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: <Widget>[
                    verticalSpace(height: 16),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 238, 238, 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 78,
                        height: 3,
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                    ),
                    verticalSpace(height: 32),
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            // "We need to verify\nyour phone ",
                            "Verify your phone number",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: App.font_name,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        verticalSpace(),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        "We have sent you an SMS with a code to \nnumber "),
                                TextSpan(
                                  text: phoneController.text.trim(),
                                  style: TextStyle(
                                      fontFamily: App.font_name2,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: App.font_name,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                        ),
                        verticalSpace(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PinCodeTextField(
                              controller: otpController,
                              autofocus: false,
                              hideCharacter: false,
                              highlight: false,
                              // pinBoxHeight: 36,
                              pinBoxWidth:
                                  MediaQuery.of(context).size.width / 7.5,
                              highlightColor: Color.fromRGBO(226, 226, 226, 1),
                              defaultBorderColor:
                                  Color.fromRGBO(226, 226, 226, 1),
                              hasTextBorderColor:
                                  Color.fromRGBO(226, 226, 226, 1),
                              maxLength: 6,
                              pinTextStyle: TextStyle(
                                  fontFamily: "ROBOTO",
                                  fontSize: 30.0,
                                  color: colorActiveProgress),
                              pinBoxRadius: 14,
                            ),
                          ),
                        ),
                        verticalSpace(),
                        buildTimer(),
                        verticalSpace(),
                        Container(
                          child: TextButton(
                            onPressed: () {
                              // print("Verify phone number..........");

                              Navigator.pop(context);
                              confirmOtp(context);
                            },
                            style : TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
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
                                  child: Text(
                                    "Verify Number",
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
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              verifyPhoneNumber(context);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                  fontFamily: App.font_name,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Didn\'t receive the OTP?',
                                      style: TextStyle(color: colorBlack)),
                                  TextSpan(
                                      text: ' Resend',
                                      style: TextStyle(
                                          color: colorActiveBtn,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    print("verify phone number......");
    final PhoneCodeAutoRetrievalTimeout autoRetieve = (String verid) {
      verificationId = verid;
    };

    final PhoneCodeSent smsCodeSent = (String verid, [int? forceCodeResend]) {
      verificationId = verid;
      // print("code sent");

      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);

      showOTPDialogue(context);
    };

    final PhoneVerificationCompleted verifSuccess = (AuthCredential user) {
      if (user != null) {
        // print("Verification Successful.");
        showSnack(context, "Verification Successful.");
        completeRegistration(context);
      } else {
        // print("Verification failed.....");
        showSnack(context, "Phone verification failed");
      }
    };
    final PhoneVerificationFailed verifFailed = (FirebaseAuthException ex) {
      // print("failed: ${ex.message}");
      completeRegistration(context);

      setState(() {
        isLoading = false;
      });
      showSnack(context, "Verification failed");
      // pageController.jumpToPage(4);
    };

     await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verifSuccess,
        verificationFailed: verifFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetieve);
  }

  Future<void> confirmOtp(BuildContext context) async {
   print("+++++confirm otp");
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text,
    );

    await FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .catchError((error) {
      // Navigator.pop(context);

      // print("Error");
      showSnack(context, "OTP CODE ERROR");
    }).then((UserCredential authResult) {
      if (authResult.user != null) {
         print('confirmOtp: Authentication successful');
        // goToNext();
        completeRegistration(context);
      } else {
        showSnack(context, "Authentication failed");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  goToNext() async {
    if (!isCoach) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      NavigatePageRoute(
        context,
        widget.needGuardian
            ? ChooseAvtar(
                userModel: userModel,
              )
            : UploadProfilePic(),
      ),
    );
  }

  Widget buildTimer() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.secondTime,
      initialData: _stopWatchTimer.secondTime.value,
      builder: (context, snap) {
        final value = snap.data!;
        var remaining = totalSeconds - value;
        return StreamBuilder<int>(
            stream: _stopWatchTimer.minuteTime,
            initialData: _stopWatchTimer.minuteTime.value,
            builder: (context, snapshot) {
              // print("${snapshot.data}");
              var min = 1 - snapshot.data!;
              return Center(
                child: _stopWatchTimer.isRunning
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                            fontFamily: App.font_name,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${(remaining % 120)}',
                              style: TextStyle(
                                  fontFamily: "ROBOTO",
                                  fontWeight: FontWeight.bold,
                                  color: colorActiveBtn),
                            ),
                            TextSpan(
                              text: ' seconds',
                              style: TextStyle(
                                  fontFamily: App.font_name,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                            fontFamily: App.font_name,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: colorBlack)),
                            TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: colorActiveBtn,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
              );
            });
      },
    );
  }

  startCreateAccount(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (fullNameController.text.isEmpty) {
      showSnack(context, "Enter name");
      return;
    }

    // if (isCoach && userNameController.text.isEmpty) {
    //   showSnack(context, "Enter username");
    //   return;
    // }

    if (emailController.text.isEmpty) {
      showSnack(context, "Enter name");
      return;
    }

    if (phoneController.text.isEmpty) {
      showSnack(context, "Enter a valid Phone Number");
      return;
    }

    if (passwordController.text.isEmpty) {
      showSnack(context, "Enter Password");
      return;
    }

    if (dobController.text.isEmpty) {
      showSnack(context, "Enter DOB");
      return;
    }

    if (passwordController.text != confrirmPasswordController.text) {
      showSnack(context, "Passwords don't match");
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      var isV = await verifyEmail(
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );
      print("+++++$isV");
      if (isV != "Email and Phone number available") {
        showSnack(context, isV);
        setState(() {
          isLoading = false;
        });
        return;
      }
      verifyPhoneNumber(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void completeRegistration(BuildContext context) async {
     print("+complete....+++++");
    List<BNBItem> list = SignInDetals.sportExperience;
    List<int?> expLevel = [];
    List<String> sports = [];

    for (BNBItem item in list) {
      expLevel.add(item.title + 1);
      sports.add("${item.page}".toLowerCase());
    }

    UserClass r = await createAccount(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      ageGroup: widget.needGuardian ? "12-17" : "18+",
      countryId: countryCode,
      dob: dobController.text.trim(),
      phone: phoneController.text.trim(),
      referedBy: affiliateCodeController.text.trim(),
      experienceLevel: expLevel,
      sports: sports,
      type: i == 0 ? "player" : "coach",
      gender: "0",
      subscriptionId: "1",
      guardCountryId: gcountryCode,
      guardianDob: gdobController.text.trim(),
      guardianEmail: gemailController.text.trim(),
      guardianName: gfullNameController.text.trim(),
      guardianPhone: gphoneController.text.trim(),
      lat: cc == null ? "0.0" : "${cc!.latitude}",
      lon: cc == null ? "0.0" : "${cc!.longitude}",
      markerting: aboutUs,
    );

     print("++++++++${r.message}");
    if (r.message == "Registration successful") {
      // print("User typer registred${r.details.usertype}");
      userModel!.setUser(r);
      userModel!.setUserDetails(r.details);
      clearAccount();
      saveAccount(PreviousUser(
        userName: emailController.text.trim(),
        password: passwordController.text.trim(),
      ));

      await updatePhoneVerification(userModel!.getAuthToken());
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
