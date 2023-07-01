import "package:flutter/material.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";

/// A navigation bar that is used to navigate between the 3 main screens of the app.
class NavBar extends StatelessWidget {
  /// The index of the currently selected screen.
  final int currentIndex;

  static const _routes = [
    RecipeCreationScreen.routeName,
    MainScreen.routeName,
    SettingsScreen.routeName,
  ];

  /// Creates a new navigation bar.
  const NavBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "navBar",
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => {Navigator.of(context).pushReplacementNamed(_routes[index])},
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/writing.png")),
              label: "Rezept erstellen",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/home.png")),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/user.png")),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
