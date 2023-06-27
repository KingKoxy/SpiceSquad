import 'package:flutter/material.dart';

class IconPickerWidget extends StatefulWidget {
  const IconPickerWidget({super.key});

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
