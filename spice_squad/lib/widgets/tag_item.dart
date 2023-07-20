import "package:flutter/material.dart";

/// A widget that contains a tag.
class TagItem extends StatefulWidget {
  /// The image that is displayed as an icon in the tag.
  final ImageProvider image;

  /// The name of the tag.
  final String name;

  /// Whether the tag is initially active.
  final bool initialActive;

  /// The callback that is called when the tag is toggled.
  final ValueChanged<bool>? onToggle;

  /// The callback that is called when the tag is tapped.
  final VoidCallback? onTap;

  /// Creates a new tag item.
  const TagItem(
      {required this.image, required this.name, super.key, this.onToggle, this.initialActive = false, this.onTap});

  @override
  State<TagItem> createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> {
  late bool _active;

  @override
  void initState() {
    _active = widget.initialActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: _active ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: widget.onToggle != null || widget.onTap != null
            ? () {
                if (widget.onToggle != null) {
                  setState(() {
                    _active = !_active;
                  });
                  widget.onToggle!(_active);
                }

                if (widget.onTap != null) {
                  widget.onTap!();
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                widget.image,
                color: _active ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: _active ? Colors.black : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
