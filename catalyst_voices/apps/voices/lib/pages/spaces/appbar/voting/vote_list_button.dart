import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list.dart';
import 'package:catalyst_voices/widgets/buttons/voices_responsive_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoteListButton extends StatelessWidget {
  const VoteListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesResponsiveOutlinedButton(
      icon: VoicesAssets.icons.vote.buildIcon(),
      child: BlocSelector<VotingBallotBloc, VotingBallotState, int>(
        selector: (state) => state.votesCount,
        builder: (context, votesCount) => Text(_getText(context, votesCount)),
      ),
      onTap: () => VotingListDrawer.open(context),
    );
  }

  String _getText(BuildContext context, int count) {
    if (count == 0) {
      return context.l10n.voteListButton;
    } else {
      return '${context.l10n.voteListButton} · $count';
    }
  }
}
