import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";

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
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(10),
        2: FlexColumnWidth(),
      },
      children: [
        for (final Ingredient ingredient in ingredients)
          TableRow(
            children: [
              TableCell(
                child: Text(
                  "${(ingredient.amount * amountFactor).toStringAsFixed(2)} ${ingredient.unit}",
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(),
              TableCell(
                child: Text(
                  ingredient.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
