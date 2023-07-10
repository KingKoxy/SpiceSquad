import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_dialog.dart";

/// Widget to pick an icon for an ingredient
class IconPickerWidget extends ConsumerStatefulWidget {
  /// Controller for icon data
  final TextEditingController iconController;

  /// Creates a new icon picker widget
  const IconPickerWidget({required this.iconController, super.key});

  @override
  ConsumerState<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends ConsumerState<IconPickerWidget> {
  /// The currently selected icon
  late Uint8List _selectedIcon;
  late List<Uint8List> _icons;

  @override
  void initState() async {
    _icons = await ref.read(ingredientDataRepository).fetchIngredientIcons();
    _selectedIcon = _icons[0];
    widget.iconController.text = _selectedIcon.toString();
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
              MemoryImage(_selectedIcon),
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
          onChanged: (Uint8List value) {
            setState(() {
              _selectedIcon = value;
            });
            widget.iconController.text = value.toString();
          },
        );
      },
    );
  }
}
