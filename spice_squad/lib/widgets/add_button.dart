import "package:flutter/material.dart";

/// A button that is used to indicate adding something.
class AddButton extends StatelessWidget {
  /// The callback that is called when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a new add button.
  const AddButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      onPressed: onPressed,
      icon: const Icon(
        Icons.add_circle,
        size: 24,
        color: Color(0xFF00F5AD),
      ),
      splashRadius: 24,
    );
  }
}
