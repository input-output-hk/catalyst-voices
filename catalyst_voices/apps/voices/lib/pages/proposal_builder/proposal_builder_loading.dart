import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderLoadingSelector extends StatelessWidget {
  const ProposalBuilderLoadingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: TickerMode(
            enabled: state,
            child: const _ProposalBuilderLoading(),
          ),
        );
      },
    );
  }
}

class _ProposalBuilderLoading extends StatelessWidget {
  const _ProposalBuilderLoading();

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
