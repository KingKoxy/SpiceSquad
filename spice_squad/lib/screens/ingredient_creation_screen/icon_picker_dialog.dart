import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// Dialog to pick an icon for an ingredient
class IconPickerDialog extends StatelessWidget {
  final List<String> _iconUrls;

  /// Callback when an icon is picked
  final ValueChanged<String> _onChanged;

  /// Creates a new icon picker dialog
  const IconPickerDialog({
    required List<String> iconUrls,
    required void Function(String) onChanged,
    super.key,
  })  : _onChanged = onChanged,
        _iconUrls = iconUrls;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.iconPickerDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _iconUrls.length,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.of(context).pop();
                _onChanged(_iconUrls[index]);
              },
              child: GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ImageIcon(
                    CachedNetworkImageProvider(
                      _iconUrls[index],
                    ),
                    size: 30,
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
