import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceEmptyStateSelector extends StatelessWidget {
  const WorkspaceEmptyStateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.showEmptyState,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: const _WorkspaceEmptyState(),
        );
      },
    );
  }
}

class _WorkspaceEmptyState extends StatelessWidget {
  const _WorkspaceEmptyState();

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): Strings and looks is not final
    return const Center(
      child: EmptyState(
        title: 'No proposals found',
        description: 'Created proposals will appear here',
      ),
    );
  }
}
