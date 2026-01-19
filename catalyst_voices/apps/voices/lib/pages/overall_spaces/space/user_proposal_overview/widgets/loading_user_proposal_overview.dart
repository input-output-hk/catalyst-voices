import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class LoadingProposalOverview extends StatelessWidget {
  const LoadingProposalOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, isLoading) => Offstage(
        offstage: !isLoading,
        child: _Loading(
          isLoading: isLoading,
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  final bool isLoading;

  const _Loading({
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: TickerMode(
          enabled: isLoading,
          child: const VoicesCircularProgressIndicator(),
        ),
      ),
    );
  }
}
