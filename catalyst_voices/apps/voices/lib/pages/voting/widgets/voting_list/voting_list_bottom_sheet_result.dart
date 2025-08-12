import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBottomSheetFailedResult extends StatelessWidget {
  const VotingListBottomSheetFailedResult({super.key});

  @override
  Widget build(BuildContext context) {
    return VotingListBottomSheetContent(
      nextAction: () {
        context.read<VotingBallotBloc>().add(const ConfirmCastingVotesEvent());
      },
      nextActionText: context.l10n.retry,
      body: const Column(),
    );
  }
}

class VotingListBottomSheetSuccessResult extends StatelessWidget {
  const VotingListBottomSheetSuccessResult({super.key});

  @override
  Widget build(BuildContext context) {
    return VotingListBottomSheetContent(
      nextAction: () {
        VotingListDrawer.close(context);
        VotingRoute(tab: VotingPageTab.votedOn.name).go(context);
      },
      nextActionText: context.l10n.viewCastVotes,
      body: const Column(),
    );
  }
}
