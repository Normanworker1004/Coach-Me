import 'dart:async';

import 'package:cme/controllers/location_controller.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/map_compass.dart';
import 'package:cme/ui_widgets/textfield_with_card.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class PickLoactionPage extends StatefulWidget {
  final LatLng? currentLocation;
  final bool isBlue;

  const PickLoactionPage(
      {Key? key, required this.currentLocation, this.isBlue: false})
      : super(key: key);
  @override
  _PickLoactionPageState createState() => _PickLoactionPageState();
}

class _PickLoactionPageState extends State<PickLoactionPage> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController maPontroller;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 64,
  );
  final Map<String, Marker> _markers = {};
  List<Location> addressList = [];
  List<Placemark> placemarkList = [];


  LatLng? currentLocation;
  late bool isBlue;

  TextEditingController searchController = TextEditingController();

  FocusNode cNode = FocusNode();
  FocusNode secNode = FocusNode();

  @override
  void dispose() {
    cNode.dispose();
    secNode.dispose();
    super.dispose();
  }

  searchPlace(String text) async {
    try {
      if (text.isEmpty) {
        setState(() {
          addressList = [];
        });
      }

      print("serarch...$text");


      List<Location> addresses = await locationFromAddress(text);


      var first = addresses.first;
      print(" $text ::  ${first.latitude},${first.longitude}");

      for (Location addr in addresses) {
        await Future.delayed(Duration(seconds: 1));  //restriction from api
        var placemark =  await placemarkFromCoordinates(addr.latitude, addr.longitude);
           placemarkList.add(placemark.first);
      }

      setState(() {
        addressList = addresses;
       });
    } catch (e) {
      print("e....$e");
      setState(() {
        addressList = [];

      });
    }
  }

  @override
  void initState() {
    super.initState();
    cameraPosition = CameraPosition(
      target: widget.currentLocation ?? LatLng(51.5074, 0.1278),
      zoom: 16,
    );

    isBlue = widget.isBlue;
    secNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow,
      body: SafeArea(child: buildBody(context)),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
      markers: _markers.values.toSet(),
      onTap: (LatLng n) {
        // print("lat: ${n.latitude}  lon: ${n.longitude}");
        setState(() {
          currentLocation = n;
          _markers.clear();
          final marker = Marker(
            markerId: MarkerId("curr_loc"),
            position: LatLng(n.latitude, n.longitude),
            // infoWindow: InfoWindow(title: 'Your Location'),
          );
          _markers["Current Location"] = marker;
        });
      },
      onMapCreated: (GoogleMapController controller) {
        // _controller = controller;
        maPontroller = controller;
        _controller.complete(controller);
      },
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
    );
  }

  Widget buildBody(BuildContext context) {

    return GestureDetector(
      onTap: () {
        secNode.requestFocus();
      },
      child: Stack(
        fit: StackFit.expand,

        children: <Widget>[
          buildMap(),
          Positioned(
            // top: 16,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Card(
                        color: isBlue ? deepBlue : white,
                        elevation: 0,
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, left: 8, right: 8),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: backArrow(
                                    color: isBlue ? white : Colors.black),
                              )),
                        ),
                      ),
                      horizontalSpace(),
                      Expanded(
                        child: buildCardedTextField(
                            focusNode: cNode,
                            controller: searchController,
                            hintText: "Search for a location",
                            color: isBlue ? deepBlue : white,
                            textColor: isBlue ? white : Colors.grey,
                            onChange: (c) async {
                              setState(() {});
                              searchPlace(c);
                            },
                            onTap: () {
                              setState(() {});
                            },
                            onSubmitted: (c) {
                              secNode.requestFocus();
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
                  verticalSpace(height: 16),
                  Visibility(
                    visible: cNode.hasPrimaryFocus,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (c, i) => verticalSpace(),
                      itemCount:
                          addressList.length > 3 ? 3 : addressList.length,
                      itemBuilder: (c, index) {
                        Location a = addressList[index];
                        Placemark p = placemarkList[index];

                        return Card(
                          child: ListTile(
                            onTap: () {
                              secNode.requestFocus();

                              currentLocation = LatLng(a.latitude,
                                  a.longitude);
                              _markers.clear();
                              final marker = Marker(
                                markerId: MarkerId("curr_loc"),
                                position: currentLocation!,
                                // infoWindow: InfoWindow(title: 'Your Location'),
                              );
                              _markers["Current Location"] = marker;

                              maPontroller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: currentLocation!,
                                    tilt: 50.0,
                                    bearing: 45.0,
                                    zoom: 20.0,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            leading: Icon(Icons.location_on),
                            title: mediumText("${p.name}"),
                            subtitle: lightText("${a.latitude},${a.longitude}"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 64,
            right: 16,
            left: 16,
            child: Visibility(
              visible: !cNode.hasPrimaryFocus,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: proceedButton(
                      text: "Select Location",
                      onPressed: currentLocation == null
                          ? null
                          : () {
                              Navigator.pop(context, currentLocation);
                            },
                    ),
                  ),
                  horizontalSpace(),
                  // Spacer(),
                  InkWell(
                    onTap: () => _getLocation(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Card(
                        color: isBlue ? deepBlue : white,
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: compassIcon(
                            color:
                                isBlue ? white : Color.fromRGBO(182, 9, 27, 1),
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

  void _getLocation() async {
    // print("get location>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    // LocationPermission permission = await checkPermission();
    // if(permission.){

    // }
    LocationController locationController = Get.find<LocationController>();
    currentLocation = LatLng(locationController.lat.value, locationController.lng.value);
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });
  }
}
