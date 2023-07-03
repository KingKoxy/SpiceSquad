import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {
      Navigator.of(context).pop();
    }, icon: const ImageIcon(AssetImage('assets/icons/edit_pen.png'),),);
  }
}
