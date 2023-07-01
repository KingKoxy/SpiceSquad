import "package:flutter/material.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/widgets/nav_bar.dart";

/// Screen for creating a new recipe
class RecipeCreationScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = "/recipe-creation";

  /// Creates a new recipe creation screen
  const RecipeCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Recipe? recipe = ModalRoute.of(context)?.settings.arguments as Recipe?;
    //If recipe!=null fill with recipe data and overwrite on save

    return Scaffold(
      appBar: AppBar(title: const Text("Rezept erstellen")),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
