import 'package:cme/model/coach_session_response.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/build_booking_list_tile.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../app.dart';

class BookingsListTile extends StatelessWidget {
  final Booking booking;
  final Function? onEdit;
  final Function? onComment;
  final Function? onDelete;

  const BookingsListTile({
    Key? key,
    this.onEdit,
    this.onComment,
    this.onDelete,
    required this.booking,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Card(
        margin: EdgeInsets.all(0),
        shadowColor: Colors.black.withOpacity(.5),
        child:
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            // All actions are defined in the children parameter.
            children:   [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed:(c)=> onEdit,
                backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                foregroundColor: Colors.black,
                label: 'Edit',
                // icon:
                // ImageIcon(
                //   AssetImage( "assets/edit_red.png")
                //  ),
              ),

              SlidableAction(
                onPressed:(c)=> onComment ,
                backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
                foregroundColor: Colors.black,
                label: 'Message',
                // icon:
                // ImageIcon(
                //   AssetImage( "assets/message.png")
                //  ),
              ),

              SlidableAction(
                onPressed:(c)=> onDelete ,
                backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                foregroundColor: Colors.black,
                label: 'Delete',
                // icon:
                // ImageIcon(
                //   AssetImage( "assets/trash.png")
                //  ),
              ),
            ],
          ),
          child: SessionDetailListTile(
            booking: booking,
            date: "${booking.displayDate}",
            imgUrl: "${photoUrl + booking.user!.profilePic!}",
            level: "${getSportLevel(booking.user!)}",
            location: "${booking.location}",
            name: "${booking.user!.name}",
          ),
        ),




      ),
    );
  }
}

class ScheduledChallengeBookingsListTile2 extends StatelessWidget {
  final Function? onEdit;
  final Function? onComment;
  final Function? onDelete;
  final ChallengeBookingDetails bookingDetails;
  final int? myId;

  const ScheduledChallengeBookingsListTile2({
    Key? key,
    this.onEdit,
    this.onComment,
    this.onDelete,
    required this.myId,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Card(
            margin: EdgeInsets.all(0),
            shadowColor: Colors.black.withOpacity(.5),
            child:
            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                // All actions are defined in the children parameter.
                children:   [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed:(c)=> onEdit != null ? onEdit!() : null ,
                    backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                    foregroundColor: Colors.black,
                    label: 'Edit',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/edit_red.png")
                    //  ),
                  ),

                  SlidableAction(
                    onPressed:(c) {
                      if(onComment != null)
                        onComment!();
                    } ,
                    backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
                    foregroundColor: Colors.black,
                    label: 'Message',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/message.png")
                    //  ),
                  ),

                  SlidableAction(
                    onPressed:(c)=> onDelete != null ? onDelete!() : null ,
                    backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                    foregroundColor: Colors.black,
                    label: 'Delete',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/trash.png")
                    //  ),
                  ),
                ],
              ),
              child: ChallengeScheduledlListTile2(
                myId: myId,
                bookingDetails: bookingDetails,
              ),
            ),
          ),
        ),
        verticalSpace()
      ],
    );
  }
}

class ScheduledChallengeBookingsListTile extends StatelessWidget {
  final Function?                                                                                                                                                                                 onEdit;
  final Function? onComment;
  final Function? onDelete;
  final BuddyUpBookingDetails bookingDetails;
  final int? myId;

  const ScheduledChallengeBookingsListTile({
    Key? key,
    this.onEdit,
    this.onComment,
    this.onDelete,
    required this.myId,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Card(
            // elevation: 16,
            margin: EdgeInsets.all(0),
            shadowColor: Colors.black.withOpacity(.5),
            child:
            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                // All actions are defined in the children parameter.
                children:   [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed:(c)=> onEdit != null ? onEdit!() : null ,
                    backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                    foregroundColor: Colors.black,
                    label: 'Edit',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/edit_red.png")
                    //  ),
                  ),

                  SlidableAction(
                    onPressed:(c)=> onComment != null ? onComment!() : null ,
                    backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
                    foregroundColor: Colors.black,
                    label: 'Message',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/message.png")
                    //  ),
                  ),

                  SlidableAction(
                    onPressed:(c)=> onDelete != null ? onDelete!() : null ,
                    backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                    foregroundColor: Colors.black,
                    label: 'Delete',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/trash.png")
                    //  ),
                  ),
                ],
              ),
              child: ChallengeScheduledlListTile(
              myId: myId,
              bookingDetails: bookingDetails,
              ),
              ),
            ),
          ),
        verticalSpace()
      ],
    );
  }
}

class ChallengeBookingsListTile extends StatelessWidget {
  final Function? onAccept;
  final Function? onDelete;

  final String imgUrl;
  final String? name;
  final String expLevel;
  final String? dateText;
  final String? locationText;
  final String points;

  const ChallengeBookingsListTile({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.expLevel,
    required this.dateText,
    required this.locationText,
    required this.points,
    this.onAccept,
    this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Card(
            // elevation: 16,
            margin: EdgeInsets.all(0),
            shadowColor: Colors.black.withOpacity(.5),
            child:

            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                // All actions are defined in the children parameter.
                children:
                  onAccept == null
                      ?
                [  SlidableAction(
                    onPressed:(c)=> onDelete != null  ? onDelete!() : null ,
                    backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                    foregroundColor: Colors.black,
                    //  label: 'Delete',
                    icon:  Icon(Icons.delete).icon ,
                  )
                ]:[
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed:(c) {
                      onAccept!();
                    } ,
                    backgroundColor:  Colors.blue[800]!,
                    foregroundColor: Colors.black,
                    label: 'Accept',
                    // icon:
                    // ImageIcon(
                    //   AssetImage( "assets/edit_red.png")
                    //  ),
                  ),

                    SlidableAction(
                      onPressed:(c)=> onDelete != null  ? onDelete!() : null ,
                      backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                      foregroundColor: Colors.black,
                      //  label: 'Delete',
                      icon:  Icon(Icons.close).icon ,
                    )
                  ],
              ),
              child: ChallengeDetailListTile(
                imgUrl: imgUrl,
                name: name,
                expLevel: expLevel,
                dateText: dateText,
                locationText: locationText,
                points: points,
              ),
            ),
          ),
        ),
        // verticalSpace()
      ],
    );
  }
}

class ChallengeScheduledlListTile2 extends StatelessWidget {
  final ChallengeBookingDetails bookingDetails;
  final int? myId;

  const ChallengeScheduledlListTile2({
    Key? key,
    required this.bookingDetails,
    required this.myId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var p1 = bookingDetails.player1Details!;
    var p2 = bookingDetails.player2Details!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: buildProfile(
                  expLevel: "${getSportLevel(p1)}",
                  points:
                      "${bookingDetails.player1Profile != null ? calculatePlayerPoints2(bookingDetails.player1Profile!) : 0}",
                  imgUrl: "${photoUrl + p1.profilePic!}",
                  name: p1.id == myId ? "You" : "${p1.name}",
                ),
              ),
              iconTitle(
                "assets/map_pin.png",
                "${bookingDetails.location}",
                Colors.blue,
              ),
            ],
          ),
          // verticalSpace(),
          Center(
            child: boldText(
              "VS",
              size: 20,
              color: Color.fromRGBO(226, 3, 3, 1),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: iconTitle(
                  "assets/booking_clock.png",
                  "${bookingDetails.displayDate}",
                  red,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: buildProfile(
                    expLevel: "${getSportLevel(p2)}",
                    points: "${bookingDetails.player1Profile != null ? calculatePlayerPoints2(bookingDetails.player1Profile!) : 0}",
                    imgUrl: "${photoUrl + p2.profilePic!}",
                    name: p2.id == myId ? "You" : "${p2.name}",
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class ChallengeScheduledlListTile extends StatelessWidget {
  final BuddyUpBookingDetails bookingDetails;
  final int? myId;

  const ChallengeScheduledlListTile({
    Key? key,
    required this.bookingDetails,
    required this.myId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var p1 = bookingDetails.player1User!;
    var p2 = bookingDetails.player2User!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: buildProfile(
                  expLevel: "${getSportLevel(p1)}",
                  points:
                      "${bookingDetails.player1Profile != null ? calculatePlayerPoints2(bookingDetails.player1Profile!) : 0}",
                  imgUrl: "${photoUrl + p1.profilePic!}",
                  name: p1.id == myId ? "You" : "${p1.name}",
                ),
              ),
              iconTitle(
                "assets/map_pin.png",
                "${bookingDetails.location}",
                Colors.blue,
              ),
            ],
          ),
          // verticalSpace(),
          Center(
            child: boldText(
              "VS",
              size: 20,
              color: Color.fromRGBO(226, 3, 3, 1),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: iconTitle("assets/booking_clock.png",
                      "${bookingDetails.displayDate}", red)),
              Expanded(
                  flex: 3,
                  child: buildProfile(
                    expLevel: "${getSportLevel(p2)}",
                    points: "${bookingDetails.player1Profile != null ? calculatePlayerPoints2(bookingDetails.player1Profile!) : 0}",
                    imgUrl: "${photoUrl + p2.profilePic!}",
                    name: p2.id == myId ? "You" : "${p2.name}",
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class ChallengeHistorylListTile extends StatelessWidget {
  final int myId;
  final BuddyUpBookingDetails bookingDetails;

  const ChallengeHistorylListTile({
    Key? key,
    required this.myId,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var p1 = bookingDetails.player1User!;
    var p2 = bookingDetails.player2User;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Card(
          // elevation: 16,
          margin: EdgeInsets.all(0),
          shadowColor: Colors.black.withOpacity(.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: buildProfile(
                          imgUrl: "assets/guy.png",
                          name: "${p1.name}",
                          expLevel: "Professional",
                          points: "12345"),
                    ),
                    iconTitle("assets/map_pin.png", "Hampton Court Park",
                        Colors.blue),
                  ],
                ),
                // verticalSpace(),
                Center(
                  child: boldText(
                    "VS",
                    size: 20,
                    color: Color.fromRGBO(226, 3, 3, 1),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: iconTitle("assets/booking_clock.png",
                          "${bookingDetails.displayDate}", red),
                    ),
                    Expanded(
                      flex: 3,
                      child: buildProfile(
                        imgUrl: "http://178.248.109.145:3000/assets/avatar.png",
                        name: "Christine Smith",
                        expLevel: "Professional",
                        points: "23456",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChallengeHistorylListTile2 extends StatelessWidget {
  final int myId;
  final ChallengeBookingDetails bookingDetails;

  const ChallengeHistorylListTile2({
    Key? key,
    required this.myId,
    required this.bookingDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var p1 = bookingDetails.player1Details!;
    var p2 = bookingDetails.player2Details!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Card(
          // elevation: 16,
          margin: EdgeInsets.all(0),
          shadowColor: Colors.black.withOpacity(.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: buildProfile(
                          imgUrl: "${photoUrl + p1.profilePic!}",
                          name: myId == p1.id ? "You" : "${p1.name}",
                          expLevel: "Professional",
                          points: "12345"),
                    ),
                    iconTitle(
                      "assets/map_pin.png",
                      "Hampton Court Park",
                      Colors.blue,
                    ),
                  ],
                ),
                // verticalSpace(),
                Center(
                  child: boldText(
                    "VS",
                    size: 20,
                    color: Color.fromRGBO(226, 3, 3, 1),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: iconTitle(
                          "assets/booking_clock.png", "May 29,2020", red),
                    ),
                    Expanded(
                      flex: 3,
                      child: buildProfile(
                        imgUrl: "${photoUrl + p2.profilePic!}",
                        name: myId == p2.id ? "You" : "${p2.name}",
                        expLevel: "Professional",
                        points: "23456",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
