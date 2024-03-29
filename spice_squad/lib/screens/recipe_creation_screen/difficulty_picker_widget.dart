import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_dialog.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// Widget for picking a difficulty
class DifficultyPickerWidget extends StatefulWidget {
  /// The initial value of the picker
  final Difficulty? _initialValue;

  /// The callback for when the value changes
  final ValueChanged<Difficulty> _onChanged;

  /// Creates a new difficulty picker widget
  const DifficultyPickerWidget({required void Function(Difficulty) onChanged, super.key, Difficulty? initialValue})
      : _onChanged = onChanged,
        _initialValue = initialValue;

  @override
  State<DifficultyPickerWidget> createState() => _DifficultyPickerWidgetState();
}

class _DifficultyPickerWidgetState extends State<DifficultyPickerWidget> {
  late Difficulty _difficulty;

  @override
  void initState() {
    super.initState();
    _difficulty = widget._initialValue ?? Difficulty.medium;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: TagItem(
        image: SpiceSquadIconImages.flame,
        name: _difficulty.getName(AppLocalizations.of(context)!),
        onTap: () => _showDifficultyPickerDialog(context),
      ),
    );
  }

  void _showDifficultyPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DifficultyPickerDialog(
          onChanged: (Difficulty value) {
            setState(() {
              _difficulty = value;
            });
            widget._onChanged(value);
          },
          initialValue: _difficulty,
        );
      },
    );
  }
}
