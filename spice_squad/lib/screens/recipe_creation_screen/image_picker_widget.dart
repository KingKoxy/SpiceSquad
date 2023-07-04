import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class ImagePickerWidget extends StatefulWidget {
  final Uint8List? recipeImage;

  const ImagePickerWidget({
    required this.recipeImage,
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _recipeImage;

  @override
  void initState() {
    _recipeImage = widget.recipeImage;
    super.initState();
  }

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
                          AssetImage("assets/icons/image.png"),
                          color: Colors.white,
                        )
                      : Image.memory(_recipeImage!, fit: BoxFit.cover),
                ),
              )),
        ),
      ),
    );
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
                  "Rezeptbild auswählen",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: _removeRecipeImage,
                        elevation: 2.0,
                        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const ImageIcon(AssetImage("assets/icons/trash.png")),
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: _setRecipeImageFromGallery,
                        elevation: 2.0,
                        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const ImageIcon(AssetImage("assets/icons/image.png")),
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: _setRecipeImageFromCamera,
                        elevation: 2.0,
                        fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const ImageIcon(AssetImage("assets/icons/camera.png")),
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

  void _removeRecipeImage() {
    setState(() {
      _recipeImage = null;
    });
  }

  void _setRecipeImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          _recipeImage = File(image.path).readAsBytesSync();
        });
      }
    });
  }

  void _setRecipeImageFromCamera() {
    ImagePicker().pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        setState(() {
          _recipeImage = File(image.path).readAsBytesSync();
        });
      }
    });
  }
}
