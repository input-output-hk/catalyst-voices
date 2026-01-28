import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingSpaceVoteBallotBuilderCountFab extends StatelessWidget {
  const VotingSpaceVoteBallotBuilderCountFab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingBalloutBuilderFabViewModel>(
      selector: (state) => state.fab,
      builder: (context, state) => _VotingSpaceVoteBallotBuilderCountFab(data: state),
    );
  }
}

class _VotingSpaceVoteBallotBuilderCountFab extends StatelessWidget {
  final VotingBalloutBuilderFabViewModel data;

  const _VotingSpaceVoteBallotBuilderCountFab({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !data.isVisible,
      child: VotesCountFloatingActionButton(
        count: data.count,
        useGradient: data.useGradient,
        // TODO(damian-molinski): Push page.
        onTap: () {},
      ),
    );
  }
}
