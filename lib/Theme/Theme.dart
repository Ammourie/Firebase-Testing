import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    iconTheme: const IconThemeData(size: 30),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.cairo(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.cairo(
          fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.cairo(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.cairo(fontSize: 20, color: Colors.grey),
      bodyMedium: GoogleFonts.cairo(fontSize: 17, color: Colors.grey),
      bodySmall: GoogleFonts.cairo(fontSize: 15, color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor:
          ColorScheme.fromSeed(seedColor: Colors.green).inversePrimary,
    ),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
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
  );
}
