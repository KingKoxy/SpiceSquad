import 'package:flutter/material.dart';

class EyeButton extends StatelessWidget {
  final bool open;
  final VoidCallback onToggle;

  const EyeButton({super.key, required this.open, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 32,
        splashRadius: 24,
        onPressed: () {
          onToggle();
        },
        icon: ImageIcon(
          size: 32,
          AssetImage(open
              ? "assets/icons/eye_open.png"
              : "assets/icons/eye_closed.png"),
        ));
  }
}
