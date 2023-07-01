import "package:flutter/material.dart";
import "package:spice_squad/screens/main_screen/filter_category.dart";

class FilterSelectionDialog extends StatefulWidget {
  final ValueChanged<List<FilterCategory>> onChanged;
  final List<FilterCategory> selectedFilters;

  const FilterSelectionDialog({required this.onChanged, required this.selectedFilters, super.key});

  @override
  State<FilterSelectionDialog> createState() => _FilterSelectionDialogState();
}

class _FilterSelectionDialogState extends State<FilterSelectionDialog> {
  late final Map<FilterCategory, bool> filterMap;

  @override
  void initState() {
    filterMap = {for (var item in FilterCategory.values) item: widget.selectedFilters.contains(item)};
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
            },),
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

            final List<FilterCategory> selectedFilters =
                filterMap.entries.where((entry) => entry.value).map((entry) => entry.key).toList();

            widget.onChanged(selectedFilters);
          },
        ),
      ],
    );
  }
}
