import 'package:cme/account_pages/subscriptions_page.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/ui_provider.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/homescreen.dart';
import 'package:cme/model/bio_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/find_user_by_phone_response.dart';
import 'package:cme/model/login_response.dart';
import 'package:cme/model/previous_user.dart';
import 'package:cme/network/auth.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/intro/onboarding.dart';
import 'package:cme/register/reset_password.dart';
import 'package:cme/subscription/subfunctions.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/register_widgets/input.dart';
import 'package:cme/ui_widgets/register_widgets/password_input.dart';
import 'package:cme/ui_widgets/register_widgets/phone_number_input.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../controllers/location_controller.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showComplete = false;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passeordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  late UserModel userModel;

  TextEditingController phoneController = TextEditingController();
  String countryCode = "";
   @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
     var myScaffoldCOntext  = context;
     return ScopedModelDescendant<UserModel>(
      builder: (co, widget, model) {
        userModel = model;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: App.font_name2),
          home: Scaffold(
            key: _scaffoldKey,
            backgroundColor: themeBkg,

            body: Builder(
              builder: (context) {
                myScaffoldCOntext = context;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Image.asset("assets/logo2.png"),
                          Center(
                              child: boldText("Make it happen!",
                                  color: deepRed, size: 32)),
                          verticalSpace(height: 32),
                          Center(
                            child: Text(
                              "Please sign in to continue",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: App.font_name,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          verticalSpace(height: 24),

                          buildRegisterInputField(
                              controller: nameController,
                              topLabel: "Username\\Email Address"),

                          CustomPasswordField(controller: passeordController),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: InkWell(
                              onTap: () {
                                forgetPasswordDialogue(context);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          verticalSpace(),
                          registerButton(myScaffoldCOntext),
                          verticalSpace(),
                          // buildLocalAuthWidget(),
                          // verticalSpace(),
                          InkWell(
                            onTap: () {
                              pushRoute(context, Onboarding());
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "Need an Account? "),
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                      color: deepRed,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: App.font_name,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),

                              //  "Please sign in to continue",
                            ),
                          ),
                          verticalSpace(height: 32),
                          // Center(
                          //   child: InkWell(
                          //       onTap: () {
                          //         pushRoute(context, FingerPrintPage());
                          //       },
                          //       child: lightText("Unlock with Fingerprint/Face ID",
                          //           size: 16)),
                          // )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Visibility(
                          visible: showComplete,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showComplete = false;
                              });
                            },
                            child: Container(
                              color: Colors.transparent.withOpacity(.8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: buildCompleteCard(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                );
              }
            ),
          ),
        );
      },
    );
  }

  void forgetPasswordDialogue(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        context: context,
        // isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (BuildContext bc) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .6 + MediaQuery.of(context).viewInsets.bottom
            ,
            child: Container(
              padding: const EdgeInsets.only(left:16.0, right: 16.0),
              child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Container(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child:Container(
                    child: ForgetPaswordBody(
                      onProceed: () {
                        Navigator.pop(context);
                        setState(() {
                          showComplete = true;
                        });
                      },
                      onFailed: () {
                        Navigator.pop(context);

                        showSnack(context, "Update Password failed");
                      },
                    ),

                    // forgotPassWord(),
                   ),
                  ),
                ),
              ),
             ),
            ),

          );
        });
  }

  Widget buildCompleteCard() {
    return Container(
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(34)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset("assets/pw2.png"),
            verticalSpace(),
            Text(
              "Your password has been reset successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: App.font_name,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
            verticalSpace(height: 16),
            Text(
              "Your password has been reset successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: App.font_name,
              ),
            ),
            verticalSpace(),
            proceedButton(
                text: "Close",
                onPressed: () {
                  // Navigator.pop(context);

                  setState(() {
                    showComplete = false;
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget forgotPassWord() {
    return Column(
      children: [
        verticalSpace(height: 16),
        Center(
            child: Container(
            height: 3,
            width: 72,
            decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1), //rgba(238, 238, 238, 1)
                borderRadius: BorderRadius.circular(4)),
        )),
        verticalSpace(height: 16),
        Image.asset("assets/pw1.png"),
        verticalSpace(),
        boldText("Forgot password?", size: 24),
        verticalSpace(),
        Text(
          "Please enter your phone number\n"
          "You will recieve a code to create a new password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: App.font_name,
            fontSize: 16,
          ),
        ),
        verticalSpace(),
        phoneNumberInput(
            (String p, String internationalizedPhoneNumber, String isoCode) {
          //TODO("SET UP PHONE NUMBER IN FORGET PASSWORD")
          // setState(() {
          //   countryCode = isoCode;
          //   phoneController = TextEditingController(
          //       text: internationalizedPhoneNumber);
          // });
          // print("number: ${phoneController.text}");
        }),
        verticalSpace(height: 16),
        proceedButton(
            text: "Submit",
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                showComplete = true;
              });
            })
      ],
    );
  }


  Container registerButton(BuildContext context) {
    return Container(
        child: TextButton(
      onPressed: () {
        logInSetup(context);
      },
          style:TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),


      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          decoration: BoxDecoration(
              color: normalBlue,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: normalBlue, width: 1.1)),
          child: Container(
            constraints: BoxConstraints(minHeight: 60.0),
            alignment: Alignment.center,
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Log in",
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
    ));
  }

  void logInSetup(BuildContext context) async {

    if (nameController.text.trim().isEmpty) {
      showSnack(context, "Enter username or email address");
      return;
    }
    if (passeordController.text.trim().isEmpty) {
      showSnack(context, "Enter Password");
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    LogInResponse r = await loginUser(
      username: nameController.text.trim(),
      password: passeordController.text.trim(),
    );
    if (r.accessToken != null) {
      Get.find<LocationController>().updatePosition();
      userModel.clearStorage();
      userModel.setAuthToken(r.accessToken);
      userModel.setUserDetails(r.userDetails);
      userModel.setUserProfileDetails(r.userDetails!.profile);


      clearAccount();
      saveAccount(PreviousUser(
        userName: nameController.text.trim(),
        password: passeordController.text.trim(),
      ));
      var u = context.read<UIProvider>();
      await u.setIsSubScribed();


      var currentSubManager = await getOldPurchases();
      if (userModel.getUserDetails()!.usertype == "player") {
        pushRoute(context, HomeScreen());
      } else if (userModel.getUserDetails()!.usertype == "coach") {
        loadCacheData();

        if (currentSubManager.isCoachAdvActive ||
            currentSubManager.isCoachBasicActive) {
          pushRoute(context, CoachHomeScreen());
        } else {
          pushRoute(context, SubscriptionPage());
        }
      }
    } else {
      showSnack(context, r.reason);
    }
    setState(() {
      isLoading = false;
    });
  }

  loadCacheData() async {
    print("Data stored temporato.....");
    CoachBookingResponse pendingBooking =
        await fetchBoking(userModel.getAuthToken(), status: "pending");
    CoachBookingResponse acceptedBooking =
        await fetchBoking(userModel.getAuthToken(), status: "accepted");
    CoachBookingResponse historyBooking =
        await fetchBoking(userModel.getAuthToken(), status: "completed");
    if (pendingBooking.status!) {
      userModel.setCoachBookingCount(pendingBooking.details!.length);
      userModel
          .setCoachBookings([pendingBooking, acceptedBooking, historyBooking]);
    }
    print("booking done....");
    // UserProfile u = await showProfile(userModel.getAuthToken());
    // if (u.status) {
    //   userModel.setUserProfileDetails(u.message.profiledetails);
    // }
    print("profile done....");

    BioResponse bio = await fetchBio(userModel.getAuthToken());
    if (bio.status!) {
      userModel.setCoachBio(bio);
    }
    print(userModel.getAuthToken());
  }
}

class ForgetPaswordBody extends StatefulWidget {
  // final phoneNumInput;
  final onProceed;
  final onFailed;

  const ForgetPaswordBody({
    Key? key,
    // @required this.phoneNumInput,
    required this.onProceed,
    required this.onFailed,
  }) : super(key: key);
  @override
  _ForgetPaswordBodyState createState() => _ForgetPaswordBodyState();
}

class _ForgetPaswordBodyState extends State<ForgetPaswordBody> {
  bool showComplete = false;
  bool isLoading = false;
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: App.font_name2),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpace(height: 16),
              Center(
                  child: Container(
                height: 3,
                width: 72,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        238, 238, 238, 1), //rgba(238, 238, 238, 1)
                    borderRadius: BorderRadius.circular(4)),
              )),
              verticalSpace(height: 16),
              Image.asset("assets/pw1.png"),
              verticalSpace(),
              boldText("Forgot password?", size: 24),
              verticalSpace(),
              Text(
                "Please enter your phone number\n"
                "You will receive a link to create a new password via sms",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: App.font_name,
                  fontSize: 16,
                ),
              ),
              verticalSpace(),
              phoneNumberInput(
                // widget.phoneNumInput
                (String p, String internationalizedPhoneNumber,
                    String isoCode) {
                  //TODO("SET UP PHONE NUMBER IN FORGET PASSWORD")
                   setState(() {
                    // print("phone....$internationalizedPhoneNumber");
                    // countryCode = isoCode;
                    phoneController = TextEditingController(
                        text: internationalizedPhoneNumber);
                  });
                  print("number: ${phoneController.text}");
                },
              ),
              verticalSpace(height: 16),
              proceedButton(
                text: "Submit",
                isLoading: isLoading,
                onPressed: phoneController.text.isEmpty
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        FindUserByPhoneResponse r = await findUserByPhone(  phoneNo: phoneController.text);
                        if (r.status!) {
                         var user = r.userDetails;
                          var userModell = new UserModel(); 
                          userModell.setUserDetails(user);
                          this.userModel = userModell;
                          verifyPhoneNumber();

                          // final password = "${UniqueKey()}${UniqueKey()}";
                          // FindUserByPhoneResponse up = await resetPassword(
                          //   newPassWord:"resetedpasswordVal1234@", // password.substring(0, 7),// "resetedpasswordVal1234@"
                          //   userId: "${user.id}",
                          // );
                          //
                          // //
                          // //TODO("Verify phone number Firebase")
                          //
                          //
                          //
                          // if (up.status) {
                          //   widget.onProceed();
                          // } else {
                          //   widget.onFailed();
                          // }



                        } else {
                          widget.onFailed();
                        }
                        setState(() {
                          isLoading = true;
                        });
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
  var i;
  String verificationId = "";
  String otpCodeSent = "";
  String countryCode = "";
  String gcountryCode = "";

  UserModel? userModel;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  int totalSeconds = 119; //5minutes
  bool showResendOTP = false;
  void completeRegistration(){
    print("COMPLETE OTPPP");
    pushRoute(context, ResetPassword( userModel: userModel));
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
        builder: (BuildContext context) {
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
                              autofocus: true,
                              isCupertino: true,
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
                              confirmOtp();
                            },
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
                              verifyPhoneNumber();
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
  TextEditingController otpController = TextEditingController();
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

  Future<void> verifyPhoneNumber() async {
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
      //  showSnack(context, "Verification Successful.");
        completeRegistration();
      } else {
        // print("Verification failed.....");
    //    showSnack(context, "Phone verification failed");
      }
    };
    final PhoneVerificationFailed verifFailed = (FirebaseAuthException ex) {
      // print("failed: ${ex.message}");
      setState(() {
        isLoading = false;
      });
    //  showSnack(context, "Verification failed");
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

  Future<void> confirmOtp() async {
    // print("+++++confirm otp");
    final AuthCredential _authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text,
    );

    await FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .catchError((error) {
      // Navigator.pop(context);

      // print("Error");
     // showSnack(context, "OTP CODE ERROR");
    }).then((UserCredential authResult) {
      if (authResult.user != null) {
        // print('confirmOtp: Authentication successful');
        // goToNext();
        completeRegistration();
      } else {
       // showSnack(context, "Authentication failed");
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
