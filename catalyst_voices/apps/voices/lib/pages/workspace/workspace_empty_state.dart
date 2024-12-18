import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceEmptyState extends StatelessWidget {
  const WorkspaceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return _Selector(
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          // TODO(damian-molinski): Strings and looks is not final
          child: const Center(
            child: EmptyState(
              title: 'No proposals found',
              description: 'Created proposals will appear here',
            ),
          ),
        );
      },
    );
  }
}

class _Selector extends StatelessWidget {
  final BlocWidgetBuilder<bool> builder;

  const _Selector({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.showEmptyState,
      builder: builder,
    );
  }
}
