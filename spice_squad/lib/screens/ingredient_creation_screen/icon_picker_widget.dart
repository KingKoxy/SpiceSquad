import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_dialog.dart";

/// Widget to pick an icon for an ingredient
class IconPickerWidget extends ConsumerStatefulWidget {
  /// The callback that is called when the icon is changed
  final ValueChanged<Uint8List> _onChanged;

  /// The initial icon to display
  final Uint8List? _initialIcon;

  /// Creates a new icon picker widget
  const IconPickerWidget({required void Function(Uint8List) onChanged, Uint8List? initialIcon, super.key})
      : _initialIcon = initialIcon,
        _onChanged = onChanged;

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
              _selectedIcon = widget._initialIcon ?? _icons[0];
              widget._onChanged(_selectedIcon!);
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
            widget._onChanged(_selectedIcon!);
          },
        );
      },
    );
  }
}
