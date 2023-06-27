import 'package:flutter/material.dart';

class EyeButton extends StatefulWidget {
  final bool open;
  final VoidCallback onToggle;

  const EyeButton({super.key, required this.open, required this.onToggle});

  @override
  State<EyeButton> createState() => _EyeButtonState();
}

class _EyeButtonState extends State<EyeButton> {
  late bool open;

  @override
  void initState() {
    open = widget.open;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 64,
        splashRadius: 32,
        onPressed: () {
          setState(() {
            open = !open;
          });
          widget.onToggle();
        },
        icon: ImageIcon(
          size: 32,
          AssetImage(open
              ? "assets/icons/eye_open.png"
              : "assets/icons/eye_closed.png"),
        ));
  }
}
