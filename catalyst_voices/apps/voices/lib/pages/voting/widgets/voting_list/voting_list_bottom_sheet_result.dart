import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_bottom_sheet.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CatalystImage.asset(
            context.theme.brandAssets.brand.votingFailedCastVotes(context).path,
            width: 190,
            height: 190,
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.failedToCastVotesTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.failedToCastVotesDescription,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ],
      ),
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
        VotingRoute(tab: VotingPageTab.myVotes.name).go(context);
      },
      nextActionText: context.l10n.viewCastVotes,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CatalystImage.asset(
            context.theme.brandAssets.brand.votingSuccessCastVotes(context).path,
            width: 190,
            height: 190,
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.successToCastVotesTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.successToCastVotesDescription,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ],
      ),
    );
  }
}
