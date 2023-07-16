import "package:flutter/material.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_dialog.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// Widget for picking a difficulty
class DifficultyPickerWidget extends StatefulWidget {
  /// The initial value of the picker
  final Difficulty? initialValue;

  /// The callback for when the value changes
  final ValueChanged<Difficulty> onChanged;

  /// Creates a new difficulty picker widget
  const DifficultyPickerWidget({required this.onChanged, super.key, this.initialValue});

  @override
  State<DifficultyPickerWidget> createState() => _DifficultyPickerWidgetState();
}

class _DifficultyPickerWidgetState extends State<DifficultyPickerWidget> {
  late Difficulty _difficulty;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.initialValue ?? Difficulty.medium;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: InkWell(
        child: TagItem(
          margin: EdgeInsets.zero,
          image: SpiceSquadIconImages.flame,
          name: _difficulty.getName(context),
        ),
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
            widget.onChanged(value);
          },
          initialValue: _difficulty,
        );
      },
    );
  }
}
