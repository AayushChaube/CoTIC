import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: lightColorScheme.background,
    colorScheme: lightColorScheme,
    textTheme: _lightTextTheme,
    fontFamily: GoogleFonts.dmSans().fontFamily,
    focusColor: _lightFocusColor,
    appBarTheme: lightAppBarTheme,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF0056D2),
    primaryVariant: Color(0xFF04BF55),
    secondary: Color(0xFFEFF3F3),
    secondaryVariant: Color(0xFFFAFBFB),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0.0,
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: TextStyle(color: Colors.black),
    headline2: TextStyle(color: Colors.black),
    headline3: TextStyle(color: Colors.black),
    headline4: TextStyle(color: Colors.black),
    headline5: TextStyle(color: Colors.black),
    headline6: TextStyle(color: Colors.black),
    subtitle1: TextStyle(fontSize: 18, color: Colors.black),
    subtitle2: TextStyle(color: Colors.black),
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.black),
  );
}
