import "package:flutter/material.dart";
import "package:spice_squad/models/difficulty.dart";

class DifficultyPickerDialog extends StatefulWidget {
  final Difficulty? initialValue;

  final ValueChanged<Difficulty> onChange;

  const DifficultyPickerDialog(
      {required this.initialValue, required this.onChange, super.key,});

  @override
  State<DifficultyPickerDialog> createState() => _DifficultyPickerDialogState();
}

class _DifficultyPickerDialogState extends State<DifficultyPickerDialog> {
  late Difficulty? difficulty;
  late ValueChanged<Difficulty> onChange;

  @override
  void initState() {
    difficulty = widget.initialValue;
    onChange = widget.onChange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Schwierigkeit auswählen"),
        content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Difficulty.values.length,
              itemBuilder: (context, index) {
                return Card(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            Difficulty.values[index].toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          selected: difficulty?.index == index,
                          tileColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          onTap: () {
                            Navigator.of(context).pop();
                            onChange(Difficulty.values[index]);
                          },
                        ),),);
              },
            ),),);
  }
}
