import "package:flutter/material.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_diaglog.dart";
import "package:spice_squad/widgets/tag_item.dart";

class DifficultyPickerWidget extends StatefulWidget {
  final Difficulty? initialValue;

  const DifficultyPickerWidget({super.key, this.initialValue});

  @override
  State<DifficultyPickerWidget> createState() => _DifficultyPickerWidgetState();
}

class _DifficultyPickerWidgetState extends State<DifficultyPickerWidget> {
  late Difficulty _difficulty;

  @override
  void initState() {
    _difficulty = widget.initialValue ?? Difficulty.medium;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: InkWell(
        child: TagItem(image: const AssetImage("assets/icons/flame.png"), name: _difficulty!.toString()),
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
          },
          initialValue: _difficulty,
        );
      },
    );
  }
}
