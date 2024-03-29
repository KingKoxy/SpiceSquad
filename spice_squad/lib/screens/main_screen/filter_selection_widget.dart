import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/filter_category.dart";
import "package:spice_squad/screens/main_screen/filter_selection_dialog.dart";

/// Widget that allows the user to select filters.
class FilterSelectionWidget extends StatelessWidget {
  /// Callback for when the filters are changed.
  final ValueChanged<List<FilterCategory>> _onChanged;

  /// The selected filters.
  final List<FilterCategory> _selectedFilters;

  /// Creates a new filter selection widget.
  const FilterSelectionWidget({
    required void Function(List<FilterCategory>) onChanged,
    required List<FilterCategory> selectedFilters,
    super.key,
  })  : _selectedFilters = selectedFilters,
        _onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key("filterSelectionButton"),
      onPressed: () => _showFilterSelectionDialog(context),
      child: Row(
        children: [
          const ImageIcon(
            SpiceSquadIconImages.filter,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            AppLocalizations.of(context)!.filterSelectionHandle(_selectedFilters.length),
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
        return FilterSelectionDialog(
          onSave: _onChanged,
          initialValue: _selectedFilters,
        );
      },
    );
  }
}
