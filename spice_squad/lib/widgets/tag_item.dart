import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final bool isActive;

  const TagItem(
      {super.key,
      required this.image,
      required this.name,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(image, color: isActive ? Colors.black : Colors.white,),
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: isActive ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
