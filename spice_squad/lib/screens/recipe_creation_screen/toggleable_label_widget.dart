import "package:flutter/material.dart";
import "package:spice_squad/widgets/tag_item.dart";

/// A widget that represents a label that can be toggled on and off.
class ToggleableLabelWidget extends StatefulWidget {
  /// The image that is displayed next to the label.
  final ImageProvider image;

  /// The name of the label.
  final String name;

  /// The initial state of the label.
  final bool initialActive;

  /// The callback that is called when the state of the label changes.
  final ValueChanged<bool> onChanged;

  /// Creates a new [ToggleableLabelWidget].
  const ToggleableLabelWidget({
    required this.image,
    required this.name,
    required this.onChanged,
    this.initialActive = false,
    super.key,
  });

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
