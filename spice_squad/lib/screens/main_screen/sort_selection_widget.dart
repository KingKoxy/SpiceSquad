import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/sort.dart";
import "package:spice_squad/screens/main_screen/sort_selection_dialog.dart";

/// Widget that allows the user to select a sort.
class SortSelectionWidget extends StatelessWidget {
  /// Callback for when the sort is changed.
  final ValueChanged<Sort> _onChanged;

  /// The selected sort.
  final Sort _selectedSort;

  /// Creates a new sort selection widget.
  const SortSelectionWidget({required void Function(Sort) onChanged, required Sort selectedSort, super.key})
      : _selectedSort = selectedSort,
        _onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showFilterSelectionDialog(context),
      child: Row(
        children: [
          ImageIcon(
            _selectedSort.ascending ? SpiceSquadIconImages.sortAscending : SpiceSquadIconImages.sortDescending,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            _selectedSort.category.getName(AppLocalizations.of(context)!),
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }

  void _showFilterSelectionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortSelectionDialog(
          onSaved: _onChanged,
          initialValue: _selectedSort,
        );
      },
    );
  }
}
