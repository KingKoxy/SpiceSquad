import 'package:flutter/material.dart';

import 'filter_category.dart';

class FilterSelectionDialog extends StatefulWidget {
  final ValueChanged<List<FilterCategory>> onChanged;
  final List<FilterCategory> selectedFilters;

  const FilterSelectionDialog(
      {super.key, required this.onChanged, required this.selectedFilters});

  @override
  State<FilterSelectionDialog> createState() => _FilterSelectionDialogState();
}

class _FilterSelectionDialogState extends State<FilterSelectionDialog> {
  late final Map<FilterCategory, bool> filterMap;

  @override
  void initState() {
    filterMap = {
      for (var item in FilterCategory.values)
        item: widget.selectedFilters.contains(item)
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter auswählen'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: filterMap.length,
            itemBuilder: (context, index) {
              var key = filterMap.keys.elementAt(index);
              return ListTile(
                title: Text(key.toString()),
                leading: Checkbox(
                  value: filterMap[key],
                  onChanged: (value) {
                    setState(() {
                      filterMap[key] = value!;
                    });
                  },
                ),
              );
            }),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Verwerfen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Speichern'),
          onPressed: () {
            Navigator.of(context).pop();

            final List<FilterCategory> selectedFilters = filterMap.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();

            widget.onChanged(selectedFilters);
          },
        ),
      ],
    );
  }
}
