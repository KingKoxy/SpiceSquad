import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {
      Navigator.of(context).pop();
    }, icon: const ImageIcon(AssetImage('assets/icons/back_arrow.png'),),);
  }
}
