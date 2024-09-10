import 'package:flutter/material.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      alignment: Alignment.center,
      child: Text(
        'Workspace',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
