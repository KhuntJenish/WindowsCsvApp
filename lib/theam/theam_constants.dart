import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


// todo: add theam constants Common Color
const kBLACK = Colors.black;
const kWHITE = Colors.white;


///  Light Theam Constants
// const lCOLOR_PRIMARY = Color(0xFF312C51);
// const lCOLOR_ACCENT = Color(0xFF48426D);   //312C51   // 48426D
const lCOLOR_PRIMARY = Colors.deepPurple;
const lCOLOR_ACCENT = Colors.deepPurpleAccent;

///  Dark Theam Constants
const dCOLOR_PRIMARY = Colors.white;
const dCOLOR_ACCENT = Colors.white70;

// TODO: LightTheam
ThemeData lightTheam = ThemeData(
  brightness: Brightness.light,
  primarySwatch: lCOLOR_PRIMARY,
  primaryColor: lCOLOR_PRIMARY,
  textTheme: TextTheme(
    bodyText1: GoogleFonts.inter(
      color: kBLACK,
      fontWeight: FontWeight.bold,
    ),
    headline4: GoogleFonts.padauk(
      color: kBLACK,
      fontWeight: FontWeight.bold,
      fontSize: Get.width * 0.08,
    ),
    headline6: GoogleFonts.andika(
      color: kBLACK,
      // fontWeight: FontWeight.,
      fontSize: Get.width * 0.0,
    ),
  ),

  //**lighttheam Floting Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lCOLOR_ACCENT,
  ),

  //**lightTheam Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  ),

  //**lightTheam textfield Theme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.2),
  ),
);

// TODO: DarkTheam
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
   textTheme: TextTheme(
    bodyText1: GoogleFonts.inter(
      color: kWHITE,
      fontWeight: FontWeight.bold,
    ),
    headline4: GoogleFonts.padauk(
      color: kWHITE,
      fontWeight: FontWeight.bold,
      fontSize: Get.width * 0.08,
    ),
    headline6: GoogleFonts.andika(
      color: kWHITE,
      // fontWeight: FontWeight.,
      fontSize: Get.width * 0.05,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: dCOLOR_PRIMARY,
    secondary: dCOLOR_ACCENT,
    surface: kBLACK,
    background: kBLACK,
    error: kBLACK,
    onPrimary: kBLACK,
    onSecondary: kBLACK,
    onSurface: kBLACK,
    onBackground: kBLACK,
    onError: kBLACK,
  ),

  // **darkMode Textfield Theme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.2),
  ),

  // ** darkmode button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  ),

  //**  darkmode appBarTheme
  appBarTheme: const AppBarTheme(
    foregroundColor:kWHITE,
    titleTextStyle: TextStyle(
      color:kWHITE,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
