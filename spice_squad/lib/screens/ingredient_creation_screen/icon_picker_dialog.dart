import 'package:flutter/material.dart';

class IconPickerDialog extends StatelessWidget {
  final List<String> iconIds;
  final ValueChanged<String> onChanged;

  const IconPickerDialog(
      {super.key, required this.iconIds, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Icon auwählen"),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: iconIds.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onChanged(iconIds[index]);
              },
              child: GridTile(
                child: ImageIcon(AssetImage(
                    "assets/icons/ingredientIcons/${iconIds[index]}.png")),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Abbrechen"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
