import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservices {
  //get instance of firestore & auth
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Timestamp timestamp = Timestamp.now();
  //get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendmessage(String receiverID, message) async {
    //get user info
    final String currentUserID = auth.currentUser!.uid;
    final String currentuseremail = auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newmessage = Message(
      senderID: currentUserID,
      senderEmail: currentuseremail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room ID for the two users
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatroomID = ids.join('_');

    //add messages to the database
    await firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("message")
        .add(newmessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, ottherUserID) {
    //construct chatroom ID for the two Users
    List<String> ids = [userID, ottherUserID];
    ids.sort();
    String chatroomID = ids.join('_');
    return firestore
        .collection("chat_room")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
