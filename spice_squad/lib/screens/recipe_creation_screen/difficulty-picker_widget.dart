import "package:flutter/material.dart";
import "package:spice_squad/models/difficulty.dart";
import "package:spice_squad/screens/recipe_creation_screen/difficulty_picker_diaglog.dart";

class DifficultyPickerWidget extends StatefulWidget {

  final Difficulty? difficulty;

  const DifficultyPickerWidget({super.key, this.difficulty});

  @override
  State<DifficultyPickerWidget> createState() => _DifficultyPickerWidgetState();
}

class _DifficultyPickerWidgetState extends State<DifficultyPickerWidget> {

  late Difficulty? _difficulty;

  @override
  void initState() {
    _difficulty = widget.difficulty ?? Difficulty.medium;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        child: TextButton(
        onPressed: () => _showDifficultyPickerDialog(context),
        child: Card(
          //color: Theme.of(context).colorScheme.onSurfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/flame.png"),
                const SizedBox(width: 8),
                Text(_difficulty.toString(), style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,)
              ],
            ),
          ),
        ),),);
  }


  void _showDifficultyPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DifficultyPickerDialog(
          onChange: (Difficulty value) {
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
