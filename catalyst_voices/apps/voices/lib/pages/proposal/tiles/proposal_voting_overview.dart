import 'dart:async';

import 'package:catalyst_voices/pages/proposal/widget/proposal_favorite_button.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_share_button.dart';
import 'package:catalyst_voices/widgets/voting/vote_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalVotingOverview extends StatelessWidget {
  final ProposalViewVoting data;

  const ProposalVotingOverview(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProposalShareButton(),
        const SizedBox(width: 8),
        const ProposalFavoriteButton(),
        const Spacer(),
        VoteButton(
          onSelected: (action) {
            unawaited(context.read<ProposalCubit>().changeDraftVote(action));
          },
          data: data.voteButtonData,
        ),
      ],
    );
  }
}
