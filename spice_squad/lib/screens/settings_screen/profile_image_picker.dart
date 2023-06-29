import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spice_squad/services/user_service.dart';

class ProfileImagePicker extends StatefulWidget {
  final Uint8List? profileImage;
  final UserService userService;

  const ProfileImagePicker({super.key, required this.profileImage, required this.userService});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Uint8List? _profileImage;

  @override
  void initState() {
    _profileImage = widget.profileImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Ink(
        decoration: _profileImage == null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20000),
                image: const DecorationImage(image: AssetImage("assets/icons/exampleRecipeImage.jpeg")),
              )
            : BoxDecoration(borderRadius: BorderRadius.circular(20000), color: Theme.of(context).cardColor),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 75,
          child: InkWell(
            borderRadius: BorderRadius.circular(20000),
            onTap: () => _selectProfileImage(context),
            child: const SizedBox(
              width: 150,
              height: 150,
              child: ImageIcon(
                AssetImage("assets/icons/user_edit.png"),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                  "Profilbild auswählen",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 86,
                      width: 86,
                      child: RawMaterialButton(
                        onPressed: () => _removeProfileImage(),
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
                        onPressed: () => _setProfileImageFromGallery(),
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
                        onPressed: () => _setProfileImageFromCamera(),
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

  void _removeProfileImage() {
    widget.userService.removeProfileImage();
  }

  void _setProfileImageFromGallery() {
    //TODO: implement setting profile image from gallery
    //widget.userService.setProfileImage(image);
  }

  void _setProfileImageFromCamera(){
    //TODO: implement setting profile image from camera
    //widget.userService.setProfileImage(image);
  }
}