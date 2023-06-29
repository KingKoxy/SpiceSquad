import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../widgets/nav_bar.dart';

class RecipeCreationScreen extends StatelessWidget {
  static const routeName = '/recipe-creation';

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
