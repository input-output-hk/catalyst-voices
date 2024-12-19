import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceLoadingSelector extends StatelessWidget {
  const WorkspaceLoadingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const _WorkspaceLoading(),
          ),
        );
      },
    );
  }
}

class _WorkspaceLoading extends StatelessWidget {
  const _WorkspaceLoading();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: VoicesCircularProgressIndicator(),
      ),
    );
  }
}
