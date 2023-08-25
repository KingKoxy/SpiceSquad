import "package:auto_size_text/auto_size_text.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:spice_squad/models/ingredient.dart";
import "package:spice_squad/widgets/remove_button.dart";

/// A list item for displaying an ingredient.
class IngredientListItem extends StatelessWidget {
  /// The ingredient to display.
  final Ingredient _ingredient;

  /// Callback for when the ingredient is removed. If null, no remove button is displayed.
  final VoidCallback? _onRemove;

  /// The factor by which the amount of the ingredient is multiplied.
  final double _amountFactor;

  /// Creates a new ingredient list item.
  const IngredientListItem({
    required Ingredient ingredient,
    super.key,
    void Function()? onRemove,
    double amountFactor = 1,
  })  : _amountFactor = amountFactor,
        _onRemove = onRemove,
        _ingredient = ingredient;

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
                  CachedNetworkImageProvider(
                    _ingredient.iconUrl,
                  ),
                  size: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 2,
                  child: AutoSizeText(
                    _ingredient.name,
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
                    "${(_ingredient.amount * _amountFactor).toStringAsFixed(2)} ${_ingredient.unit}",
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (_onRemove != null) ...[
            const SizedBox(
              width: 10,
            ),
            RemoveButton(
              onPressed: _onRemove!,
            )
          ],
        ],
      ),
    );
  }
}
