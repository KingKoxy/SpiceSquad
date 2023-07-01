import "package:flutter/material.dart";

/// A button that is used to indicate removing something.
class RemoveButton extends StatelessWidget {
  /// The callback that is called when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a new remove button.
  const RemoveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: const Icon(
        Icons.remove_circle,
        color: Color(0xFFFF4170),
        size: 24,
      ),
      splashRadius: 24,
    );
  }
}

