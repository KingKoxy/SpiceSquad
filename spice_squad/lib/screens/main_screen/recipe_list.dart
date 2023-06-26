import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/recipe_card.dart';
import 'package:spice_squad/models/recipe.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RecipeCard(recipe: recipes[index]),
        );
      },
    );
  }
}
