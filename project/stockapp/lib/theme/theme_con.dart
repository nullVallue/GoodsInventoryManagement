import 'package:flutter/material.dart';

// light colour scheme
ColorScheme lightScheme = const ColorScheme(
    primary: Color(0xFFda3e60),
    // secondary: Color(0xFFa9efe0),
    secondary: Color.fromARGB(255, 243, 240, 237),
    tertiary: Color(0xFFab213f),
    surface: Color(0xFFE2E7E6),
    background: Color(0xFFfbfefd),
    error: Colors.redAccent,
    errorContainer: Color(0xff5cbab3), // on success
    onPrimary: Colors.white,
    onSecondary: Color(0xFF07221c),
    onTertiary: Colors.white,
    onTertiaryContainer: Color(0xFF7D8C89), //colour for subtitles
    onSurface: Color(0xFF07221c),
    onBackground: Color(0xFF07221c),
    onError: Colors.white,
    brightness: Brightness.light);

// dark colour scheme
ColorScheme darkScheme = const ColorScheme(
    primary: Color(0xFFc12547),
    secondary: Color.fromARGB(255, 20, 19, 17),
    // secondary: Color(0xFF105647),
    tertiary: Color(0xFFde5472),
    surface: Color(0xFF0D1110),
    background: Color(0xFF010403),
    error: Colors.redAccent,
    // errorContainer: Colors.greenAccent, // on success
    errorContainer: Color(0xff5cbab3), // on success
    onPrimary: Color(0xFFddf8f2),
    onSecondary: Color(0xFFddf8f2),
    onTertiary: Colors.black,
    onTertiaryContainer: Color(0xFF73827f), //colour for subtitles
    onSurface: Color(0xFFddf8f2),
    onBackground: Color(0xFFddf8f2),
    onError: Colors.white,
    brightness: Brightness.dark);

// light theme data
ThemeData lightTheme = ThemeData(colorScheme: lightScheme);

// dark theme data
ThemeData darkTheme = ThemeData(colorScheme: darkScheme);

// text styles
// headings
//h1
const double h1s = 40;
const FontWeight h1w = FontWeight.w500;

//h2
const double h2s = 32;
const FontWeight h2w = FontWeight.w500;
  
//h3
const double h3s = 24;
const FontWeight h3w = FontWeight.w500;

//h4
const double h4s = 20;
const FontWeight h4w = FontWeight.w500;

// subtitles
// sub1
const double sub1s = 30;
const FontWeight sub1w = FontWeight.w400;

// sub2
const double sub2s = 22;
const FontWeight sub2w = FontWeight.w400;

// sub3
const double sub3s = 18;
const FontWeight sub3w = FontWeight.w400;

// sub4
const double sub4s = 14;
const FontWeight sub4w = FontWeight.w400;

// Normal text 
// n1
const double n1s = 20;
const FontWeight n1w = FontWeight.w500;

// n2
const double n2s = 16;
const FontWeight n2w = FontWeight.w500;

// n3
const double n3s = 14;
const FontWeight n3w = FontWeight.w500;

// Label text 
// l1
const double l1s = 20;
const FontWeight l1w = FontWeight.w500;
const double l1Space = 1;

// l2
const double l2s = 16;
const FontWeight l2w = FontWeight.w500;
const double l2Space = 1;

// l3
const double l3s = 14;
const FontWeight l3w = FontWeight.w500;
const double l3Space = 1;