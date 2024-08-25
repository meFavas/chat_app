// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  //instance of auth and firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
//get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }
//sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
