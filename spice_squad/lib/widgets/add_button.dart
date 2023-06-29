import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      onPressed: onPressed,
      icon: const ImageIcon(
        size: 24,
        AssetImage("assets/icons/add.png"),
        color: Color(0xFF00F5AD),
      ),
      splashRadius: 24,
    );
  }
}
