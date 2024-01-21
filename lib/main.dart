import 'dart:developer';

import 'package:fb_testing/Theme/Theme.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'models/user.dart';
import 'screens/Authenticate/Auth_screen.dart';
import 'screens/Home/home_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MyThemes().lightTheme,
      home: StreamProvider<UserModel>.value(
        value: AuthService().authStateChangeStream,
        catchError: (context, error) {
          log(error.toString());
          return UserModel();
        },
        initialData: UserModel(),
        child: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel>(context);

    return user.id != null ? HomeScreen() : const AuthScreen();
  }
}
