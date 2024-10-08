// ignore_for_file: prefer_const_constructors

import 'package:chat_app/services/auth/auth_gate.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/themes/light_mode.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Authgate(),
      theme: lightmode,
    );
  }
}
