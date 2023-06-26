import 'package:flutter/material.dart';

class FavouriteButton extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;

  const FavouriteButton(
      {super.key, required this.value, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 64,
        splashRadius: 32,
        onPressed: () => onToggle(),
        icon: ImageIcon(
          AssetImage(value
              ? "assets/icons/heart_filled.png"
              : "assets/icons/heart_empty.png"),
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
