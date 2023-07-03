import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientCard({required this.ingredient, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 8),
      FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
              width: 100,
              child: Text(
                "${ingredient.amount.toString()} ${ingredient.unit}",
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge,
              ),),),
      const SizedBox(width: 8),
      FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            ingredient.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),),
    ],);
  }
}
