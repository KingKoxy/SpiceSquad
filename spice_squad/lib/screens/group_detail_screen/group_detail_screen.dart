import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  static const routeName = '/group-detail';

  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Squad"),
      ),
    );
  }
}
