import 'dart:async';
import 'dart:typed_data';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/controllers/location_controller.dart';
import 'package:cme/map/marker_helper.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/buddy_up_response.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/buddy_up.dart';
import 'package:cme/network/player/fetch_coach_and_bootcamps.dart';
import 'package:cme/player_pages/buddy_up/buddy_bookings_record.dart';
import 'package:cme/player_pages/buddy_up/buddy_invite_friend.dart';
import 'package:cme/player_pages/buddy_up/buddyup_booking_page.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/draw_range/custom_range.dart';
import 'package:cme/ui_widgets/map_compass.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'dart:math' as m;
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FindBuddyPage extends StatefulWidget {
  final UserModel? userModel;

  const FindBuddyPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _FindBuddyPageState createState() => _FindBuddyPageState();
}

class _FindBuddyPageState extends State<FindBuddyPage> {
  // bool showCoachInfo = false;
  List<BNBItem> cLevel = [
    BNBItem("Amater", "assets/badge1.png"),
    BNBItem("Grassroot", "assets/badge2.png"),
    BNBItem("Professional", "assets/badge3.png"),
    BNBItem("Expert", "assets/badge4.png"),
  ];
  List<String> sports = [
    "Football",
    "Cricket",
    "Rugby",
    "Golf",
    "Tennis",
    "Personal Training",
  ];
  int selectedSportIndex = 0;

  UserModel? userModel;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  // Position? position;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(51.5074, 0.1278),
    // zoom: 64,
  );
  List<Marker> markers = [];
  Widget map = Container();

  List<Userdetails>? playersList = [];

  double minDistance = 10;
  double maxDistance = 40;

  double minPoint = 0;
  double maxPoint = 600;
  PanelController sliderController = PanelController();
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    fetchMapDataFromServer();
    var d = userModel!.getUserDetails()!;
    cameraPosition = CameraPosition(
      target: LatLng((d.lat ?? 51.5074) / 1.0, (d.lon ?? 0.1278) / 1.0),
      zoom: 12,
    );
    showMap();
  }

  showMap() async {
    await Future.delayed(Duration(seconds: 1));

    map = buildMap();
    getPosition();
    setState(() {});
  }
  getPosition() async {
    LocationController locationController = Get.find<LocationController>();

    print("getting position...${locationController.lat.value}");

      cameraPosition = CameraPosition(
      target: LatLng(locationController.lat.value  ,locationController.lng.value ),
      zoom: 13,
    );
    mapController?.animateCamera(  CameraUpdate.newLatLng(
      LatLng(locationController.lat.value, locationController.lng.value),
    ));
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow,
      body: Stack(
        children: <Widget>[
          map,
          SlidingUpPanel(
            controller: sliderController,
            renderPanelSheet: false,
            body: SafeArea(
              child: buildBody(context),
            ),
            maxHeight: 470,
            panel: buildFilter(),
            collapsed: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Filter",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Transform.rotate(
                            angle: m.pi * -.5,
                            child: Icon(
                              CupertinoIcons.forward,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAutoComplete() {
    return buildCard(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6),
            child: TypeAheadField<Userdetails>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Search for Player"),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty || playersList == null) {
                  return [];
                }
                List<Userdetails> u = [];

                for (var i in playersList!) {
                  if (i.name!.toLowerCase().contains("$pattern")) {
                    u.add(i);
                  }
                }
                return u;
              },
              itemBuilder: (context, suggestion) {
                Userdetails u = suggestion;
                return buildSearchItem(suggestion,
                    sport: sports[selectedSportIndex]);
              },
              onSuggestionSelected: (suggestion) {
                showPlayerInfoDialogue(context, suggestion);
              },
              hideOnEmpty: true,
            ),
          ),
        ),
        innerPadding: 0);
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 40,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20,
                            left: 10,
                            right: 10,
                          ),
                          child: backArrow(),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(),
                  Expanded(child: buildAutoComplete()),
                  horizontalSpace(),
                  buildBookingCount(),
                ],
              ),
              verticalSpace(),
              SizedBox(
                  height: 64,
                  child: ListView.separated(
                      separatorBuilder: (c, index) => horizontalSpace(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedSportIndex = index;
                              });

                              filterMapMarkers();
                            },
                            child: Chip(
                              backgroundColor: index == selectedSportIndex
                                  ? red
                                  : Colors.white,
                              label: Text(
                                sports[index],
                                style: TextStyle(
                                  color: index == selectedSportIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                      itemCount: sports.length))
            ],
          ),
        ),
        Positioned(
          bottom: 120,
          right: 16,
          child:  GestureDetector(
            onTap: (){
              getPosition();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0), child: compassIcon()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildBookingCount() {
    return FutureBuilder<FetchPlayerBuddyUpResponse>(
        future: fetchPlayerBuddyUpBooking(userModel!.getAuthToken()),
        builder: (context, snapshot) {
          List<BuddyUpBookingDetails> recv = [];
          if (snapshot == null) {
          } else {
            if (snapshot.data == null) {
              // return Container(
              //     child: Center(child: CupertinoActivityIndicator()));
            } else {
              var r = snapshot.data!;
              if (r.status!) {
                List<BuddyUpBookingDetails> l = [];
                for (BuddyUpBookingDetails item in r.details!) {
                  if (item.status == "pending") {
                    l.add(item);
                  }
                }
                recv = [];
                var myId = userModel!.getUserDetails()!.id;
                for (BuddyUpBookingDetails item in l) {
                  if (item.player1Id != myId) {
                    recv.add(item);
                  }
                }
              }
            }
          }
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              pushRoute(
                context,
                BuddyBookingRecordPage(
                  userModel: widget.userModel,
                  response: snapshot.data,
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/booking_clock.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Visibility(
                    visible: recv.isNotEmpty,
                    child: Container(
                      width: 15,
                      height: 15,
                      child: Center(
                        child: rMediumText(
                          "${recv.length}",
                          size: 10,
                          color: white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget buildFilterBody() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        mediumText("Points", size: 15),
        buildCustomRange(
          context: context,
          symbol: "",
          maxLimit: 2000,
          min: minPoint.floor(),
          max: maxPoint.floor(),
          onChanged: (RangeValues newValues) {
            setState(() {
              minPoint = newValues.start;
              maxPoint = newValues.end;
            });
            // filterMapMarkers();
          },
          onChangeEnd: (v) {},
          onChangeStart: (v) {},
        ),
        verticalSpace(height: 16),
        mediumText("Range", size: 15),
        buildCustomRange(
          context: context,
          symbol: "KM",
          maxLimit: 100,
          min: minDistance.floor(),
          max: maxDistance.floor(),
          onChanged: (RangeValues newValues) {
            setState(() {
              maxDistance = newValues.end;
              minDistance = newValues.start;
            });
            // filterMapMarkers();
          },
          onChangeEnd: (v) {},
          onChangeStart: (v) {},
        ),
        verticalSpace(height: 16),
        borderProceedButton(
          text: "Invite Friend",
          onPressed: () {
            pushRoute(context, BuddyInviteFriendPage());
          },
          color: Color.fromRGBO(182, 9, 27, 1),
        ),
        verticalSpace(),
        proceedButton(
          text: "Apply",
          onPressed: () {
            sliderController.close();
            filterMapMarkers();
          },
        ),
      ],
    );
  }

  Widget buildFilter() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          boldText("Filter", size: 17),
                          verticalSpace(height: 26),
                          Expanded(child: buildFilterBody()),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: mediumText(
                          "Players: ${playersList!.length}",
                          size: 16,
                          color: red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Transform.rotate(
                    angle: m.pi * .5,
                    child: Icon(
                      CupertinoIcons.forward,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBuddyInfo(Userdetails playerDetails) {
    return Container(
      height: 290, //MediaQuery.of(context).size.height * .4,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: Card(
                  // color: deepBlue,
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                    child: Column(
                      children: <Widget>[
                        verticalSpace(height: 48),
                        Column(
                          children: <Widget>[
                            boldText("${playerDetails.name}", size: 17),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Spacer(),
                                mediumText(
                                    "${getSportLevel(playerDetails, sport: sports[selectedSportIndex])}",
                                    size: 13,
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                                horizontalSpace(width: 3),
                                Image.asset(
                                  "assets/bar_chart.png",
                                  height: 10,
                                  width: 8,
                                ),
                                horizontalSpace(width: 3),
                                rBoldText(
                                    "${calculatePlayerPoints(playerDetails)}",
                                    size: 12),
                                Spacer(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/map_pin.png",
                                  width: 10,
                                  height: 15,
                                  color: red,
                                ),
                                horizontalSpace(width: 4),
                                Text(
                                  "${calculateDistanceBtw(userModel!.getUserDetails()!, playerDetails)} away",
                                  style: TextStyle(
                                    color: red,
                                    fontSize: 14,
                                    fontFamily: App.font_name2,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(height: 48),
                            proceedButton(
                              text: "Buddy up",
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                pushRoute(
                                  context,
                                  BuddyUpBookingPage(
                                    userdetails: playerDetails,
                                    userModel: widget.userModel,
                                    sport: sports[selectedSportIndex]
                                        .toLowerCase(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularNetworkImage(
                  imageUrl: "${photoUrl + playerDetails.profilePic!}",
                  size: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  filterMapMarkers() {
    var sportType = sports[selectedSportIndex].toLowerCase();
    // print("find players with....$sportType");
    List<Userdetails> players = [];
    for (var item in playersList!) {
      var sportsReg = item.sport!.sport!;

      for (var sp in sportsReg) {
        // print("player $sp..nedded..$sportType");
        if (sp == sportType) {
          players.add(item);
          // print("player $sp..nedded..$sportType");
          break;
        }
      }
    }

    List<Userdetails> temp = players.toList();
    players = [];
    for (var item in temp) {
      var points = calculatePlayerPoints(item);

      if ((points >= minPoint) && (points <= maxPoint)) {
        players.add(item);
      }
    }

    temp = players.toList();
    players = [];
    for (var item in temp) {
      var distance = calculateDistance(userModel!.getUserDetails()!, item);

      if ((distance >= minDistance) //&& (distance <= maxDistance)
          ) {
        players.add(item);
      }
    }

    // print("total found....${players.length}");
    loadMarkerToScreen(players);
  }

  fetchMapDataFromServer() async {
    BuddyUpResponse c = await fetchBuddyUpPlayers(userModel!.getAuthToken());
    // print("${c.status}............bootcamp");

    if (c.status!) {
      setState(() {
        playersList = c.playerDetails;
      });
      filterMapMarkers();
    }
  }

  loadMarkerToScreen(List<Userdetails> playerDetails) {
    // print("Loaded...successfully");
    MarkerGenerator(
      markerWidgets(playerDetails),
      (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(bitmaps, playerDetails);
          map = buildMap();
        });
        // print("Loaded...successfully....2");
      },
    ).generate(context);
    setState(() {});
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
      markers: markers.toSet(),
      onTap: (LatLng n) {},
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;

      },
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
    );
  }

  List<Marker> mapBitmapsToMarkers(
      List<Uint8List> bitmaps, List<Userdetails> playerDetails) {
    List<Marker> markersList = [];
    try {
      // print(
      //     "building markers.........${bitmaps.length}.........${playerDetails.length}");

      bitmaps.asMap().forEach((i, bmp) {
        // print("item...$i");

        final item = playersList![i];
        // print("coach build.....${item.lat}...${item.lon} ");
        markersList.add(Marker(
            markerId: MarkerId("${item.id}"),
            position: item.lat != null
                ? LatLng(
                    (item.lat ?? 51.5074) / 1.0, (item.lon ?? 0.1278) / 1.0)
                : LatLng(51.5074, 0.1278),
            onTap: () {
              showPlayerInfoDialogue(context, item);
            },
            icon: BitmapDescriptor.fromBytes(bmp)));
      });
    } catch (e) {
      // print("Error in bitmap ....$e");
    }

    return markersList;
  }

  List<Widget> markerWidgets(List<Userdetails> playerDetails) {
    var l = playerDetails;

    return List.generate(
      l.length,
      (index) {
        Userdetails i = l[index];
        var url = "${photoUrl + i.profilePic!}";

        // print(
        //     "+++++++++++++++add..${i.id}......${i.profile.appusagePt} + ${i.profile.bookingPt} + ${i.profile.socialsharePt}");
        var p = calculatePlayerPoints(i);
        return Container(
          height: 64,
          width: 64,
          child: Stack(
            children: <Widget>[
              CircularNetworkImage(
                imageUrl: url,
                size: 58,
              ),
              Positioned(
                // top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/bar_chart.png",
                        height: 10,
                        width: 8,
                      ),
                      horizontalSpace(width: 3),
                      rBoldText("$p", size: 12),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showPlayerInfoDialogue(context, Userdetails playerDetails) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return Container(
          height: 300,

          ///MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width,
          child: buildBuddyInfo(playerDetails),
        );
      },
    );
  }
}

Widget buildColumnTexts(String t1, String t2) {
  return Column(
    children: <Widget>[
      Text(
        t1,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        t2,
        style: TextStyle(
            fontWeight: FontWeight.w100, fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}

Widget priceText(price) {
  var style1 =
      TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w100);
  var style2 = TextStyle(fontSize: 16, color: Color.fromRGBO(182, 9, 27, 1));
  return Column(
    children: <Widget>[
      Text(
        "Starting at",
        style: style1,
      ),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text(
            "E $price",
            style: style2,
          ),
          Text(
            " / session",
            style: style1,
          )
        ],
      )
    ],
  );
}

Widget buildSearchItem(Userdetails u, {sport: "football"}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          CircularNetworkImage(
            imageUrl: "${photoUrl + u.profilePic!}",
            size: 48,
          ),
          horizontalSpace(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText("${u.name}", size: 14),
              verticalSpace(height: 8),
              mediumText("${getSportLevel(u, sport: sport)}", size: 12)
            ],
          ))
        ]),
      ),
      Divider(),
    ],
  );
}
