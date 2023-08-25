import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";

/// A button that is used to indicate toggling the visibility of something.
class EyeButton extends StatelessWidget {
  /// Whether the eye is open or closed.
  final bool _open;

  /// The callback that is called when the button is pressed.
  final VoidCallback _onToggle;

  /// Creates a new eye button.
  const EyeButton({required bool open, required void Function() onToggle, super.key})
      : _onToggle = onToggle,
        _open = open;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      splashRadius: 24,
      onPressed: _onToggle,
      icon: ImageIcon(
        _open ? SpiceSquadIconImages.eyeOpen : SpiceSquadIconImages.eyeClosed,
        size: 24,
      ),
    );
  }
}
