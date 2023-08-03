import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/models/difficulty.dart";

/// A dialog that lets the user pick a [Difficulty].
class DifficultyPickerDialog extends StatefulWidget {
  /// The initial value of the dialog.
  final Difficulty _initialValue;

  /// The callback that is called when the user selects a value.
  final ValueChanged<Difficulty> _onChanged;

  /// Creates a new [DifficultyPickerDialog].
  const DifficultyPickerDialog({
    required Difficulty initialValue,
    required void Function(Difficulty) onChanged,
    super.key,
  })  : _onChanged = onChanged,
        _initialValue = initialValue;

  @override
  State<DifficultyPickerDialog> createState() => _DifficultyPickerDialogState();
}

class _DifficultyPickerDialogState extends State<DifficultyPickerDialog> {
  late Difficulty _difficulty;

  @override
  void initState() {
    super.initState();
    _difficulty = widget._initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.selectDifficultyHeadline),
      content: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            RadioListTile(
              title: Text(Difficulty.easy.getName(AppLocalizations.of(context)!)),
              value: Difficulty.easy,
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            RadioListTile(
              title: Text(Difficulty.medium.getName(AppLocalizations.of(context)!)),
              value: Difficulty.medium,
              groupValue: _difficulty,
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            RadioListTile(
              title: Text(Difficulty.hard.getName(AppLocalizations.of(context)!)),
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
            widget._onChanged(_difficulty);
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.saveButtonLabel),
        )
      ],
    );
  }
}
