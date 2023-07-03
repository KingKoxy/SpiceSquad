import "package:flutter/material.dart";

/// A widget that contains a tag.
class TagItem extends StatelessWidget {
  /// The image that is displayed as an icon in the tag.
  final ImageProvider image;

  /// The name of the tag.
  final String name;

  /// Whether the tag is active or not.
  final bool isActive;

  /// Creates a new tag item.
  const TagItem({
    required this.image,
    required this.name,
    this.isActive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: isActive ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              image,
              color: isActive ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: isActive ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
