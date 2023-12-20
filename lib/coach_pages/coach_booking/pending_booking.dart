import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/coach_booking.dart';
import 'package:cme/map/pick_location.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/booking_coach.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/address_function.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class PendingBooking extends StatefulWidget {
  final UserModel? userModel;
  final scafKey;

  const PendingBooking({
    Key? key,
    required this.userModel,
    required this.scafKey,
  }) : super(key: key);

  @override
  _PendingBookingState createState() => _PendingBookingState();
}

class _PendingBookingState extends State<PendingBooking> {
  UserModel? userModel;
  List<CoachBookingDetail>? details = [];
  late var _key;

  late Future<CoachBookingResponse> _task;


  @override
  void initState() {
    super.initState();
    print("initState");

    userModel = widget.userModel;
    _key = widget.scafKey;
    _task = fetchBoking(userModel!.getAuthToken(), status: "pending");
  }

  @override
  Widget build(BuildContext context) {
     print("rebuild");
    return FutureBuilder<CoachBookingResponse>(
        initialData: userModel!.getCoachBookings()[0],
        future: _task,
        builder: (context, snapshot) {
          // print("$snapshot");
          if (snapshot == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var s = snapshot.data!;

              if (s.status!) {
                details = s.details;
                userModel!.updateCoachBookingCount(details!.length);
              }
              // print("$details");

              if (details!.isEmpty) {
                return Center(
                  child: boldText(
                    "You do not have any pending booking",
                    textAlign: TextAlign.center,
                    color: white,
                  ),
                );
              } else {
                return ListView(
                  children: [
                    verticalSpace(height: 16),
                    Wrap(
                      children: List.generate(
                        details!.length,
                        (index) {
                          CoachBookingDetail d = details![index];
                          return InkWell(
                            onTap: () {
                              // pushRoute(context, ChallengeMAtchUpPage());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child:
                              Invited(
                                onAccept: (c) => acceptInvitation(context, d),
                                onDeny: (c) => onDenyInvitation(context, d),
                                details: d,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
          }
        });
  }

  onDenyInvitation(BuildContext context, CoachBookingDetail d) async {
    var p =
        await rejectBooking(userModel!.getAuthToken(), bookid: d.id.toString());
    setState(() {});

    if (p.status!) {
      details!.remove(d);
    }
    // print("......");

    showSnack(
        context,
        p.status!
            ? "Booking Rejected\n\n\n\n\n"
            : "Booking Reject failed\n\n\n\n\n");
  }

  acceptInvitation(BuildContext context, CoachBookingDetail de) async {
    var prog = ProgressDialog(context);
    prog.style(message: 'Processing...');

    if (de.sessionmode == 0) {
      await prog.show();
      var p = await approveBooking(
        userModel!.getAuthToken(),
        bookid: "${de.id}",
        location: "Virtual",
        lon: "0",
        lat: "0",
      );

      await prog.hide();
      if (p.status!) {
        details!.remove(de);
      }
      showSnack(
          context,
          p.status!
              ? "Booking Accepted\n\n\n\n\n"
              : "Booking Accept failed\n\n\n\n\n");
      setState(() {});
      return;
    }

    // print("accept....from ...${d.user.name}");
    Userdetails? d = widget.userModel!.getUserDetails();
    LatLng? c = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (con) => PickLoactionPage(
          currentLocation:
              LatLng((d!.lat ?? 51.5074) / 1.0, (d.lon ?? 0.1278) / 1.0),
        ),
      ),
    );
    String? bookingAddress = "";

    late LatLng currentLocation;
    if (c == null) {
      showSnack(context, "No Location was selected\n\n\n\n\n");
    } else {
      await prog.show();
      var add = await convertCordinaeToAddress(c);
      setState(() {
        currentLocation = c;
        bookingAddress = add;
      });
      // print(
      //     "$bookingAddress....new location=>>>>>> lat: ${currentLocation.latitude}  lon: ${currentLocation.longitude}");

      var p = await approveBooking(
        userModel!.getAuthToken(),
        bookid: "${de.id}",
        location: "$bookingAddress",
        lon: "${currentLocation.longitude}",
        lat: "${currentLocation.latitude}",
      );
      await prog.hide();
      if (p.status!) {
        details!.remove(de);
      }
      setState(() {});
      showSnack(
          _key,
          p.status!
              ? "Booking Accepted\n\n\n\n\n"
              : "Booking Accept failed\n\n\n\n\n");
    }
    this.setState(() {});
  }
}
