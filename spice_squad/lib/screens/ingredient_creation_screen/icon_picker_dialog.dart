import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:spice_squad/providers/repository_providers.dart";

/// Dialog to pick an icon for an ingredient
class IconPickerDialog extends ConsumerWidget {
  /// Callback when an icon is picked
  final ValueChanged<Uint8List> onChanged;

  /// Creates a new icon picker dialog
  const IconPickerDialog({
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.iconPickerDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder(
          future: ref.watch(ingredientDataRepository).fetchIngredientIcons(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Uint8List> icons = snapshot.data as List<Uint8List>;
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context).pop();
                      onChanged(icons[index]);
                    },
                    child: GridTile(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ImageIcon(
                          MemoryImage(
                            icons[index],
                          ),
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const SizedBox(height: 50, width: 50, child: CircularProgressIndicator());
            }
          },
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
