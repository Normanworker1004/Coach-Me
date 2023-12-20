import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_rtc_engine/agora_rtc_local_view.dart' as RtcLocalView;
//
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cme/app.dart';
import 'package:cme/controllers/video_call_controller.dart';
import 'package:cme/custom_chat/chat_page.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/player_pages/challenge/match_up.dart';
import 'package:cme/ui_widgets/animation3.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';

import 'package:cme/network/video_call_token.dart' as v;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'settings.dart';

class VideoCallPage extends StatefulWidget {
  final String eventType;
  final String channelName;
  final String chatMessagePath;
  final String? token;
  final int? userId;
  final ClientRoleType role;
  final Function? endVirtualSession;
  final int? connectionUid;

  final DateTime sessionStartTime;

  final Userdetails? hostDetails;
  final Userdetails? audienceDetails;

  final VideoCallController videoCallController = Get.find<VideoCallController>();



   VideoCallPage({
    Key? key,
    required this.eventType,
    required this.sessionStartTime,
    required this.chatMessagePath,
    required this.hostDetails,
    required this.audienceDetails,
    required this.channelName,
    required this.role,
    required this.endVirtualSession,
    required this.token,
    required this.userId,
    this.connectionUid
  }) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  List<BNBItem> buttons = [];

  bool sessionInProgress = true;
  bool isFullScreen = false;
  bool isHost = false;

  bool hideAnimation = false;
  bool switchUser = false;

  final _users = <int>[];
  final Map<int, RtcConnection> _remoteUidsMap = {};
  final Set<RtcConnection> _localRtcConnection = {};
  RtcEngineEventHandler _agoraEventHandler = RtcEngineEventHandler();
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;

  Userdetails? hostDetails;
  Userdetails? audienceDetails;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  int totalSeconds = 60 * 60;
  final VideoCallController videoCallController = Get.find<VideoCallController>();

  @override
  void dispose() {
    _users.clear();
    _engine.unregisterEventHandler(_agoraEventHandler);
    _engine.leaveChannel();
    _stopWatchTimer.dispose();
    videoCallController.isJoined.value = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    hostDetails = widget.hostDetails;
    audienceDetails = widget.audienceDetails;

    isHost = widget.userId == hostDetails!.id;

    initialize();
    closeImage();
    initTimer();
  }

  initTimer() async {
    DateTime sesionTime = widget.sessionStartTime;
    var d = DateTime.now();
    // if (d.isBefore(sesionTime) &&  d.isBefore(sesionTime.add(Duration(hours: 1)))) {
    //   sessionInProgress = false;
    //   return;
    // }

    print("Session tile in seconds : ${sesionTime.difference(d).inSeconds}");
     _stopWatchTimer.setPresetSecondTime(sesionTime.difference(d).inSeconds *-1);
    //_stopWatchTimer.setPresetSecondTime(60*60);

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    _stopWatchTimer.secondTime.listen((value) {
      print("Valu....e: $value");
      if (value == totalSeconds) {
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        _stopWatchTimer.setPresetSecondTime(0);
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      }
    });
  }

  Widget buildTimer() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.secondTime,
      initialData: _stopWatchTimer.secondTime.value,
      builder: (context, snap) {
        print(snap.data);
        final value = snap.data!;
        var remaining = totalSeconds - value;
        var sec = (remaining % 60);
        if(remaining < -60*5){
          _onCallEnd(context);
         // session finished
        }
        var timeString = "${remaining ~/ 60}:" + (sec > 9 ? "$sec" : "0$sec");
        // timeString = "$timeString remaining (60 min session)";
        videoCallController.timerText.value = timeString;
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
                        text: videoCallController.timerText.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                          fontFamily: App.font_name2,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: " remaining (60 min session)",
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
                      TextSpan(text: '..', style: TextStyle(color: colorBlack)),
                      TextSpan(
                          text: ',,',
                          style: TextStyle(
                              color: colorActiveBtn,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
        );
      },
    );
  }

  closeImage() async {
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      hideAnimation = true;
    });
  }

  Widget callInfoButton(Userdetails u) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Visibility(
          visible: !isFullScreen,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${u.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      buildTimer(),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _onCallEnd(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.eventType == v.challengeEvent ? blue : red,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.call_end, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Display local video preview
  Widget _localPreview() {
    if (videoCallController.isJoined.value) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo(remoteUid) {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      String msg = '';
      if (videoCallController.isJoined.value) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildVideoCallBody() {
    return _viewRows();
  }

  Widget buildChallenege() {
    buttons = [
      BNBItem(
        "Chat",
        "assets/call1.png",
        page: () {
          pushRoute(
            context,
            ChatPage(
              player1Details: isHost ? hostDetails : audienceDetails,
              player2Details: !isHost ? hostDetails : audienceDetails,
              isHost: isHost,
              channelName: widget.chatMessagePath,
            ),
          );
        },
      ),
      BNBItem(
        "Off",
        "assets/call2.png",
        page: () {
          _onToggleMuteVideo();
        },
      ),
      BNBItem(
        "Mute",
        "assets/call3.png",
        page: () {
          _onToggleMute();
        },
      ),
      BNBItem("Share", "assets/call4.png"),
      BNBItem(
        "Entry Log",
        "assets/logo_solo.png",
        page: () {
          pushRoute(
              context,
              ChallengeMAtchUpPage(
                isHost: isHost,
                player1details: hostDetails,
                player2details: audienceDetails,
              ));
        },
      ),
    ];
    return Scaffold(
      body: IndexedStack(
        index: hideAnimation ? 0 : 1,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isFullScreen = !isFullScreen;
                    });
                  },
                  child: buildVideoCallBody()),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildBottomButtons(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: callInfoButton(!isHost ? hostDetails! : audienceDetails!),
              ),
            ],
          ),
          Animation3(
            player1details: isHost ? hostDetails : audienceDetails,
            player2details: !isHost ? hostDetails : audienceDetails,
          ),
        ],
      ),
    );
  }

  Widget buildBottomButtons() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.transparent.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            height: isFullScreen ? 8 : null,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    height: 8,
                    width: 32,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: isFullScreen ? 0.0 : null,
                  child: Column(
                    children: <Widget>[
                      verticalSpace(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          buttons.length,
                          (index) {
                            return InkWell(
                              onTap: buttons[index].page,
                              child: buildCallIcon(
                                  buttons[index].icon, buttons[index].title),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBuddyUp() {
    buttons = [
      BNBItem(
        "Chat",
        "assets/call1.png",
        page: () {
          pushRoute(
            context,
            ChatPage(
              player1Details: isHost ? hostDetails : audienceDetails,
              player2Details: !isHost ? hostDetails : audienceDetails,
              isHost: isHost,
              channelName: widget.chatMessagePath,
            ),
          );
        },
      ),
      BNBItem(
        "Off",
        "assets/call2.png",
        page: () {
          _onToggleMuteVideo();
        },
      ),
      BNBItem(
        "Mute",
        "assets/call3.png",
        page: () {
          _onToggleMute();
        },
      ),
      BNBItem("Share", "assets/call4.png"),
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    isFullScreen = !isFullScreen;
                  });
                },
                child: buildVideoCallBody()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildBottomButtons(),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: callInfoButton(!isHost ? hostDetails! : audienceDetails!)),
          ],
        ),
      ),
    );
  }

  Widget buildBooking() {
    buttons = [
      BNBItem(
        "Chat",
        "assets/call1.png",
        page: () {
          pushRoute(
            context,
            ChatPage(
              player1Details: isHost ? hostDetails : audienceDetails,
              player2Details: !isHost ? hostDetails : audienceDetails,
              isHost: isHost,
              channelName: widget.chatMessagePath,
            ),
          );
        },
      ),
      BNBItem(
        "Off",
        "assets/call2.png",
        page: () {
          _onToggleMuteVideo();
        },
      ),
      BNBItem(
        "Mute",
        "assets/call3.png",
        page: () {
          _onToggleMute();
        },
      ),
      BNBItem("Share", "assets/call4.png"),
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    isFullScreen = !isFullScreen;
                  });
                },
                child: buildVideoCallBody()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildBottomButtons(),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: callInfoButton(!isHost ? hostDetails! : audienceDetails!)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      GetX<VideoCallController>( builder: (controller) {  return
        widget.eventType == v.challengeEvent
            ? buildChallenege()
            : widget.eventType == v.buddyUpEvent
                ? buildBuddyUp()
                : buildBooking();
      });
  }

  Future<void> initialize() async {
    await [Permission.microphone].request();
    await [Permission.camera].request();
    videoCallController.reinit();
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    print("_initAgoraRtcEngine ok ");
       _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
   // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
  //  configuration.dimensions = VideoDimensions(width :1920, height: 1080);
   // await _engine.setVideoEncoderConfiguration(configuration);

    ChannelMediaOptions options =  ChannelMediaOptions(
      clientRoleType:  widget.role,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    print("channame :: ${widget.channelName}");
    await _engine.joinChannel(
      token:  widget.token ?? "",
      channelId: widget.channelName,
      options: options,
      uid: widget.userId!,
    );

  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
        appId: APP_ID
    ));
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    await _engine.setClientRole( role: widget.role);
    print("_initAgoraRtcEngine   ");

  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _agoraEventHandler =       RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user uid:${connection.localUid} joined the channel");
          _localRtcConnection.add(connection);
            videoCallController.isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user uid:$remoteUid joined the channel");
            setState(() {
              _users.add(remoteUid);
              if (!_localRtcConnection.any((e) => e.localUid == remoteUid)) {
                _remoteUidsMap.putIfAbsent(remoteUid, () => connection);
              }
            });

        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
            print("Remote user uid:$remoteUid left the channel");
            setState(() {
              _users.remove(remoteUid);
              _remoteUidsMap.remove(remoteUid);
            });
          },
        onLeaveChannel: (RtcConnection connection, RtcStats stats ){
            _localRtcConnection
                .removeWhere((e) => e.localUid == connection.localUid);
            _remoteUidsMap
                .removeWhere((key, value) =>
            value.localUid == connection.localUid);
            print("leaved channel");
            _users.clear();
        }
    );
    _engine.registerEventHandler( _agoraEventHandler  );

  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    // if(_isJoined == false) return [Container(color: Colors.red,)];
    final List<Widget> list = [];
    if (widget.role == ClientRoleType.clientRoleBroadcaster) {
      list.add(  _localPreview() );
    }
    _users.forEach(( value) {
      list.add( _remoteVideo(value));
    });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
          child: Column(
            children: <Widget>[_videoView(views[0])],
          ),
        );
      case 2:
        return Container(
            child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: <Widget>[
                _videoView(views[switchUser ? 0 : 1]),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    switchUser = !switchUser;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  height: 150,
                  width: 100,
                  // color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        _videoView(views[switchUser ? 1 : 0]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    // if (isHost) {
    if(widget.endVirtualSession != null)
      widget.endVirtualSession!();
    // } else {
    //   Navigator.pop(context);
    // }
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleMuteVideo() {
    _onSwitchCamera();
     setState(() {
      muted = !muted;
    });
    _engine.muteLocalVideoStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }
}

Widget buildCallIcon(
  String icon,
  String text,
) {
  return Column(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.grey, //Color.fromRGBO(124, 122, 121, 1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            icon,
            width: 28,
            height: 28,
            color: Colors.white,
          ),
        ),
      ),
      verticalSpace(),
      Text(text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ))
    ],
  );
}
