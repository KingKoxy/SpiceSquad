import 'package:flutter/material.dart';
import 'package:spice_squad/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [Text(recipe.title, style: Theme.of(context).textTheme.headline5,),
              ],
            ),
            Row(
              children: [

              ],
            )
          ],
        ),
      ),
    );
  }
}
