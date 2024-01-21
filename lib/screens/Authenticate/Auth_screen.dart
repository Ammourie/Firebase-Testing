// ignore_for_file: must_be_immutable

import 'package:fb_testing/screens/Authenticate/login.dart';
import 'package:fb_testing/screens/Authenticate/register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool login = true;

  Widget _child = const Login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Sign In"),
      //   actions: [
      //     TextButton(
      //         onPressed: () {
      //           if (login) {
      //             _child = Register();
      //           } else {
      //             _child = Login();
      //           }
      //           login = !login;
      //           setState(() {});
      //         },
      //         child: Text(!login ? 'Login' : "Register"))
      //   ],
      // ),
      resizeToAvoidBottomInset: false,

      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/auth-back.png"), fit: BoxFit.cover),
        ),
        child: Column(
          // primary: false,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            Text(!login ? "Register" : "Login",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2.25,
                child: _child),
            GestureDetector(
              onTap: () {
                if (login) {
                  _child = Register();
                } else {
                  _child = Login();
                }
                login = !login;
                setState(() {});
              },
              child: Text(
                login ? "Register" : "Login",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    decoration: TextDecoration.underline, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
