import 'package:flutter/material.dart';

class FavouriteButton extends StatefulWidget {
  final bool value;
  final VoidCallback onToggle;

  const FavouriteButton(
      {super.key, required this.value, required this.onToggle});

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  late bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 64,
        splashRadius: 32,
        onPressed: () {
          setState(() {
            value = !value;
          });
          widget.onToggle();
        },
        icon: ImageIcon(
          AssetImage(value
              ? "assets/icons/heart_filled.png"
              : "assets/icons/heart_empty.png"),
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
