// ignore_for_file: empty_catches, prefer_const_constructors

import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Registerpage extends StatelessWidget {
  //textediting conroller of email and password
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  final void Function()? onTap;
  Registerpage({super.key, required this.onTap});
  //register method
  void register(BuildContext context) {
    final auth = Authservice();
    if (passwordcontroller.text == confirmpasswordcontroller.text) {
      try {
        auth.signUpWithEmailPassword(
          emailcontroller.text,
          passwordcontroller.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("password don't match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            Text(
              "Let's create an account for you",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 25),
            //emial textfield
            Mytextfield(
              hintText: "Email",
              obscureText: false,
              controller: emailcontroller,
            ),
            const SizedBox(height: 10),
            //password textfield
            Mytextfield(
              hintText: "Password",
              obscureText: true,
              controller: passwordcontroller,
            ),
            const SizedBox(height: 10),
            //password textfield
            Mytextfield(
              hintText: "Confirm password",
              obscureText: true,
              controller: confirmpasswordcontroller,
            ),
            const SizedBox(height: 25),
            //login button
            Mybutton(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
