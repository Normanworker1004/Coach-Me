import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/homescreen.dart';
import 'package:cme/model/bio_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/previous_user.dart';
import 'package:cme/model/user_profile_class.dart';
import 'package:cme/network/auth.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/intro/onboarding.dart';
import 'package:cme/player_pages/homescreen.dart';
import 'package:cme/register/log_in_page.dart';
import 'package:cme/register/tandc.dart';
import 'package:cme/subscription/constants.dart';
import 'package:cme/ui_widgets/logo_widget.dart';
import 'package:cme/ui_widgets/stepper.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:purchases_flutter/purchases_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    Firebase.initializeApp();
    var _duration = Duration(seconds: 0);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Jiffy.locale("en");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (c) => GetStartedPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/cp1.jpg",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity),
          ),
          // Center(
          //   child: Container(
          //     height: double.infinity,
          //     width: double.infinity,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         buildWhiteLogo(),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.baseline,
          //           textBaseline: TextBaseline.alphabetic,
          //           children: [
          //             boldText("Let's make it happen!", color: red, size: 26),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  late UserModel userModel;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future initPurchases() async {
    await Purchases.setDebugLogsEnabled(true); // TODO (set to true for debug)
    await Purchases.setup(SubKeys.sdkKey);
  }

  bool useLocal = false;
  loadLocal() async {
    bool b = await getAllowLocal();
    setState(() {
      useLocal = b;
    });
  }

  Future<void> authenticateUser(BuildContext context, String? username, String? password) async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: "Authenticate to Sign in as $username",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      var r = await loginUser(
        username: username,
        password: password,
      );
      if (r.accessToken != null) {
        userModel.setAuthToken(r.accessToken);
        // print(userModel.getAuthToken());
        await loadCacheData();
        if (userModel.getUserDetails()!.usertype == "player") {
          pushRoute(context, HomeScreen());
        } else if (userModel.getUserDetails()!.usertype == "coach") {
          pushRoute(context, CoachHomeScreen());
        }
        return;
      } else {
        showSnack(context, r.reason);
        pushRoute(context, LogInPage());
      }
    } else {
      pushRoute(context, LogInPage());
    }
  }

  @override
  void initState() {
    super.initState();

    loadLocal();
    initPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              // Image.asset("assets/pg1.png",
              //     fit: BoxFit.cover,
              //     height: double.infinity,
              //     width: double.infinity),

              ImagesStepper(),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //       Colors.transparent.withOpacity(.1),
                      //       Colors.transparent.withOpacity(.3),
                      //       Colors.transparent.withOpacity(.6),
                      //       Colors.transparent.withOpacity(.9),
                      //     ]),
                    ),
                    // color: Colors.transparent.withOpacity(.6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        // direction: Axis.vertical,
                        children: [
                          // Image.asset("assets/log3.png"),
                          buildWhiteLogo(),
                           buildLetsMakeItLogo(),
                          verticalSpace(height: 32),
                          InkWell(
                            onTap: () async {
                              PreviousUser? p = await (getAccount());
                              if (useLocal && p != null) {
                                await authenticateUser(context, p.userName, p.password);
                              } else {
                                pushRoute(context, LogInPage());
                              }
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    fontFamily: App.font_name,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: "Sign in",
                                    style: TextStyle(color: normalBlue),
                                  )
                                ],
                              ),
                            ),
                          ),
                          verticalSpace(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: ElevatedButton(
                              onPressed: () {
                                pushRoute(context, Onboarding());
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle: TextStyle(color: Colors.white),
                                primary: Color.fromRGBO(182, 9, 27, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Get Started",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          verticalSpace(height: 16),
                          InkWell(
                            onTap: () {
                              pushRoute(context, TermsPage());
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: App.font_name,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          "By tapping \"Get Started\", you agree to our "),
                                  TextSpan(
                                    text: "Term of use ",
                                    style: TextStyle(color: normalBlue),
                                  ),
                                  TextSpan(text: "and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(color: normalBlue),
                                  )
                                ],
                              ),
                            ),
                          ),
                          verticalSpace(),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  loadCacheData() async {
    // print("Data stored temporato.....");
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
    UserProfile u = await showProfile(userModel.getAuthToken()!);
    if (u.status!) {
      userModel.setUserDetails(u.message!.userdetails);
      userModel.setUserProfileDetails(u.message!.profiledetails);
    }

    BioResponse bio = await fetchBio(userModel.getAuthToken());
    if (bio.status!) {
      userModel.setCoachBio(bio);
    }
    // print(userModel.getAuthToken());
  }
}
