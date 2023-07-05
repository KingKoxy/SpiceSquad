import "package:flutter/material.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_dialog.dart";

/// Widget to pick an icon for an ingredient
class IconPickerWidget extends StatefulWidget {
  /// A list of possible icon ids. An icon id is the name of the icon file
  static const List<String> _iconIds = ["carrot", "milk", "bread"];

  /// The controller that contains the currently selected icon id
  final TextEditingController controller;

  /// Creates a new icon picker widget
  const IconPickerWidget({required this.controller, super.key});

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  /// The currently selected icon id
  String _selectedIconId = "carrot";

  @override
  void initState() {
    widget.controller.text = _selectedIconId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
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
          iconIds: IconPickerWidget._iconIds,
          onChanged: (String value) {
            setState(() {
              _selectedIconId = value;
            });
            widget.controller.text = value;
          },
        );
      },
    );
  }
}
