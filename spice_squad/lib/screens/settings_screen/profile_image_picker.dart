import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileImagePicker extends StatefulWidget {
  final Uint8List? profileImage;

  const ProfileImagePicker({super.key, required this.profileImage});

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
            onTap: () {
              //TODO: implement profile image selection
            },
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
}
