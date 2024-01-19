import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name != null ? "Hello ${user.name}" : "Home Screen",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await _authService.logout();
              },
              child: const Text("logout"))
        ],
      ),
    );
  }
}
