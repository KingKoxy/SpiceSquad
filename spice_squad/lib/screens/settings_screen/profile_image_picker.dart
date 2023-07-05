import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:image_picker/image_picker.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/services/user_service.dart";

/// Widget for selecting a profile image
class ProfileImagePicker extends StatefulWidget {
  /// Initial Profile image to display
  final Uint8List? initialValue;

  /// User service for updating the profile image
  final UserService userService;

  /// Creates a new profile image picker
  const ProfileImagePicker({required this.initialValue, required this.userService, super.key});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Uint8List? _profileImage;

  @override
  void initState() {
    _profileImage = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Ink(
        decoration: _profileImage == null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20000),
                image: const DecorationImage(image: AssetImage("assets/images/exampleImage.jpeg")),
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(20000), color: Theme.of(context).cardColor),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 75,
          child: InkWell(
            borderRadius: BorderRadius.circular(20000),
            onTap: () => _selectProfileImage(context),
            child: const ImageIcon(
              SpiceSquadIconImages.editUser,
              size: 64,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Show dialog from bottom to remove or change profile image
  void _selectProfileImage(BuildContext context) {
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
                  AppLocalizations.of(context)!.selectProfileImageDialogTitle,
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
                        onPressed: _removeProfileImage,
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
                        onPressed: _setProfileImageFromGallery,
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
                        onPressed: _setProfileImageFromCamera,
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

  void _removeProfileImage() {
    widget.userService.removeProfileImage();
  }

  void _setProfileImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          final File file = File(image.path);
          _profileImage = file.readAsBytesSync();
          widget.userService.setProfileImage(file);
        });
      }
    });
  }

  void _setProfileImageFromCamera() {
    ImagePicker().pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        setState(() {
          final File file = File(image.path);
          _profileImage = file.readAsBytesSync();
          widget.userService.setProfileImage(file);
        });
      }
    });
  }
}
