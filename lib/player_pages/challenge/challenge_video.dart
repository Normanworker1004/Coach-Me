// import 'package:cme/app.dart';
// import 'package:cme/model/bnb_item.dart';
// import 'package:cme/model/fetch_challenge_booking_response.dart';
// import 'package:cme/player_pages/challenge/match_up.dart';
// import 'package:cme/player_pages/online_session/review_page.dart';
// import 'package:cme/ui_widgets/animation3.dart';
// import 'package:cme/utils/navigate_effect.dart';
// import 'package:cme/video_call/settings.dart';
// import 'package:flutter/material.dart';

// import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

// class ChallengeVideoSessionPage extends StatefulWidget {
//   final String channelName;
//   final ClientRole role;
//   final ChallengeBookingDetails bookingDetail;

//   const ChallengeVideoSessionPage({
//     Key key,
//     @required this.channelName,
//     @required this.role,
//     @required this.bookingDetail,
//   }) : super(key: key);
//   @override
//   _ChallengeVideoSessionPageState createState() =>
//       _ChallengeVideoSessionPageState();
// }

// class _ChallengeVideoSessionPageState extends State<ChallengeVideoSessionPage> {
//   List<BNBItem> buttons = [];

//   bool isFullScreen = true;

//   int pageIndex = 1;

//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   RtcEngine _engine;

//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     _engine.leaveChannel();
//     _engine.destroy();
//     super.dispose();
//   }

//   Future<void> initialize() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     // await _engine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = VideoDimensions(1920, 1080);
//     await _engine.setVideoEncoderConfiguration(configuration);
//     await _engine.joinChannel(
//       tempToken, "title", //TODO ('UPDATE CHANEL NAME')
//       // widget.channelName,
//       null,
//       null,
//     );
//   }

//   var tempToken =
//       "006b710c7b764e64a12a3805d6a56194b49IAD1ZJ2qcuyg3emUKMr3ipsjnJWnzgXyMHq+P/P/qM+dRWt4NisAAAAAEADJ+bHOlneZXwEAAQCVd5lf";

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(APP_ID);
//     await _engine.enableVideo();
//     await _engine.setChannelProfile(ChannelProfile.Communication);
//     await _engine.setClientRole(widget.role);
//   }

//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     }, joinChannelSuccess: (channel, uid, elapsed) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     }, leaveChannel: (stats) {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, userJoined: (uid, elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     }, userOffline: (uid, elapsed) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     }));
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(RtcLocalView.SurfaceView());
//     }
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }

//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return null;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//     buttons = [
//       BNBItem("Chat", "assets/call1.png"),
//       BNBItem("Off", "assets/call2.png"),
//       BNBItem("Mute", "assets/call3.png"),
//       BNBItem("Share", "assets/call4.png"),
//       BNBItem("Entry Log", "assets/call5.png", page: () {
//         pushRoute(context, ChallengeMAtchUpPage());
//       }),
//     ];
//     closeImage();
//   }

//   closeImage() async {
//     await Future.delayed(Duration(seconds: 10));
//     setState(() {
//       pageIndex = 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: pageIndex,
//         children: [
//           SafeArea(
//             child: buildBody(),
//           ),
//           Animation3(
//             player1details: null,
//             player2details: null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildBody(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           color: Colors.white,
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Wrap(
//               alignment: WrapAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Chris Smith",
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Text(
//                       "25:12 remaining (60 min session)",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w100,
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _onCallEnd(context);
//                     // pushRoute(context, SessionReviewPage());
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: blue,
//                       // Color.fromRGBO(182, 9, 27, 1), //rgba(182, 9, 27, 1)
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(Icons.call_end, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           child: Padding(
//             padding:
//                 isFullScreen ? EdgeInsets.all(0) : EdgeInsets.only(top: 72.0),
//             child: Container(
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     isFullScreen = !isFullScreen;
//                   });
//                 },
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     _viewRows(),
//                     _panel(),
//                     /*
//                     Image.asset(
//                       "assets/cp1.png",
//                       fit: BoxFit.fill,
//                     ),
//                     Positioned(
//                       top: 16,
//                       left: 16,
//                       child: Container(
//                         margin: EdgeInsets.all(0),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.white, width: 4),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         height: 150,
//                         width: 100,
//                         // color: Colors.white,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Image.asset(
//                             "assets/cp2.png",
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ),
//                     ),

//                     */
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: buildOptions(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildOptions() {
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(32), topRight: Radius.circular(32)),
//       child: Card(
//         margin: EdgeInsets.all(0),
//         color: Colors.transparent.withOpacity(.5),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.all(Radius.circular(4))),
//                   height: 8,
//                   width: 32,
//                 ),
//               ),
//               isFullScreen
//                   ? SizedBox(width: 0, height: 0)
//                   : Column(
//                       children: <Widget>[
//                         verticalSpace(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: List.generate(
//                             buttons.length,
//                             (index) => InkWell(
//                               onTap: buttons[index].page,
//                               child: buildCallIcon(
//                                   buttons[index].icon, buttons[index].title),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCallIcon(String icon, String text) {
//     return Column(
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey, //Color.fromRGBO(124, 122, 121, 1),
//             borderRadius: BorderRadius.all(Radius.circular(16)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Image.asset(
//               icon,
//               width: 28,
//               height: 28,
//             ),
//           ),
//         ),
//         verticalSpace(),
//         Text(text,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.white,
//               fontWeight: FontWeight.w100,
//             ))
//       ],
//     );
//   }
// }
