import "package:flutter/material.dart";
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
  late final Map<FilterCategory, bool> filterMap;

  @override
  void initState() {
    // Initialize the filter map with the initial value.
    filterMap = {for (var item in FilterCategory.values) item: widget.initialValue.contains(item)};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter auswählen"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: filterMap.length,
          itemBuilder: (context, index) {
            final key = filterMap.keys.elementAt(index);
            return CheckboxListTile(
              title: Text(key.toString()),
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
      actions: <Widget>[
        TextButton(
          child: const Text("Verwerfen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Speichern"),
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
