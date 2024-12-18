import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:flutter/material.dart';

class WorkspaceEmptyState extends StatelessWidget {
  const WorkspaceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Offstage(
      offstage: true,
      child: Center(
        child: EmptyState(
          title: 'No proposals found',
          description: 'Created proposals will appear here',
        ),
      ),
    );
  }
}
