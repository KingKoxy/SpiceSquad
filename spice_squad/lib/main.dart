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
import 'package:spice_squad/theme.dart';

void main() {
  runApp(const SpiceSquad());
}

class SpiceSquad extends StatelessWidget {
  const SpiceSquad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceSquad',
      theme: SpiceSquadTheme.themeData,
      initialRoute: GroupJoiningScreen.routeName,
      routes: {
        MainScreen.routeName: (context) => const MainScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        PasswordResetScreen.routeName: (context) => PasswordResetScreen(),
        GroupJoiningScreen.routeName: (context) => GroupJoiningScreen(),
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
