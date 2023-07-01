import "package:flutter/material.dart";

class RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RemoveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: const ImageIcon(
        AssetImage("assets/icons/remove.png"),
        color: Color(0xFFFF4170),
        size: 24,
      ),
      splashRadius: 24,
    );
  }
}

