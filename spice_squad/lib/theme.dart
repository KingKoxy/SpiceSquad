import 'package:flutter/material.dart';

abstract class SpiceSquadTheme {
  static final MaterialColor _primary = createMaterialColor(0xFFFF4170);
  static final MaterialColor _background = createMaterialColor(0xFF00010F);
  static final MaterialColor _secondary = createMaterialColor(0xFF1A1A27);
  static final MaterialColor _secondaryVariant = createMaterialColor(0xFF25253D);

  static ThemeData get themeData => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _background,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: _primary).copyWith(
      brightness: Brightness.dark,
      onSurfaceVariant: _secondaryVariant,
      onSurface: _secondary
    ),
    cardColor: _secondary,
    dialogBackgroundColor: _secondary,
    appBarTheme: AppBarTheme(
      backgroundColor: _secondary
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          alignment: Alignment.center,
          padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
          textStyle: const MaterialStatePropertyAll(
            TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ))),
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _secondary,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          color: _primary,
        )
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}

//Returns a MaterialColor object based on the given color
MaterialColor createMaterialColor(int colorHex) {
  final Color color = Color(colorHex);
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
