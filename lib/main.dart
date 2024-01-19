import 'dart:developer';

import 'package:fb_testing/firebase_options.dart';
import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/screens/Authenticate/Auth_screen.dart';
import 'package:fb_testing/screens/Home/home_screen.dart';
import 'package:fb_testing/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.cairo(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor:
              ColorScheme.fromSeed(seedColor: Colors.green).inversePrimary,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
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
