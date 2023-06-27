import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/sort.dart';
import 'package:spice_squad/screens/main_screen/sort_selection_dialog.dart';

class SortSelectionWidget extends StatefulWidget {
  final ValueChanged<Sort> onChanged;
  final Sort selectedSort;

  const SortSelectionWidget(
      {super.key, required this.onChanged, required this.selectedSort});

  @override
  State<SortSelectionWidget> createState() => _SortSelectionWidgetState();
}

class _SortSelectionWidgetState extends State<SortSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showFilterSelectionDialog(context),
      child: Row(
        children: [
          ImageIcon(
            widget.selectedSort.ascending
                ? const AssetImage("assets/icons/sortAscending.png")
                : const AssetImage("assets/icons/sortDescending.png"),
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            widget.selectedSort.category.toString(),
            style: Theme.of(context).textTheme.titleMedium,
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
          onChanged: widget.onChanged,
          selectedSort: widget.selectedSort,
        );
      },
    );
  }
}
