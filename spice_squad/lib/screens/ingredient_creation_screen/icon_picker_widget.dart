import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_dialog.dart";

/// Widget to pick an icon for an ingredient
class IconPickerWidget extends ConsumerStatefulWidget {
  /// The callback that is called when the icon is changed
  final ValueChanged<Uint8List> onChanged;

  /// The initial icon to display
  final Uint8List? initialIcon;

  /// Creates a new icon picker widget
  const IconPickerWidget({required this.onChanged, this.initialIcon, super.key});

  @override
  ConsumerState<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends ConsumerState<IconPickerWidget> {
  /// The currently selected icon
  Uint8List? _selectedIcon;
  List<Uint8List> _icons = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ingredientDataRepository).fetchIngredientIcons().then(
            (value) => setState(() {
              _icons = value;
              _selectedIcon = widget.initialIcon ?? _icons[0];
              widget.onChanged(_selectedIcon!);
            }),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedIcon != null
                ? ImageIcon(
                    MemoryImage(_selectedIcon!),
                  )
                : Container(),
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
            widget.onChanged(_selectedIcon!);
          },
        );
      },
    );
  }
}
