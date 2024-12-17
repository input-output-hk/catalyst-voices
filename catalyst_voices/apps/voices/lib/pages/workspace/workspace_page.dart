import 'package:flutter/material.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Workspace')),
    );
  }
}
