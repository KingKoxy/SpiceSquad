import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:image_picker/image_picker.dart";
import "package:spice_squad/icons.dart";
import "package:spice_squad/services/user_service.dart";

/// Widget for selecting a profile image
class ProfileImagePicker extends StatelessWidget {
  /// Initial Profile image to display
  final Uint8List? profileImage;

  /// User service for updating the profile image
  final UserService userService;

  /// Creates a new profile image picker
  const ProfileImagePicker({required this.profileImage, required this.userService, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Ink(
        decoration: profileImage != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20000),
                image: DecorationImage(image: MemoryImage(profileImage!), fit: BoxFit.cover),
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(20000), color: Theme.of(context).cardColor),
        child: InkWell(
          borderRadius: BorderRadius.circular(20000),
          onTap: () => _selectProfileImage(context),
          child: const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 75,
            child: ImageIcon(
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
    void removeProfileImage() {
      userService.removeProfileImage();
      Navigator.of(context).pop();
    }

    void setProfileImage(ImageSource source) {
      ImagePicker().pickImage(source: source).then((image) {
        if (image != null) {
          final File file = File(image.path);
          userService.setProfileImage(file);
          Navigator.of(context).pop();
        }
      });
    }

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
                    if (profileImage != null)
                      SizedBox(
                        height: 86,
                        width: 86,
                        child: RawMaterialButton(
                          onPressed: removeProfileImage,
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
                        onPressed: () => setProfileImage(ImageSource.gallery),
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
                        onPressed: () => setProfileImage(ImageSource.camera),
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
