import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/recipe.dart";
import "package:spice_squad/screens/main_screen/recipe_card.dart";

/// A list of recipe cards.
class RecipeList extends StatelessWidget {
  /// The recipes to show.
  final List<Recipe> recipes;

  /// Creates a new recipe list.
  const RecipeList({required this.recipes, super.key});

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
          AppLocalizations.of(context)!.noRecipesFound,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
        ),
      ),
    ),);
  }
}
