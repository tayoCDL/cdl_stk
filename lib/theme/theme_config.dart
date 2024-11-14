import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Color(0xff2ca8e2);
  static Color darkAccent = Color(0xff2ca8e2);
  static Color lightBG = Color(0xffF7F8F9);
  // static Color lightBG = Color(0xffffffff);
  static Color darkBG = Color(0xff121212);
  static Color bellColor = Colors.black;
  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,

    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ), textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
  );

  static ThemeData darkTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,

    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ), textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
  );

//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     backgroundColor: darkBG,
//     primaryColor: darkPrimary,
//     accentColor: darkAccent,
//     scaffoldBackgroundColor: darkBG,
//     cursorColor: darkAccent,
//     appBarTheme: AppBarTheme(
//       elevation: 0.0,
//     ),
//   );
//
 }
