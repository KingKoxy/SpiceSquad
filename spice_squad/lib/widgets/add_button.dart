import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";

/// A button that is used to indicate adding something.
class AddButton extends StatelessWidget {
  /// The callback that is called when the button is pressed.
  final VoidCallback _onPressed;

  /// Creates a new add button.
  const AddButton({required void Function() onPressed, super.key}) : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      onPressed: _onPressed,
      icon: const ImageIcon(
        SpiceSquadIconImages.add,
        size: 24,
        color: Color(0xFF00F5AD),
      ),
      splashRadius: 24,
    );
  }
}
