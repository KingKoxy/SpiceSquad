import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RemoveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: const ImageIcon(
        AssetImage("assets/icons/remove.png"),
        color: Color(0xFFFF4170),
      ),
      splashRadius: 24,
    );
  }
}

