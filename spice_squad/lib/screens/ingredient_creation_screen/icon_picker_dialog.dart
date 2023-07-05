import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

/// Dialog to pick an icon for an ingredient
class IconPickerDialog extends StatelessWidget {
  /// A list of possible icon ids. An icon id is the name of the icon file
  final List<String> iconIds;

  /// Callback when an icon is picked
  final ValueChanged<String> onChanged;

  /// Creates a new icon picker dialog
  const IconPickerDialog({
    required this.iconIds,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.iconPickerDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: iconIds.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onChanged(iconIds[index]);
              },
              child: GridTile(
                child: ImageIcon(
                  AssetImage(
                    "assets/icons/ingredientIcons/${iconIds[index]}.png",
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
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
