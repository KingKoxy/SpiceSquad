import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/recipe_card.dart';

import '../../models/recipe.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final bool reverse;


  const RecipeList({super.key, required this.recipes, required this.reverse});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: reverse,
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }
}
