import 'package:flutter/material.dart';
import 'package:material_color_generator/material_color_generator.dart'
    as generate_color;
import 'package:todo_app_hive/utilities/constant.dart';

class CustomTheme {
  static ThemeData get lightMode => _lightMode;
  static ThemeData get darkMode => _darkMode;
  static final ThemeData _lightMode = ThemeData(
    colorScheme: const ColorScheme.light(),
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kLightBlue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kLightBlue),
      ),
    ),
  );
  static final ThemeData _darkMode = ThemeData(
    colorScheme: const ColorScheme.dark(),
    scaffoldBackgroundColor: kGreyBlue,
    primarySwatch: generate_color.generateMaterialColor(
      color: kLightBlue,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kLightBlue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kLightBlue),
      ),
    ),
  );
}
