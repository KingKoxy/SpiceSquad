import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/recipe_card.dart';
import 'package:spice_squad/models/recipe.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return recipes.isNotEmpty
        ? Expanded(
          child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RecipeCard(recipe: recipes[index]),
                );
              },
            ),
        )
        : Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Es gibt leider keine Rezepte, die deinen Filterkriterien entsprechen :(",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
              ),
            ),
          );
  }
}
