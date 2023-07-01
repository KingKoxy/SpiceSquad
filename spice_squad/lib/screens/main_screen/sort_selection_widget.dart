import "package:flutter/material.dart";
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
            selectedSort.ascending
                ? const AssetImage("assets/icons/sortAscending.png")
                : const AssetImage("assets/icons/sortDescending.png"),
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            selectedSort.category.toString(),
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
