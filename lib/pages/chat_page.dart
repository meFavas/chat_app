

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  Chatpage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });
  //text controller
  final TextEditingController messagecontroller = TextEditingController();
  //chat & auth services
  final Chatservices chatservices = Chatservices();
  final Authservice authservice = Authservice();
  //send message
  void sendMessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await chatservices.sendmessage(receiverID, messagecontroller.text);
      messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessagelist(),
          ),
          builduserinput(),
        ],
      ),
    );
  }

  Widget buildMessagelist() {
    String senderID = authservice.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatservices.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        //Errors
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        //retrun listview
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => buildMessageitem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget buildMessageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool iscurrentUser = data['senderID'] == authservice.getCurrentUser()!.uid;
    var alignment =
        iscurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            iscurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Chatbubble(message: data["message"], iscurrentUser: iscurrentUser)
        ],
      ),
    );
  }

  //build message input
  Widget builduserinput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take most of the space
          Expanded(
            child: Mytextfield(
              hintText: "type a message",
              obscureText: false,
              controller: messagecontroller,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
