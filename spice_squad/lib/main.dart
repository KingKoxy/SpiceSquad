import 'package:flutter/material.dart';
import 'package:spice_squad/screens/group_creation_screen.dart';
import 'package:spice_squad/screens/group_detail_screen/group_detail_screen.dart';
import 'package:spice_squad/screens/group_joining_screen.dart';
import 'package:spice_squad/screens/ingredient_creation_screen/ingredient_creation_screen.dart';
import 'package:spice_squad/screens/login_screen.dart';
import 'package:spice_squad/screens/main_screen/main_screen.dart';
import 'package:spice_squad/screens/password_reset_screen.dart';
import 'package:spice_squad/screens/qr_code_screen.dart';
import 'package:spice_squad/screens/qr_scanner_screen.dart';
import 'package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart';
import 'package:spice_squad/screens/recipe_detail_screen.dart';
import 'package:spice_squad/screens/register_screen.dart';
import 'package:spice_squad/screens/settings_screen/settings_screen.dart';

void main() {
  runApp(const SpiceSquad());
}

class SpiceSquad extends StatelessWidget {
  const SpiceSquad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceSquad',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: createMaterialColor(0xFF00010F),
        fontFamily: 'Poppins',
        primarySwatch: createMaterialColor(0xFFFF4170),
        textTheme: const TextTheme(
          headline4: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          subtitle1: TextStyle(
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
          fillColor: createMaterialColor(0xFF1A1A27),
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
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
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        MainScreen.routeName: (context) => const MainScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        PasswordResetScreen.routeName: (context) => const PasswordResetScreen(),
        GroupJoiningScreen.routeName: (context) => const GroupJoiningScreen(),
        GroupCreationScreen.routeName: (context) => const GroupCreationScreen(),
        QRScannerScreen.routeName: (context) => const QRScannerScreen(),
        GroupDetailScreen.routeName: (context) => const GroupDetailScreen(),
        IngredientCreationScreen.routeName: (context) =>
            const IngredientCreationScreen(),
        RecipeCreationScreen.routeName: (context) =>
            const RecipeCreationScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        QRCodeScreen.routeName: (context) => const QRCodeScreen(),
        RecipeDetailScreen.routeName: (context) => const RecipeDetailScreen(),
      },
    );
  }
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
