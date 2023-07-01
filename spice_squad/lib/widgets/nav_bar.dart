import "package:flutter/material.dart";
import "package:spice_squad/screens/main_screen/main_screen.dart";
import "package:spice_squad/screens/recipe_creation_screen/recipe_creation_screen.dart";
import "package:spice_squad/screens/settings_screen/settings_screen.dart";

class NavBar extends StatelessWidget {
  final int currentIndex;
  static const routes = [
    RecipeCreationScreen.routeName,
    MainScreen.routeName,
    SettingsScreen.routeName,
  ];

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
            onTap: (index) =>
                {Navigator.of(context).pushReplacementNamed(routes[index])},
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
            ],),
      ),
    );
  }
}
