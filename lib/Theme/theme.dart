import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static MaterialColor primaryColor = Colors.deepPurple;
  ThemeData lightTheme = ThemeData(
    canvasColor: Colors.grey.shade50,
    dividerColor: Colors.grey.shade200,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    iconTheme: const IconThemeData(size: 30),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.cairo(
          fontSize: 30, color: primaryColor, fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.cairo(
          fontSize: 22, color: primaryColor, fontWeight: FontWeight.w700),
      titleSmall: GoogleFonts.cairo(
          fontSize: 15, color: primaryColor, fontWeight: FontWeight.w700),
      bodyLarge: GoogleFonts.cairo(fontSize: 20, color: Colors.grey),
      bodyMedium: GoogleFonts.cairo(fontSize: 17, color: Colors.grey),
      bodySmall: GoogleFonts.cairo(fontSize: 15, color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(size: 30, color: primaryColor),
      backgroundColor:
          ColorScheme.fromSeed(seedColor: primaryColor).inversePrimary,
    ),
    useMaterial3: true,
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      filled: true,
      fillColor: primaryColor.shade50.withOpacity(0.5),
      suffixIconColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.focused) ? primaryColor : Colors.grey),
      prefixIconColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.focused) ? primaryColor : Colors.grey),
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
