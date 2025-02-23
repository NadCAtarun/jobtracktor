import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final baseTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  primaryColor: Color(0xFF1B5E20),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1B5E20),
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: GoogleFonts.manrope(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.manrope(fontSize: 18, color: Colors.white),
    bodyMedium: GoogleFonts.manrope(fontSize: 16, color: Colors.white70),
    bodySmall: GoogleFonts.manrope(fontSize: 14, color: Colors.white54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2E7D32),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Color(0xFFA5D6A7)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFA5D6A7), width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4CAF50), width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    labelStyle: GoogleFonts.manrope(color: Colors.white70),
    hintStyle: GoogleFonts.manrope(color: Colors.white54),
  ),
);
