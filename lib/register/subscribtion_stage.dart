import 'package:cme/account_pages/subscriptions_page.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bio_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/user_profile_class.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/register/permissions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class SubBody extends StatefulWidget {
  final String gender;
  final scfKey;
  const SubBody({Key? key, required this.gender, required this.scfKey})
      : super(key: key);
  @override
  _SubBodyState createState() => _SubBodyState();
}

class _SubBodyState extends State<SubBody> {
  bool isMonthlySub = false;
  bool isLoading = false;
  late UserModel userModel;
  bool isCoach = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, w, model) {
        userModel = model;

        return Stack(
          children: [
            ListView(
              children: [
                Image.asset("assets/logo2.png"),
                Center(
                  child: Text(
                    "Your personalised \nplan is ready",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: App.font_name,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                verticalSpace(),
                Center(
                  child: Text(
                    "Create your account to save your preference and"
                    "\n jumpstart your practice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: App.font_name,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                verticalSpace(),
                SubBodyWidget(
                  toDoAfterSucessfulPayment: () => proceed("0"),
                ),
              ],
            ),
            Positioned.fill(
              child: Visibility(
                visible: isLoading,
                child: Container(
                    child: Center(
                  child: CircularProgressIndicator(),
                )),
              ),
            )
          ],
        );
      },
    );
  }

  proceed(subId) async {
    print("Upload......SUB.");
    try {
      setState(() {
        isLoading = true;
      });
      // print("Upload data.......");
      var map = {
        "subscription_id": "$subId",
        "gender": "${widget.gender}",
      };
      var url = baseUrl + "api/auth/updateothers";
      http.Response r = await http.post(
        Uri.parse(url),
        body: map,
        headers: {
          "x-access-token": userModel.getAuthToken()!,
        },
      ).catchError((e) {
        // print("Upload failed.......$e");
      });

      // print("Upload inage......${r.body}.");
      await loadCacheData();
      setState(() {
        isLoading = false;
      });
      pushRoute(context, AllowPermissionsPage());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // showSnack(widget.scfKey, "Error Occured");
    }
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

  buildList() {}
}
