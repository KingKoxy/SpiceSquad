import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/screens/main_screen/filter_category.dart";

/// Dialog for selecting filters.
class FilterSelectionDialog extends StatefulWidget {
  /// The initially selected filters.
  final List<FilterCategory> initialValue;

  /// Callback for when the filters are saved.
  final ValueChanged<List<FilterCategory>> onSave;

  /// Creates a new filter selection dialog.
  const FilterSelectionDialog({required this.initialValue, required this.onSave, super.key});

  @override
  State<FilterSelectionDialog> createState() => _FilterSelectionDialogState();
}

class _FilterSelectionDialogState extends State<FilterSelectionDialog> {
  /// A Map of the filter categories to their selected state.
  late Map<FilterCategory, bool> filterMap;

  @override
  void initState() {
    super.initState();
    // Initialize the filter map with the initial value.
    filterMap = {for (var item in FilterCategory.values) item: widget.initialValue.contains(item)};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.filterSelectionDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filterMap.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    setState(() {
                      filterMap = {for (var item in FilterCategory.values) item: false};
                    });
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        const ImageIcon(
                          SpiceSquadIconImages.clearFilters,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)!.clearFiltersButtonLabel,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final key = filterMap.keys.elementAt(index - 1);
              return CheckboxListTile(
                title: Text(key.getName(context)),
                value: filterMap[key],
                onChanged: (value) {
                  setState(() {
                    filterMap[key] = value!;
                  });
                },
              );
            },
          ),
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
          child: Text(AppLocalizations.of(context)!.saveButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();

            // Get the selected filters as list.
            final List<FilterCategory> selectedFilters =
                filterMap.entries.where((entry) => entry.value).map((entry) => entry.key).toList();

            widget.onSave(selectedFilters);
          },
        ),
      ],
    );
  }
}
