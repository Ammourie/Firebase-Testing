import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            controller: email,
            decoration: const InputDecoration(hintText: "email"),
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            controller: password,
            validator: validatePassword,
            decoration: const InputDecoration(
              hintText: "password",
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            controller: name,
            validator: (s) {
              if (s != null && s.length < 5) {
                return "Name must be at least 5 letters";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Name",
            ),
          ),
          const SizedBox(height: 20),
          // IntlPhoneField(
          //   controller: phone,
          //   keyboardType: TextInputType.phone,
          //   decoration: const InputDecoration(
          //     hintText: "Phone",
          //   ),
          //   obscureText: true,
          // ),
          // const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  UserModel? user = await _authService.register(
                      email: email.text,
                      password: password.text,
                      name: name.text);
                  if (user != null) log(user.toJson().toString());
                }
              },
              child: Text(
                "Register",
                style: Theme.of(context).textTheme.titleLarge,
              )),
        ],
      ),
    );
  }
}

String? validatePassword(String? value) {
  if (value == null) return null;
  final numreg = RegExp(r'\d');
  final bigAlphareg = RegExp(r'[A-Z]');
  final smallAlpgareg = RegExp(r'[a-z]');
  if (value.length < 8) {
    return ("password should be at least 8 characters");
  } else if (value.length > 20) {
    return ("password should be no more 20 characters");
  } else if (!numreg.hasMatch(value)) {
    return ("password should have at least 1 numbers");
  } else if (!smallAlpgareg.hasMatch(value)) {
    return ("password should have at least 1 small letter");
  } else if (!bigAlphareg.hasMatch(value)) {
    return ("password should have at least 1 capital letter");
  }
  return null;
}
