import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";

/// A navigation bar that is used to navigate between the 3 main screens of the app.
class NavBar extends StatelessWidget {
  /// The index of the currently selected screen.
  final int _currentIndex;

  static const _routes = [
    RecipeCreationScreen.routeName,
    MainScreen.routeName,
    SettingsScreen.routeName,
  ];

  /// Creates a new navigation bar.
  const NavBar({required int currentIndex, super.key}) : _currentIndex = currentIndex;

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
          currentIndex: _currentIndex,
          onTap: (index) => {if (index != _currentIndex) Navigator.of(context).pushReplacementNamed(_routes[index])},
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(SpiceSquadIconImages.createDocument),
              label: "Create Recipe",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(SpiceSquadIconImages.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(SpiceSquadIconImages.people),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
