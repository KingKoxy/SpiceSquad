import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/widgets/ingredient_list_item.dart";

/// A list of ingredients.
class IngredientList extends StatelessWidget {
  /// The ingredients to display.
  final List<Ingredient> ingredients;

  /// The factor by which the amount of the ingredients is multiplied.
  final double amountFactor;

  /// Creates a new ingredient list.
  const IngredientList({required this.ingredients, required this.amountFactor, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return IngredientListItem(
            ingredient: ingredients[index],
            amountFactor: amountFactor,
          );
        },
      ),
    );
  }
}
