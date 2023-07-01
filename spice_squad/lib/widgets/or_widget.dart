import "package:flutter/material.dart";

class OrWidget extends StatelessWidget {
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
