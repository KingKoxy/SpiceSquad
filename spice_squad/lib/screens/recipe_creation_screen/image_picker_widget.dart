import "dart:typed_data";

import "package:flutter/material.dart";
import "package:spice_squad/services/recipe_service.dart";

class ImagePickerWidget extends StatefulWidget {
  final Uint8List? recipeImage;
  final RecipeService recipeService;

  const ImagePickerWidget(
      {required this.recipeImage, required this.recipeService, super.key,});

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
    return Card(
        child: Center(
      child: FittedBox(
        fit: BoxFit.fill,
        child: ClipRRect(
          child: Ink(
            decoration: _recipeImage == null
                ? BoxDecoration(color: Theme.of(context).cardColor)
                : const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/icons/exampleRecipeImage.jpeg",),),),
            child: InkWell(
                onTap: () => _selectRecipeImage(context),
                child: const SizedBox(
                  width: 150,
                  height: 150,
                  child: ImageIcon(
                    AssetImage("assets/icons/image.png"),
                    color: Colors.white,
                  ),
                ),),
          ),
        ),
      ),
    ),);
  }
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
                      child:
                          const ImageIcon(AssetImage("assets/icons/image.png")),
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
                      child:
                          const ImageIcon(AssetImage("assets/icons/image.png")),
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
                      child:
                          const ImageIcon(AssetImage("assets/icons/image.png")),
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
  //TODO: implement setting recipe image from gallery
  //widget.recipeService.removeProfileImage();
}

void _setRecipeImageFromGallery() {
  //TODO: implement setting recipe image from gallery
  //widget.recipeService.setRecipeImage(image);
}

void _setRecipeImageFromCamera() {
  //TODO: implement setting recipe image from camera
  //widget.recipeService.setRecipeImage(image);
}
