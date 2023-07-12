import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/difficulty.dart";

/// A dialog that lets the user pick a [Difficulty].
class DifficultyPickerDialog extends StatefulWidget {
  /// The initial value of the dialog.
  final Difficulty initialValue;

  /// The callback that is called when the user selects a value.
  final ValueChanged<Difficulty> onChanged;

  /// Creates a new [DifficultyPickerDialog].
  const DifficultyPickerDialog({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<DifficultyPickerDialog> createState() => _DifficultyPickerDialogState();
}

class _DifficultyPickerDialogState extends State<DifficultyPickerDialog> {
  late Difficulty _difficulty;

  @override
  void initState() {
    _difficulty = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.selectDifficultyHeadline),
      content: SingleChildScrollView(
        child: Column(
          children: [
            RadioListTile(
              title: Text(Difficulty.easy.getName(context)),
              value: Difficulty.easy,
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            RadioListTile(
              title: Text(Difficulty.medium.getName(context)),
              value: Difficulty.medium,
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            RadioListTile(
              title: Text(Difficulty.hard.getName(context)),
              value: Difficulty.hard,
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            widget.onChanged(_difficulty);
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.saveButtonLabel),
        )
      ],
    );
  }
}
