import "package:flutter/material.dart";
import "package:spice_squad/widgets/tag_item.dart";

class ToggleableLabelWidget extends StatefulWidget {
  final ImageProvider image;
  final String name;
  final bool initialActive;
  final ValueChanged<bool> onChanged;

  const ToggleableLabelWidget(
      {required this.image, required this.name, required this.onChanged, this.initialActive = false, super.key,});

  @override
  State<ToggleableLabelWidget> createState() => _ToggleableLabelWidgetState();
}

class _ToggleableLabelWidgetState extends State<ToggleableLabelWidget> {
  late bool active;

  @override
  void initState() {
    active = widget.initialActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          active = !active;
          widget.onChanged(active);
        });
      },
      child: TagItem(
        image: widget.image,
        name: widget.name,
        isActive: active,
      ),
    );
  }
}
