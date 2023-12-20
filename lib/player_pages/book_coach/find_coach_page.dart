import 'dart:async';
import 'dart:typed_data';

import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/controllers/location_controller.dart';
import 'package:cme/map/marker_helper.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/contact_filter_response.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/contact_filter.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/fetch_coach_and_bootcamps.dart';
import 'package:cme/player_pages/book_coach/boot_camp_search_page.dart';
import 'package:cme/player_pages/book_coach/coach_boot_camp_list_page.dart';
import 'package:cme/player_pages/book_coach/choose_time_page.dart';
import 'package:cme/player_pages/bootcamp/boot_review_time_page.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/build_tooltip.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:cme/ui_widgets/draw_range/custom_range.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/map_compass.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/filter/filter_coach_on_map.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
 import 'dart:math' as m;
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/build_filter_card.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:cme/utils/functions.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:geolocator/geolocator.dart';
import 'package:address_search_field/address_search_field.dart';

class FindCoachPage extends StatefulWidget {
  final LatLng currentLocation;
  final UserModel? userModel;

  const FindCoachPage(
      {Key? key,
      this.currentLocation: const LatLng(51.5074, 0.1278),
      required this.userModel})
      : super(key: key);
  @override
  _FindCoachPageState createState() => _FindCoachPageState();
}

class _FindCoachPageState extends State<FindCoachPage> {
  Widget map = Container();

  final GeoMethods geoMethods = GeoMethods(
      googleApiKey: mapApiKey,
      language: 'en');
  TextEditingController controller = TextEditingController();
  Address? destinationAddress ;

  List<String> sports = [
    "Football",
    "Rugby",
    "Tennis",
    "Personal Training",
  ];
  int selectedSportIndex = 0;
  List<BNBItem> cLevel = [
    BNBItem("Amateur", "assets/badge1.png"),
    BNBItem("Grassroot", "assets/badge2.png"),
    BNBItem("Professional", "assets/badge3.png"),
    BNBItem("Expert", "assets/badge4.png"),
  ];
  List<String> ageGroup = ["3-6", "7-11", "12-17", "18+"];
  List<BNBItem> expertiseList = [
    BNBItem("Endurance", "assets/e1.png"),
    BNBItem("Strength", "assets/e2.png"),
    BNBItem("Conditioning", "assets/e3.png"),
    BNBItem("Weight Loss", "assets/e4.png"),
  ];
  List<BNBItem> gameType = [
    BNBItem("Futsal", "assets/gt1.png"),
    BNBItem("11 a side", "assets/gt2.png"),
    BNBItem("Small Sided", "assets/gt3.png"),
  ];
  List<BNBItem> eType = [
    BNBItem("Morning", "assets/sunrise.png"),
    BNBItem("Afternoon", "assets/sun.png"),
    BNBItem("Evening", "assets/moon.png"),
  ];

  bool showAdditional = false;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;

  late CameraPosition cameraPosition;
  List<Marker> markers = [];
  List<Marker> markersBootCamp = [];

  UserModel? userModel;
  List<Userdetails> coachList = [];
  List<BootCampDetails>? bootCampList = [];

  List<Userdetails> contactsAdded = [];
  List<Userdetails>? registeredContact = [];

  bool canCheckContact = false;
  // Position? position;
//Bottom filter
  int? coachExpLevelIndex;
  int? coachExpertiseIndex;
  int? coachGamePlayIndex;
  int? coachExperienceTimeIndex;

  double minPrice = 0;
  double maxPrice = 25;

  double minDistance = 0;
  double maxDistance = 250000000;

  PanelController sliderController = PanelController();

  var coachJsonResponse;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    mapPermission();
    fetchCoachMapDataFromServer();
    checkContactPermission();
    var d = userModel!.getUserDetails()!;
    getPosition();
    LocationController locationController = Get.find<LocationController>();

    cameraPosition = CameraPosition(
        target: LatLng(locationController.lat.value, locationController.lng.value),
        zoom: 12,
      );

    showMap();
  }

  showMap() async {
    await Future.delayed(Duration(seconds: 1));
    map = buildMap();
    setState(() {});
  }
  showAdressPosition(){
    changePosition(bounds:destinationAddress?.bounds );
  }
  getPosition() async {
    LocationController locationController = Get.find<LocationController>();
 //   position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
     changePosition( position:LatLng(locationController.lat.value, locationController.lng.value));
  }
  changePosition({LatLng? position, LatLngBounds? bounds  }){
    if( position != null ) {
      mapController?.animateCamera(  CameraUpdate.newLatLng(  position, ));
      setState(() {
      });
    }
    if(bounds != null ){
      mapController?.moveCamera(
          CameraUpdate.newLatLngBounds(bounds, 12)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    var unfoldedHeight =  MediaQuery.of(context).size.height*0.8;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // buildMap(),
          map,
          SlidingUpPanel(
            controller: sliderController,
            renderPanelSheet: false,
            maxHeight:650,
            body:
            SafeArea(
              child: buildBody(context),
            ),
            panel:buildFilter(context),
            collapsed: GestureDetector(
              onTap: (){
                sliderController.isPanelOpen ? sliderController.close() : sliderController.open();
              },
              child: Stack(
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
                                  "Additional Filters",
                                  // "Filter",
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
          ),
        ],
      ),
    );
  }

  buildBookingCount() {
    return InkWell(
      onTap: () {
        // Navigator.pop(context);

        showCoachBootListDialogue(context);
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
                    child: Icon(Icons.list_alt)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkContactPermission() async {
    bool isGranted = await Permission.contacts.isGranted;
    if (!isGranted) {
      var c = await Permission.contacts.request();
      if (c == PermissionStatus.granted) {
        isGranted = true;
      }
    }

    if (isGranted) {
      loadRegisteredOnContactList();
    }

    setState(() {
      canCheckContact = isGranted;
    });
  }

  loadRegisteredOnContactList() async {
    FilterContactResponse c = await filterUserContact(
      token: widget.userModel!.getAuthToken()!,
      countryCode: widget.userModel!.getUserDetails()!.countryId,
    );
    if (c.status!) {
      setState(() {
        registeredContact = c.details;
      });
    }
  }

  fetchCoachMapDataFromServer() async {
    coachJsonResponse = await fetchMapCoachDetails(userModel!.getAuthToken());
    print("............coch");

    fetchBootCampMapDataFromServer();

    setState(() {});
  }

  fetchBootCampMapDataFromServer() async {
    MapBootCampResponse c = await fetchBootCampOnly(userModel!.getAuthToken());
    print("${c.status}............bootcamp");

    if (c.status!) {
      bootCampList = c.details;
      // print("derails:.......${c.details}");
    }
    filterMapMarkers();
    setState(() {});
  }

  filterMapMarkers() {
    print("start filter");

    List<Userdetails> cl = filerCoachOnMapJson(
        sport: sports[selectedSportIndex].toLowerCase(),
        sportLevel: coachExpLevelIndex,
        coachExpertise: coachExpertiseIndex == null
            ? null
            : "${expertiseList[coachExpertiseIndex!].title}".toLowerCase(),
        coachGamePlay: coachGamePlayIndex == null
            ? null
            : "${gameType[coachGamePlayIndex!].title}".toLowerCase(),
        coachPrice: minPrice,
        coachPriceMax: maxPrice,
        ageGroup: null,
        distanceMax: maxDistance,
        distanceMin: minDistance,
        jsonResponse: coachJsonResponse);

    coachList = cl;
    markers.clear();
    loadMarkerToScreen(cl, bootCampList!);
  }

  loadMarkerToScreen(
    List<Userdetails> coachList,
    List<BootCampDetails> bootCampList,
  ) {
    MarkerGenerator(markerBootCampWidgets(bootCampList), (bitmaps) {
      print("bc list ..${markers.length}");

      setState(() {
        markers += bootCampMapBitmapsToMarkers(bitmaps, bootCampList);
        map = buildMap();
      });
    }).generate(context);
    MarkerGenerator(markerCoachWidgets(coachList), (bitmaps) {
      print("coach list ..${markers.length}");
      setState(() {
        markers += mapBitmapsToMarkers(bitmaps, coachList);
        map = buildMap();
      });
    }).generate(context);

    setState(() {});
  }

  Future<void> mapPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  Widget buildMap() {
    // mapPermission();
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
      List<Uint8List> bitmaps, List<Userdetails> coachList) {
    // print("building markers.........${bitmaps.length}");
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final item = coachList[i];
      print("coach build.....${item.lat}...${item.lon} ");
      markersList.add(Marker(
          markerId: MarkerId("coach${item.id}"),
          position: item.lat != null
              ? LatLng(item.lat / 1.0 ?? 51.5074, item.lon / 1.0 ?? 0.1278)
              : LatLng(51.5074, 0.1278),
          onTap: () {
            showCoachInfoDialogue(context, item);
          },
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return markersList;
  }

  List<Marker> bootCampMapBitmapsToMarkers(
    List<Uint8List> bitmaps,
    List<BootCampDetails> bootCampList,
  ) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final item = bootCampList[i];
      markersList.add(Marker(
          markerId: MarkerId("boot${item.id}"),
          position: item.lat != null
              ? LatLng(item.lat / 1.0 ?? 51.5074, item.lon / 1.0 ?? 0.1278)
              : LatLng(51.5074, 0.1278),
          onTap: () {
            showBootCampInfoDialogue(context, item);
          },
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return markersList;
  }

  void showCoachInfoDialogue(context, Userdetails currentCoach) {
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
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width,
          child: buildCoachInfo(context, currentCoach, userModel),
        );
      },
    );
  }

  void showSearchBootCampDialogue(context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    var c = await showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            // height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width,
            child: BootCampSearchPage(
              bootCampList: bootCampList,
            ),
          ),
        );
      },
    );

    if (c == null) {
      print("Nothing returned");
    } else {
      showBootCampInfoDialogue(context, c);
    }
  }

  void showBootCampInfoDialogue(context, BootCampDetails bootCampDetails) {
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
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          child: buildBootCampInfo(bootCampDetails),
        );
      },
    );
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
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20, left: 10, right: 10),
                        child: backArrow(),
                      ),
                    ),
                  ),
                  horizontalSpace(),
                  Expanded(
                    child: buildAutoComplete(context),
                  ),
                  horizontalSpace(),
                  buildBookingCount()
                ],
              ),
              verticalSpace(),
              SizedBox(
                  height: 64,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // ActionChip(
                      //   backgroundColor: white,
                      //   avatar: Icon(Icons.search),
                      //   label: Text("Search for Boot Camp"),
                      //   onPressed: () {
                      //     showSearchBootCampDialogue(context);
                      //   },
                      // ),
                      // horizontalSpace(),
                      ListView.separated(
                          shrinkWrap: true,
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
                          itemCount: sports.length),
                    ],
                  ))
            ],
          ),
        ),
        Positioned(
          bottom: 120,
          right: 16,
          child: GestureDetector(
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

  Widget buildFilterBody(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = (width / 4 )-15;
    itemWidth = itemWidth + ((itemWidth/2) /4);
    return SizedBox(
      child: ListView(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  // "Coach level",
                  "Level of Coach",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              horizontalSpace(),
              buildToolTip(),
            ],
          ),
          verticalSpace(height: 16),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              height: 100,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, index) => InkWell(
                        onTap: () {
                          setState(() {
                            if(coachExpLevelIndex == index){
                              coachExpLevelIndex = null;
                             }else{
                              coachExpLevelIndex = index;
                            }
                          });
                          //filterMapMarkers();
                        },
                        child: buildFilterCard(
                          cLevel[index].title,
                          cLevel[index].icon,
                          isSelected: index == coachExpLevelIndex,
                          width: itemWidth
                        ),
                      ),
                  separatorBuilder: (c, i) => horizontalSpace(),
                  itemCount: 4),
            ),
          ),
          verticalSpace(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              horizontalSpace(),
              // buildToolTipWithText(   text: "You can expect to pay £75-100/hour for a top coach"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: buildCustomRange(
              context: context,
              maxLimit: 100,
              min: minPrice.floor(),
              max: maxPrice.floor(),
              onChanged: (RangeValues newValues) {
                setState(() {
                  maxPrice = newValues.end;
                  minPrice = newValues.start;
                });
              },
              onChangeEnd: (RangeValues newValues) {},
              onChangeStart: (v) {},
            ),
          ),
          verticalSpace(height: 24),

          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "Distance of coach",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: buildCustomRange(
              context: context,
              symbol: "mi",
              finalText:"National",
              min: minDistance.floor(),
              max: maxDistance.floor(),
              onChangeEnd: (RangeValues newValues) {},
              onChanged: (RangeValues newValues) {
                setState(() {
                  maxDistance = newValues.end;
                  minDistance = newValues.start;
                });
                // filterMapMarkers();
              },
              onChangeStart: (v) {},
            ),
          ),
          verticalSpace(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              // "Experiences",
              'Availability',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          verticalSpace(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, index) => InkWell(
                        onTap: () {
                          setState(() {
                            coachExperienceTimeIndex =  (coachExperienceTimeIndex == index)? null :  index;
                          });
                          //   filterMapMarkers();
                        },
                        child: buildFilterCardColored(
                          text: eType[index].title,
                          image: eType[index].icon,
                          bgColor: coachExperienceTimeIndex == index
                              ? Color.fromRGBO(25, 87, 234, 1)
                              : Colors.white,
                          imageColor: coachExperienceTimeIndex != index
                              ? Color.fromRGBO(25, 87, 234, 1)
                              : Colors.white,
                          textColor: coachExperienceTimeIndex != index
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                  separatorBuilder: (c, i) => horizontalSpace(),
                  itemCount: eType.length),
            ),
          ),
          verticalSpace(height: 16),
          InkWell(
            onTap: () {
              setState(() {
                showAdditional = !showAdditional;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    showAdditional? "assets/minus_border.png":"assets/add_border.png",
                    height: 20,
                    width: 20,
                  ),
                  horizontalSpace(),
                  Text(
                    "Filter",
                    // "Additional Filter",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          verticalSpace(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Visibility(visible: showAdditional, child: additionalFilterBody()),
          ),
          verticalSpace(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: proceedButton(
                text: "Apply",
                onPressed: () {
                  filterMapMarkers();
                  sliderController.close();
                }),
          ),
        ],
      ),
    );
  }

  Widget additionalFilterBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        verticalSpace(),
        Text(
          "Select Expertise",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // verticalSpace(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, index) => InkWell(
                      onTap: () {
                        setState(() {
                           coachExpertiseIndex =  (coachExpertiseIndex == index)? null :  index;

                        });
                        filterMapMarkers();
                      },
                      child: buildFilterCardColored(
                        text: expertiseList[index].title,
                        image: expertiseList[index].icon,
                        bgColor: index == coachExpertiseIndex
                            ? Color.fromRGBO(25, 87, 234, 1)
                            : Colors.white,
                        imageColor: index != coachExpertiseIndex
                            ? Color.fromRGBO(25, 87, 234, 1)
                            : Colors.white,
                        textColor: index != coachExpertiseIndex
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                separatorBuilder: (c, i) => horizontalSpace(),
                itemCount: expertiseList.length),
          ),
        ),
        // Text(
        //   "Gameplay Type",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        // verticalSpace(height: 16),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     height: 100,
        //     child: ListView.separated(
        //         scrollDirection: Axis.horizontal,
        //         itemBuilder: (c, index) => InkWell(
        //               onTap: () {
        //                 setState(() {
        //                    coachGamePlayIndex =  (coachGamePlayIndex == index)? null :  index;
        //                 });
        //                 filterMapMarkers();
        //               },
        //               child: buildFilterCardColored(
        //                 text: gameType[index].title,
        //                 image: gameType[index].icon,
        //                 bgColor: index == coachGamePlayIndex
        //                     ? Color.fromRGBO(25, 87, 234, 1)
        //                     : Colors.white,
        //                 imageColor: index != coachGamePlayIndex
        //                     ? Color.fromRGBO(25, 87, 234, 1)
        //                     : Colors.white,
        //                 textColor: index != coachGamePlayIndex
        //                     ? Colors.black
        //                     : Colors.white,
        //               ),
        //             ),
        //         separatorBuilder: (c, i) => horizontalSpace(),
        //         itemCount: gameType.length),
        //   ),
        // ),
      ],
    );
  }

  Widget buildFilter(BuildContext context) {
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
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Text(
                          // "Additional Filters",
                          "Filter",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: buildFilterBody(context)),
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
          child: GestureDetector(
            onTap: (){
              sliderController.isPanelOpen ? sliderController.close() : sliderController.open();
            },
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
        ),
      ],
    );
  }

  Widget buildCoachInfo(
      context, Userdetails currentCoach, UserModel? userModel) {
    BioSubDetail? currentDetails;
    for (var item in currentCoach.bioSubDetaiList!) {
      if (item.sport!.toLowerCase() ==
          sports[selectedSportIndex].toLowerCase()) {
        currentDetails = item;
        break;
      }
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
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
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: (currentCoach.profile?.rating ?? 1) / 1.0,
                                    size: 20.0,
                                 //   isReadOnly: true,
                                    color: Color.fromRGBO(25, 87, 234, 1),
                                    borderColor: Color.fromRGBO(25, 87, 234, 1),
                                    spacing: 0.0),
                                verticalSpace(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    buildColumnTexts(
                                        "${(currentCoach.profile?.rating ?? 0)?.toStringAsFixed(1)}",
                                        "Rating"),
                                    horizontalSpace(width: 10),
                                    buildColumnTexts(
                                        "${currentCoach.profile?.session ?? 0}",
                                        "Sessions"),
                                  ],
                                )
                              ],
                            ),
                            horizontalSpace(),
                            Spacer(),
                            horizontalSpace(),
                            // Text("Starting at\n E 25 /session"),
                            priceText(currentDetails!.bioPrice),
                            horizontalSpace()
                          ],
                        ),
                        verticalSpace(height: 16),
                        Column(
                          children: <Widget>[
                            Text(
                              "${currentCoach.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                             // "${cLevel[currentDetails.bioLevel!].title}",
                              "${getCoachSportLevel(currentCoach, sport: sports[selectedSportIndex])}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/map_pin.png",
                                  height: 12,
                                  color: red,
                                ),
                                horizontalSpace(),
                                Text(
                                  "${calculateDistanceLatLng(userModel!.getUserDetails()!, currentDetails.bioLat, currentDetails.bioLon).toStringAsFixed(2)} mi away",
                                  style: TextStyle(
                                    fontFamily: App.font_name2,
                                    color: Color.fromRGBO(182, 9, 27, 1),
                                    fontWeight: FontWeight.w100,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "About",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                verticalSpace(),
                                Expanded(
                                  child: Text(
                                    "${currentDetails.bioAbout}",
                                    // "It is a long established fact that a reader will be by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using ‘Content here, content here’, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for ‘lorem ipsum’ will uncover many web sites still in their infancy.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey,
                                        fontSize: 12),
                                  ),
                                ),
                                verticalSpace(height: 16),
                                Text(
                                  "Age Groups",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                verticalSpace(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    4,
                                    (index) {
                                      var text = ageGroup[index];
                                      return text !=
                                              currentCoach.profile?.ageGroup
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16)),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 4),
                                                child: Text("$text"),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                color: Color.fromRGBO(
                                                    25, 87, 234, 1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 4, 16, 4),
                                                child: Text(
                                                  "$text",
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                                verticalSpace(height: 32),
                                proceedButton(
                                    text: "Book Session",
                                    onPressed: () async {
                                      map = Container();

                                      // setState(() {});
                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      await Navigator.push(
                                        context,
                                        NavigatePageRoute(
                                          context,
                                          BookCoachChooseTimePage(
                                            currentCoach: currentCoach,
                                            userModel: widget.userModel,
                                            currentDetails: currentDetails,
                                          ),
                                        ),
                                      );
                                      map = buildMap();
                                      setState(() {});
                                    }),
                              ],
                            ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularNetworkImage(
                  imageUrl: "${photoUrl + (currentCoach.profilePic ?? "")  }",
                  size: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBootCampInfo(BootCampDetails b) {
    contactsAdded.clear();
    return SizedBox(
      height: MediaQuery.of(context).size.height * .80,
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
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: 5,
                                    size: 20.0,
                                  //  isReadOnly: true,
                                    color: Color.fromRGBO(25, 87, 234, 1),
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                                verticalSpace(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    //ggg
                                    buildColumnTexts(
                                        "${(b.coachProfile?.rating ?? 0).toStringAsFixed(1)}",
                                        "Rating"),
                                    horizontalSpace(),
                                    buildColumnTexts(
                                        "${b.coachProfile?.session ?? 0}",
                                        "Sessions"),
                                  ],
                                )
                              ],
                            ),
                            horizontalSpace(),
                            Spacer(),
                            horizontalSpace(),
                            // Text("Starting at\n E 25 /session"),
                            priceText("${b.price}"),
                            horizontalSpace()
                          ],
                        ),
                        verticalSpace(height: 16),
                        Column(
                          children: <Widget>[
                            Text(
                              "${b.coachDetails!.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            mediumText(
                              "${b.bootCampName}",
                              size: 22,
                              color: Colors.black,
                            ),
                            Column(
                              children: [
                                Center(
                                    child: iconTitle2("assets/map_pin.png",
                                        "${b.location}", blue)),
                                Center(
                                  child: iconTitle2(
                                    "assets/booking_clock.png",
                                    "${toDate(b.bootCampDate)} ${b.bootcamptime!.first.time}",
                                    red,
                                    fontName: App.font_name2,
                                  ),
                                ),
                                Center(
                                  child: iconTitle2(
                                    "assets/bnb4a.png",
                                    "${b.joinedbootcamp!.length}/${b.capacity}",
                                    Colors.grey,
                                    fontName: App.font_name2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        buildDivider(),
                        Expanded(
                          child: Container(
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildGroupBooking(),
                              ],
                            ),
                          ),
                        ),
                        proceedButton(
                            text: "Book Bootcamp",
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              pushRoute(
                                context,
                                PlayerBootCampReviewPage(
                                  bootCampDetails: b,
                                  userModel: widget.userModel,
                                  otherUsers: contactsAdded,
                                ),
                              );
                            }),
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
                    imageUrl: "$photoUrl${b.coachDetails!.profilePic}",
                    size: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGroupBooking() {
    return Visibility(
      visible: canCheckContact && registeredContact!.isNotEmpty,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Group Booking",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            verticalSpace(),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(.3), blurRadius: 16),
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Card(
                  margin: EdgeInsets.all(0),
                  // shape: StadiumBorder(),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      // alignLabelWithHint: true,
                      hintText: "Search your friend",
                      hintStyle: Style.hintTextStyle,
                    ),
                  ),
                ),
              ),
            ),
            verticalSpace(height: 30),
            canCheckContact
                ? Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: registeredContact!.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: black,
                                  size: 45,
                                ),
                                mediumText("No Contact registered"),
                              ],
                            ),
                          )
                        : ListView(
                            children: List.generate(
                              registeredContact!.length,
                              (index) {
                                var i = registeredContact![index];
                                return buildContactTile(
                                  i,
                                  isSelected: contactsAdded.contains(i),
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (contactsAdded.contains(i)) {
                                          contactsAdded.remove(i);
                                        } else {
                                          contactsAdded.add(i);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  )
                : InkWell(
                    onTap: () {
                      checkContactPermission();
                    },
                    child: mediumText("Allow Permission to Read Contacts"),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildAutoComplete(BuildContext context) {
    return buildCard(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Search for location"),
              controller: controller,
              onTap: () => showDialog(
                 context: context,
                  builder: (BuildContext context) => AddressSearchDialog(
                    geoMethods: geoMethods,
                    controller: controller,
                    onDone: (Address address) {
                      destinationAddress = address;
                      print("addr found here ;; ${destinationAddress?.coords}");
                      showAdressPosition();
                    }
                  )
              ),
            ),

            // TypeAheadField<Userdetails>(
            //   textFieldConfiguration: TextFieldConfiguration(
            //     decoration: InputDecoration(
            //         border: InputBorder.none, hintText: "Search for location"),
            //   ),
            //   suggestionsCallback: (pattern) {
            //     if (pattern.isEmpty) {
            //       return [];
            //     }
            //     try {
            //       List<Userdetails> u = [];
            //       for (var i in coachList) {
            //         if (i.name!.toLowerCase().contains("$pattern")) {
            //           u.add(i);
            //         }
            //       }
            //       return u;
            //     } catch (e) {
            //       return [];
            //     }
            //   },
            //   itemBuilder: (context, suggestion) {
            //     return buildCoachSearchItem(
            //         suggestion, userModel!.getUserDetails()!,
            //         sport: sports[selectedSportIndex]);
            //   },
            //   onSuggestionSelected: (suggestion) {
            //     showCoachInfoDialogue(context, suggestion);
            //   },
            //   hideOnEmpty: true,
            // ),
            // ),
          ),
        ),
        innerPadding: 0);
  }

  void showCoachBootListDialogue(context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      var c = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              // height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width,
              child: CoachBootCampListPage(
                bootCampList: bootCampList,
                coachList: coachList,
                userModel: userModel,
              ),
            ),
          );
        },
      );

      if (c == null) {
        print("Nothing returned");
      } else {
        try {
          Userdetails m = c;
          showCoachInfoDialogue(context, m);
        } catch (e) {
          showBootCampInfoDialogue(context, c);
        }
      }
    } catch (c) {
      print("errror...$c");
    }
  }
}

Widget buildColumnTexts(String t1, String t2) {
  return Column(
    children: <Widget>[
      Text(
        t1,
        style: TextStyle(
            fontSize: 16,
            fontFamily: App.font_name2,
            fontWeight: FontWeight.bold),
      ),
      Text(
        t2,
        style: TextStyle(
            fontFamily: App.font_name2,
            fontWeight: FontWeight.w100,
            fontSize: 12,
            color: Colors.grey),
      ),
    ],
  );
}

Widget priceText(price) {
  var style1 =
      TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w100);
  var style2 = TextStyle(
    fontSize: 16,
    fontFamily: App.font_name2,
    color: Color.fromRGBO(182, 9, 27, 1),
  );
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
            "£ $price",
            style: style2, //Starting at £25 / session
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
