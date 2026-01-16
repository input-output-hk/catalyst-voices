import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalViewerLoading extends StatelessWidget {
  const ProposalViewerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalViewerCubit, ProposalViewerState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const _ProposalViewerLoading(),
          ),
        );
      },
    );
  }
}

class _ProposalViewerLoading extends StatelessWidget {
  const _ProposalViewerLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: VoicesCircularProgressIndicator());
  }
}
