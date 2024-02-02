import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:fb_testing/services/notification_service.dart';
import 'register.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/loading_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  bool obscure = true;

  final AuthService _authService = AuthService();
  // final NotificationService _notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: email,
            decoration: const InputDecoration(labelText: "email"),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            validator: (value) {
              if (value != null) {
                if (EmailValidator.validate(value)) {
                  {
                    return null;
                  }
                } else {
                  return "enter a valid email";
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: password,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            validator: validatePassword,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: Icon(obscure ? Icons.visibility : Icons.visibility_off),
              ),
              labelText: "password",
            ),
            obscureText: obscure,
          ),
          const SizedBox(height: 20),
          loading
              ? const LoadingWidget()
              : Align(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await _authService.login(
                          email: email.text,
                          password: password.text,
                        );
                        // await _notificationService.requestPermissions();
                        // await _notificationService.getToken();
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
          SizedBox(
              height: min(
                  MediaQuery.of(context).size.height / 2.25 -
                      MediaQuery.of(context).viewInsets.bottom,
                  MediaQuery.of(context).viewInsets.bottom))
        ],
      ),
    );
  }
}
