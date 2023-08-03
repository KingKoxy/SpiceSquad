import "package:flutter/material.dart";

/// A widget that contains a tag.
class TagItem extends StatefulWidget {
  /// The image that is displayed as an icon in the tag.
  final ImageProvider _image;

  /// The name of the tag.
  final String _name;

  /// Whether the tag is initially active.
  final bool _initialActive;

  /// The callback that is called when the tag is toggled.
  final ValueChanged<bool>? _onToggle;

  /// The callback that is called when the tag is tapped.
  final VoidCallback? _onTap;

  /// Creates a new tag item.
  const TagItem({
    required ImageProvider<Object> image,
    required String name,
    super.key,
    void Function(bool)? onToggle,
    bool initialActive = false,
    void Function()? onTap,
  })  : _onTap = onTap,
        _onToggle = onToggle,
        _initialActive = initialActive,
        _name = name,
        _image = image;

  @override
  State<TagItem> createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> {
  late bool _active;

  @override
  void initState() {
    _active = widget._initialActive;
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
        onTap: widget._onToggle != null || widget._onTap != null
            ? () {
                if (widget._onToggle != null) {
                  setState(() {
                    _active = !_active;
                  });
                  widget._onToggle!(_active);
                }

                if (widget._onTap != null) {
                  widget._onTap!();
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                widget._image,
                color: _active ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                widget._name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: _active ? Colors.black : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
