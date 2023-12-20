import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cme/app.dart';
import 'package:cme/custom_chat/firebaseDB/firestoreDB.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/payment/payment_edit_card_page.dart';
import 'package:cme/ui_widgets/chat_message_widgets.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Userdetails? player1Details;
  final Userdetails? player2Details;
  final String channelName;

  final bool isChallenge;
  final bool? isHost;

  const ChatPage({
    Key? key,
    required this.player1Details,
    required this.player2Details,
    this.isHost,
    this.isChallenge: false,
    required this.channelName,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Userdetails? myDetails;
  Userdetails? otherDetails;
  String? channelName;
  late bool isChallenge;
  bool isOnline = false;
  List<Message> messagesList = [];

  final databaseReference = FirebaseFirestore.instance;

  TextEditingController chatMessagecontroller = TextEditingController();


  @override
  void initState() {
    super.initState();
    myDetails = widget.player1Details;
    otherDetails = widget.player2Details;
    channelName = widget.channelName;
    isChallenge = widget.isChallenge;
    // dbChangeListen();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

  }
  @override
  void dispose() {
    super.dispose();
  }

  void sendMessage() async {
    print("Send message...");
    var text = chatMessagecontroller.text;
    Message m = Message(
      message: text,
      time: DateTime.now().microsecond,
      userid: "${myDetails!.id}",
    );
    // messagesList.insert(0, m);
    chatMessagecontroller.clear();

    setState(() {});
    if (text.isEmpty) {
      return;
    }
    try {
      bool sent = await FireStoreClass.createChatRoomMessage(
          chatRoomName: channelName, message: m.toJson());
      print("response.....$sent");
      setState(() {});
    } catch (e) {
      print("Eror..$e");
     //log('Send channel message error: ' + errorCode.toString());
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isChallenge ? Color.fromRGBO(10, 27, 59, 1) : Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 72, 16, 0),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: databaseReference
                            .collection(
                                '$chatCollection/$channelName/$mesageKey')
                            // .orderBy("time", descending: true)
                            .snapshots(includeMetadataChanges: true),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot == null) {
                            return Container(
                              height: 400,
                              child: Center(
                                child: mediumText("No messages"),
                              ),
                            );
                          } else {
                            if (snapshot.data == null) {
                              return Container(
                                height: 400,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            print("Add....${snapshot.data!.docs}");
                            messagesList.clear();
                            for (var item in snapshot.data!.docs) {
                              var m = Message.fromJson(item.data() as Map<String, dynamic>);
                              messagesList.insert(0, m);
                            }
                            print("Add....${messagesList.length}");
                            // setState(() {});
                            return ListView.separated(
                              reverse: true,
                              itemCount: messagesList.length,
                              itemBuilder: (co, index) {
                                var m = messagesList[index];
                                return "${m.userid}" == "${otherDetails!.id}"
                                    ? MessageRecievedWidget(text: m.message)
                                    : MessageSentWidget(text: m.message);
                              },
                              separatorBuilder: (c, index) => verticalSpace(),
                            );
                          }
                        }),
                  ),
                  verticalSpace(),
                  buildChatInputField(
                    "Enter message",
                    onChanged: (c) {},
                    controller: chatMessagecontroller,
                    onSend: () => sendMessage(),
                  )
                ],
              ),
            ),
            buildAppBar(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 24,
            spreadRadius: 32)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Card(
          color: isChallenge ? Colors.black : null,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back,
                        color: isChallenge ? Colors.white : Colors.black)),
                horizontalSpace(),
                CircularNetworkImage(
                  imageUrl: "${photoUrl + otherDetails!.profilePic!}",
                ),
                horizontalSpace(),
                Expanded(
                  child: Text(
                    "${otherDetails!.name}",
                    style: TextStyle(
                      color: isChallenge ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void dbChangeListen() {
  //   try {
  //     databaseReference
  //         .collection('$chatCollection/$channelName/messages')
  //         .orderBy("time", descending: true)
  //         .snapshots()
  //         .handleError((e) {
  //       print("error occured....$e");
  //     }).listen((result) {
  //       // Listens to update in appointment collection

  //       print("deb...$result");
  //       messagesList.clear();
  //       result.documents.forEach((result) {
  //         var m = Message.fromJson(result.data);
  //         print("Add..m");
  //         messagesList.add(m);
  //         // messagesList.insert(0, m);
  //       });
  //     });
  //   } catch (e) {
  //     print("Erroe getting snap....$e");
  //   }
  // }
}

class Message {
  String? message;
  int? time;
  String? userid;

  Message({
    this.message,
    this.time,
    this.userid,
  });
  Message.fromJson(Map<String, dynamic> json) {
    message = json['message']; //.cast<String>();
    userid = json['userid']; //.cast<String>();
    time = json['time']; //.cast<int>();
  }

  toJson() {
    return {
      "message": message,
      "time": time,
      "userid": userid,
    };
  }
}

/* 
                    ListView(
                      children:
                      
                      
                       <Widget>[
                        verticalSpace(height: 72),
                        // ChatDateWidget(),
                        MessageRecievedWidget(),
                        MessageSentWidget(),
                        Spacer(),
                      ],
                    ),*/

String generateChatRoomName({
  required chatType,
  required player1OrCoach1d,
  required player2Id,
  required bookingId,
}) {
  return "chat_${chatType}_${player1OrCoach1d}_${player2Id}_booking$bookingId";
}
