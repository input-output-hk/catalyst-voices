import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/timeline/voting_timeline_header.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingGeneralHeader extends StatelessWidget {
  const VotingGeneralHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 36),
        _FundNumberAndVotingPower(),
        SizedBox(height: 52),
        VotingTimelineHeader(),
      ],
    );
  }
}

class _CatalystFund extends StatelessWidget {
  const _CatalystFund();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, int?>(
      selector: (state) => state.fundNumber,
      builder: (context, fundNumber) {
        final theme = Theme.of(context);
        return Text(
          context.l10n.catalystFundNo(fundNumber ?? 14),
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _FundNumberAndVotingPower extends StatelessWidget {
  const _FundNumberAndVotingPower();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.spaceVotingName,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colors.textOnPrimaryLevel1,
              ),
            ),
            const _CatalystFund(),
          ],
        ),
        const AccountVotingRoleCard(),
      ],
    );
  }
}
