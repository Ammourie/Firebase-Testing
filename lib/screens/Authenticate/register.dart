import 'package:email_validator/email_validator.dart';
import 'package:fb_testing/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

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
  bool loading = false;
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        children: [
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
              labelText: "Name",
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
            controller: email,
            decoration: const InputDecoration(labelText: "email"),
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

          // IntlPhoneField(
          //   controller: phone,
          //   keyboardType: TextInputType.phone,
          //   decoration: const InputDecoration(
          //     labelText: "Phone",
          //   ),
          //   obscureText: true,
          // ),
          // const SizedBox(height: 20),
          loading
              ? const LoadingWidget()
              : Align(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await _authService.register(
                            email: email.text,
                            password: password.text,
                            name: name.text);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: Text(
                      "Register",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
          SizedBox(
              height: MediaQuery.of(context).size.height / 2.25 -
                  MediaQuery.of(context).viewInsets.bottom)
        ],
      ),
    );
  }
}

String? validatePassword(String? value) {
  if (value == null) return null;
  RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+');
  var passNonNullValue = value;
  if (passNonNullValue.isEmpty) {
    return ("Password is required");
  } else if (passNonNullValue.length < 6) {
    return ("Password Must be more than 5 characters");
  } else if (!regex.hasMatch(passNonNullValue)) {
    return ("Password should contain digits and characters ");
  }
  return null;
}
