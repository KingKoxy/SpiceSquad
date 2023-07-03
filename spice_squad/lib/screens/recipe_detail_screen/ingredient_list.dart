import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/screens/recipe_detail_screen/ingredient_card.dart";

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientList({required this.ingredients, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: IngredientCard(
            ingredient: ingredients[index],
          ),
        );
      },
    );
  }
}
