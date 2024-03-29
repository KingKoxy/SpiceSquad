import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:image/image.dart" as img;
import "package:image_picker/image_picker.dart";
import "package:spice_squad/icons.dart";

/// Widget for selecting an image
class ImagePickerWidget extends StatelessWidget {
  /// Initial image to display
  final Uint8List? _recipeImage;

  /// Callback that is called when the image is changed
  final ValueChanged<Uint8List?> _onChanged;

  /// Creates a new image picker
  const ImagePickerWidget({
    required Uint8List? recipeImage,
    required void Function(Uint8List?) onChanged,
    super.key,
  })  : _onChanged = onChanged,
        _recipeImage = recipeImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Material(
        child: Ink(
          padding: EdgeInsets.zero,
          color: Theme.of(context).cardColor,
          child: InkWell(
            onTap: () => _selectRecipeImage(context),
            child: Center(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: _recipeImage == null
                    ? const ImageIcon(
                        size: 64,
                        SpiceSquadIconImages.image,
                        color: Colors.white,
                      )
                    : Image.memory(_recipeImage!, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeRecipeImage(BuildContext context) {
    _onChanged(null);
    Navigator.of(context).pop();
  }

  void _pickImage(BuildContext context, ImageSource source) {
    ImagePicker().pickImage(source: source).then((file) {
      if (file != null) {
        img.Image image = img.decodeImage(File(file.path).readAsBytesSync())!;
        image = img.copyResizeCropSquare(image, size: 480);
        _onChanged(Uint8List.fromList(img.encodeJpg(image, quality: 100)));
      }
    });
    Navigator.of(context).pop();
  }

  void _selectRecipeImage(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.selectRecipeImageHeadline,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (_recipeImage != null)
                      SizedBox(
                        height: 86,
                        width: 86,
                        child: RawMaterialButton(
                          onPressed: () => _removeRecipeImage(context),
                          elevation: 2.0,
                          fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                          child: const ImageIcon(
                            SpiceSquadIconImages.trash,
                            size: 32,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: () => _pickImage(context, ImageSource.gallery),
                        elevation: 2.0,
                        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const ImageIcon(
                          SpiceSquadIconImages.image,
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: () => _pickImage(context, ImageSource.camera),
                        elevation: 2.0,
                        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const ImageIcon(
                          SpiceSquadIconImages.camera,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
