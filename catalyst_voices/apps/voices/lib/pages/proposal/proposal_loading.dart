import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalLoading extends StatelessWidget {
  const ProposalLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const _ProposalLoading(),
          ),
        );
      },
    );
  }
}

class _ProposalLoading extends StatelessWidget {
  const _ProposalLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: VoicesCircularProgressIndicator());
  }
}
