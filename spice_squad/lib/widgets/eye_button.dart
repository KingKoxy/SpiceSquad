import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";

/// A button that is used to indicate toggling the visibility of something.
class EyeButton extends StatelessWidget {
  /// Whether the eye is open or closed.
  final bool open;

  /// The callback that is called when the button is pressed.
  final VoidCallback onToggle;

  /// Creates a new eye button.
  const EyeButton({required this.open, required this.onToggle, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      splashRadius: 24,
      onPressed: onToggle,
      icon: ImageIcon(
        open ? SpiceSquadIconImages.eyeOpen : SpiceSquadIconImages.eyeClosed,
        size: 24,
      ),
    );
  }
}
