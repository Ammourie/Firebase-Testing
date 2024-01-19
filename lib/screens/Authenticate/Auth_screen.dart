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
      appBar: AppBar(
        title: const Text("Sign In"),
        actions: [
          TextButton(
              onPressed: () {
                if (login) {
                  _child = Register();
                } else {
                  _child = Login();
                }
                login = !login;
                setState(() {});
              },
              child: Text(!login ? 'Login' : "Register"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _child,
      ),
    );
  }
}
