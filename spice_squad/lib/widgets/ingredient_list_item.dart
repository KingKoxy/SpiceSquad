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
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 6),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ImageIcon(
                  MemoryImage(
                    ingredient.icon,
                  ),
                  size: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 2,
                  child: AutoSizeText(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("•"),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(
                    "${(ingredient.amount * amountFactor).toStringAsFixed(2)} ${ingredient.unit}",
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(
              width: 10,
            ),
            RemoveButton(
              onPressed: onRemove!,
            )
          ],
        ],
      ),
    );
  }
}
