import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/widgets/remove_button.dart";

/// A list item for displaying an ingredient.
class IngredientListItem extends StatelessWidget {
  /// The ingredient to display.
  final Ingredient ingredient;

  /// Callback for when the ingredient is removed. If null, no remove button is displayed.
  final VoidCallback? onRemove;

  /// The factor by which the amount of the ingredient is multiplied.
  final double amountFactor;

  /// Creates a new ingredient list item.
  const IngredientListItem({required this.ingredient, super.key, this.onRemove, this.amountFactor = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.memory(
                    ingredient.icon,
                    color: Colors.white,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("•"),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${(ingredient.amount * amountFactor).toStringAsFixed(2)} ${ingredient.unit}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          if (onRemove != null)
            RemoveButton(
              onPressed: onRemove!,
            ),
        ],
      ),
    );
  }
}
