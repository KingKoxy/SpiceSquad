import "package:flutter/material.dart";

import "package:spice_squad/screens/recipe_creation_screen/label.dart";
class LabelButton extends StatefulWidget {
  final Label label;
  bool value;
  final VoidCallback onToggle;
  LabelButton({required this.label, required this.value, required this.onToggle, super.key,});

  @override
  State<LabelButton> createState() => _LabelButtonState();
}

class _LabelButtonState extends State<LabelButton> {
  late bool _value;
  late Label _label;

  @override
  void initState() {
    _label = widget.label;
    _value = widget.value;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _toggleLabel,
        child: SizedBox(
            height: 60,
            child: Card(
                color: _value
                    ? const Color(0xFF00F5AD)
                    : Theme
                    .of(context)
                    .colorScheme
                    .onSurfaceVariant,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(children: [
                      Image.asset(
                        _label.labelIcon.toString(),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          _label.labelText,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium,
                        ),
                      )
                    ],),),),),);
  }

  void _toggleLabel() {
    setState(() {
      _value = !_value;
    });
  }
}





