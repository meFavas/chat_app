// ignore_for_file: prefer_const_constructors, empty_statements, non_constant_identifier_names, avoid_types_as_parameter_names, curly_braces_in_flow_control_structures

import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final Chatservices chatservices = Chatservices();
  final Authservice authservice = Authservice();
  void logout() {
    final auth = Authservice();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          //logout button
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Mydrawer(),
      body: builduserlist(),
    );
  }

  Widget builduserlist() {
    return StreamBuilder(
      stream: chatservices.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => builduserlistItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget builduserlistItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != authservice.getCurrentUser()) {
      return Usertile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chatpage(
                  receiverEmail: userData["email"],
                  receiverID: '',
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
