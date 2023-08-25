import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";

/// A button that is used to indicate toggling the favourite status of something.
class FavouriteButton extends StatelessWidget {
  /// Whether the item is a favourite or not.
  final bool _value;

  /// The callback that is called when the button is pressed.
  final VoidCallback _onToggle;

  /// Creates a new favourite button.
  const FavouriteButton({
    required bool value,
    required void Function() onToggle,
    super.key,
  })  : _onToggle = onToggle,
        _value = value;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("favouriteButton"),
      padding: EdgeInsets.zero,
      iconSize: 40,
      splashRadius: 32,
      onPressed: _onToggle,
      icon: ImageIcon(
        _value ? SpiceSquadIconImages.heartFilled : SpiceSquadIconImages.heartEmpty,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
