import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ProposalVotingFab extends StatelessWidget {
  const ProposalVotingFab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalViewerCubit, ProposalViewerState, bool>(
      selector: (state) => state.showData,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: const VotingBallotProposalsCountFab(),
        );
      },
    );
  }
}
