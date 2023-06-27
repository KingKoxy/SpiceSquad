import 'package:flutter/material.dart';

class AddButton extends IconButton {
  const AddButton({super.key, required super.onPressed})
      : super(
    icon: const ImageIcon(AssetImage("assets/icons/add.png")),
  );
}
