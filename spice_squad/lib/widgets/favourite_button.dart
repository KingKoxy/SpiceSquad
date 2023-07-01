import "package:flutter/material.dart";

/// A button that is used to indicate toggling the favourite status of something.
class FavouriteButton extends StatelessWidget {
  /// Whether the item is a favourite or not.
  final bool value;
  /// The callback that is called when the button is pressed.
  final VoidCallback onToggle;

  /// Creates a new favourite button.
  const FavouriteButton(
      {required this.value, required this.onToggle, super.key,});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 64,
        splashRadius: 32,
        onPressed: onToggle,
        icon: ImageIcon(
          AssetImage(value
              ? "assets/icons/heart_filled.png"
              : "assets/icons/heart_empty.png",),
          color: Theme.of(context).colorScheme.primary,
        ),);
  }
}
