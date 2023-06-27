import 'package:flutter/material.dart';
import 'package:spice_squad/screens/main_screen/filter_category.dart';

import 'filter_selection_dialog.dart';

class FilterSelectionWidget extends StatefulWidget {
  final ValueChanged<List<FilterCategory>> onChanged;
  final List<FilterCategory> selectedFilters;

  const FilterSelectionWidget(
      {super.key, required this.onChanged, required this.selectedFilters});

  @override
  State<FilterSelectionWidget> createState() => _FilterSelectionWidgetState();
}

class _FilterSelectionWidgetState extends State<FilterSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showFilterSelectionDialog(context),
      child: Row(
        children: [
          const ImageIcon(
            AssetImage("assets/icons/filter.png"),
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            "Filter",
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
        return FilterSelectionDialog(onChanged: widget.onChanged, selectedFilters: widget.selectedFilters,);
      },
    );
  }
}
