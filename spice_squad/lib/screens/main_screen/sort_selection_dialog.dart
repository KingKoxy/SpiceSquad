import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/sort.dart";
import "package:spice_squad/screens/main_screen/sort_category.dart";

/// Dialog that allows the user to select a sort.
class SortSelectionDialog extends StatefulWidget {
  /// Callback for when the sort is saved.
  final ValueChanged<Sort> _onSaved;

  /// The initially selected sort.
  final Sort _initialValue;

  /// Creates a new sort selection dialog.
  const SortSelectionDialog({required void Function(Sort) onSaved, required Sort initialValue, super.key})
      : _initialValue = initialValue,
        _onSaved = onSaved;

  @override
  State<SortSelectionDialog> createState() => _SortSelectionDialogState();
}

class _SortSelectionDialogState extends State<SortSelectionDialog> {
  late Sort _selectedSort;

  @override
  void initState() {
    super.initState();
    // Initialize the selected sort with the initial value.
    _selectedSort = widget._initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.sortSelectionDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: SortCategory.values.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                onPressed: () {
                  setState(() {
                    _selectedSort = Sort(category: _selectedSort.category, ascending: !_selectedSort.ascending);
                  });
                },
                child: ListTile(
                  title: Row(
                    children: [
                      ImageIcon(
                        _selectedSort.ascending
                            ? SpiceSquadIconImages.sortAscending
                            : SpiceSquadIconImages.sortDescending,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        _selectedSort.ascending
                            ? AppLocalizations.of(context)!.ascending
                            : AppLocalizations.of(context)!.descending,
                      ),
                    ],
                  ),
                ),
              );
            }
            final key = SortCategory.values.elementAt(index - 1);
            return RadioListTile(
              key: Key(key.getName(AppLocalizations.of(context)!)),
              title: Text(key.getName(AppLocalizations.of(context)!)),
              value: key,
              onChanged: (value) {
                setState(() {
                  _selectedSort = Sort(category: value!, ascending: _selectedSort.ascending);
                });
              },
              groupValue: _selectedSort.category,
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          key: const Key("saveSortButton"),
          child: Text(AppLocalizations.of(context)!.saveButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
            widget._onSaved(_selectedSort);
          },
        ),
      ],
    );
  }
}
