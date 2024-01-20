import 'package:email_validator/email_validator.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';

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
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: email,
            decoration: const InputDecoration(hintText: "email"),
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
            decoration: const InputDecoration(
              hintText: "password",
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          loading
              ? const LoadingWidget()
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          await _authService.login(
                            email: email.text,
                            password: password.text,
                          );
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await _authService.signInAon();
                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text(
                        "Login Anon",
                      ),
                    ),
                  ],
                ),
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
