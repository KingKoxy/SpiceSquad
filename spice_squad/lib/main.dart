import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/models/group.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/group_creation_screen.dart";
import "package:spice_squad/screens/group_detail_screen/group_detail_screen.dart";
import "package:spice_squad/screens/group_joining_screen.dart";
import "package:spice_squad/screens/ingredient_creation_screen/ingredient_creation_screen.dart";
import "package:spice_squad/screens/login_screen.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/password_reset_screen.dart";
import "package:spice_squad/screens/pdf_recipe_page.dart";
import "package:spice_squad/screens/qr_code_screen.dart";
import "package:spice_squad/screens/qr_scanner_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/recipe_detail_screen/recipe_detail_screen.dart";
import "package:spice_squad/screens/register_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";
import "package:spice_squad/screens/splash_screen.dart";
import "package:spice_squad/theme.dart";

void main() {
  runApp(const SpiceSquad());
}

/// The main widget of the app.
class SpiceSquad extends StatelessWidget {
  /// Creates a new [SpiceSquad] instance.
  const SpiceSquad({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: "SpiceSquad",
        theme: SpiceSquadTheme.themeData,
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SplashScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
            case MainScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => MainScreen(),
              );
            case LoginScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => LoginScreen(),
              );
            case RegisterScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              );
            case PasswordResetScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => PasswordResetScreen(),
              );
            case GroupJoiningScreen.routeName:
              return MaterialPageRoute(
                builder: (context) {
                  final dynamic args = settings.arguments;
                  final bool isAfterRegister = args != null && (args as bool);
                  return GroupJoiningScreen(isAfterRegister: isAfterRegister);
                },
              );
            case GroupCreationScreen.routeName:
              return MaterialPageRoute(
                builder: (context) {
                  final dynamic args = settings.arguments;
                  final bool isAfterRegister = args != null && (args as bool);
                  return GroupCreationScreen(
                    isAfterRegister: isAfterRegister,
                  );
                },
              );
            case QRScannerScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => const QRScannerScreen(),
              );
            case GroupDetailScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => GroupDetailScreen(groupId: settings.arguments as String),
              );
            case IngredientCreationScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => IngredientCreationScreen(),
              );
            case RecipeCreationScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => RecipeCreationScreen(recipe: settings.arguments as Recipe?),
              );
            case SettingsScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              );
            case QRCodeScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => QRCodeScreen(
                  group: settings.arguments as Group,
                ),
              );
            case RecipeDetailScreen.routeName:
              return MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  recipe: settings.arguments as Recipe,
                ),
              );
            case PdfRecipeViewPage.routeName:
              return MaterialPageRoute(
                builder: (context) => PdfRecipeViewPage(
                  recipe: settings.arguments as Recipe,
                ),
              );
            default:
              return null;
          }
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
