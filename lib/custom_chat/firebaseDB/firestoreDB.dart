import 'package:cloud_firestore/cloud_firestore.dart';

final chatCollection = 'chats';
final mesageKey = 'messages';

class FireStoreClass {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static void createChatRoom({required String chatRoomName}) async {
    final snapShot =
        await _db.collection(chatCollection).doc(chatRoomName).get();
    if (snapShot.exists) {
      await _db.collection(chatCollection).doc(chatRoomName).update({
        'chatRoomName': chatRoomName,
      });
    } else {
      await _db.collection(chatCollection).doc(chatRoomName).set(
        {'chatRoomName': chatRoomName},
      );
    }
  }

  static Future<bool> createChatRoomMessage({
    required String? chatRoomName,
    required Map message,
  }) async {
    try {
      var j = DateTime.now();

      await FirebaseFirestore.instance
          .collection(chatCollection)
          .doc("$chatRoomName/$mesageKey/$j")
          .set(message as Map<String, dynamic>)
          .catchError((e) {
        return false;
      });
      return true;
    } catch (e) {
      print("Adding messsage error...$e");
      return false;
    }
  }
}
