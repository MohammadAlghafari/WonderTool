import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wonder_tool/themes/colors.dart';

ThemeData myCustomeTheme = ThemeData(
  primarySwatch: primaryColorSwatch,
  scaffoldBackgroundColor: secondColor,
  fontFamily: 'SFProDisplay',
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: secondColor,
      backgroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
  ),
);
