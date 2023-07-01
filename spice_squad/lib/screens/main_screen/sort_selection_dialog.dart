import "package:flutter/material.dart";
import "package:spice_squad/screens/main_screen/sort.dart";
import "package:spice_squad/screens/main_screen/sort_category.dart";

/// Dialog that allows the user to select a sort.
class SortSelectionDialog extends StatefulWidget {
  /// Callback for when the sort is saved.
  final ValueChanged<Sort> onSaved;

  /// The initially selected sort.
  final Sort initialValue;

  /// Creates a new sort selection dialog.
  const SortSelectionDialog({required this.onSaved, required this.initialValue, super.key});

  @override
  State<SortSelectionDialog> createState() => _SortSelectionDialogState();
}

class _SortSelectionDialogState extends State<SortSelectionDialog> {
  late Sort selectedSort;

  @override
  void initState() {
    // Initialize the selected sort with the initial value.
    selectedSort = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Sortierung auswählen"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: SortCategory.values.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TextButton(
                onPressed: () {
                  setState(() {
                    selectedSort = Sort(category: selectedSort.category, ascending: !selectedSort.ascending);
                  });
                },
                child: ListTile(
                  title: Row(
                    children: [
                      ImageIcon(
                        selectedSort.ascending
                            ? const AssetImage("assets/icons/sortAscending.png")
                            : const AssetImage("assets/icons/sortDescending.png"),
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        selectedSort.ascending ? "Aufsteigend" : "Absteigend",
                      ),
                    ],
                  ),
                ),
              );
            }
            final key = SortCategory.values.elementAt(index - 1);
            return RadioListTile(
              title: Text(key.toString()),
              value: key,
              onChanged: (value) {
                setState(() {
                  selectedSort = Sort(category: value!, ascending: selectedSort.ascending);
                });
              },
              groupValue: selectedSort.category,
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
            widget.onSaved(selectedSort);
          },
        ),
      ],
    );
  }
}
