import 'package:catalyst_voices/widgets/indicators/voices_loading_overlay.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderChangingOverlay extends StatelessWidget {
  final Widget child;

  const ProposalBuilderChangingOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const _ProposalBuilderChangingSelector(),
      ],
    );
  }
}

class _ProposalBuilderChangingSelector extends StatelessWidget {
  const _ProposalBuilderChangingSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState, bool>(
      selector: (state) => state.isChanging,
      builder: (context, isChanging) {
        return VoicesLoadingOverlay(show: isChanging);
      },
    );
  }
}
