import 'package:flutter/material.dart';

import 'icon_picker_dialog.dart';

class IconPickerWidget extends StatefulWidget {
  static const List<String> iconIds = ["carrot", "milk", "bread"];

  final TextEditingController controller;

  const IconPickerWidget({super.key, required this.controller});

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  String _selectedIconId = "carrot";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/icons/ingredientIcons/$_selectedIconId.png"),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return IconPickerDialog(
            iconIds: IconPickerWidget.iconIds,
            onChanged: (String value) {
              setState(() {
                _selectedIconId = value;
              });
              widget.controller.text = value;
            },
          );
        });
  }
}
