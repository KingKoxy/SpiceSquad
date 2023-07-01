import "package:flutter/material.dart";

/// A widget that is used to indicate a divider between two other widgets that are in an "or" relationship.
class OrWidget extends StatelessWidget {
  /// Creates a new or widget.
  const OrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "oder",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.5,
          ),
        ),
      ],
    ),);
  }
}
