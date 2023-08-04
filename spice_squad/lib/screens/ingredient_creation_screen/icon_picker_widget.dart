import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";
import "package:spice_squad/screens/ingredient_creation_screen/icon_picker_dialog.dart";

/// Widget to pick an icon for an ingredient
class IconPickerWidget extends ConsumerStatefulWidget {
  /// The callback that is called when the icon is changed
  final ValueChanged<String> _onChanged;

  /// The initial icon to display
  final String _initialIconUrl;

  /// Creates a new icon picker widget
  const IconPickerWidget({required void Function(String) onChanged, required String initialIconUrl, super.key})
      : _initialIconUrl = initialIconUrl,
        _onChanged = onChanged;

  @override
  ConsumerState<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends ConsumerState<IconPickerWidget> {
  /// The currently selected icon
  String? _selectedIcon;
  List<String> _iconUrls = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ingredientDataRepository).fetchIngredientIcons().then(
            (value) => setState(() {
              _iconUrls = value;
              _selectedIcon = widget._initialIconUrl.isNotEmpty ? widget._initialIconUrl : _iconUrls[0];
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
                    CachedNetworkImageProvider(_selectedIcon!),
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
          onChanged: (value) {
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
