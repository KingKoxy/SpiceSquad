import 'package:flutter/material.dart';

class RemoveButton extends IconButton {
  const RemoveButton({super.key, required super.onPressed})
      : super(
          icon: const ImageIcon(AssetImage("assets/icons/remove.png")),
        );
}
