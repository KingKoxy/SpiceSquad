import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/sort.dart";
import "package:spice_squad/screens/main_screen/sort_selection_dialog.dart";

/// Widget that allows the user to select a sort.
class SortSelectionWidget extends StatelessWidget {
  /// Callback for when the sort is changed.
  final ValueChanged<Sort> onChanged;

  /// The selected sort.
  final Sort selectedSort;

  /// Creates a new sort selection widget.
  const SortSelectionWidget({required this.onChanged, required this.selectedSort, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showFilterSelectionDialog(context),
      child: Row(
        children: [
          ImageIcon(
            selectedSort.ascending ? SpiceSquadIconImages.sortAscending : SpiceSquadIconImages.sortDescending,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            selectedSort.category.getName(AppLocalizations.of(context)!),
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
          onSaved: onChanged,
          initialValue: selectedSort,
        );
      },
    );
  }
}
