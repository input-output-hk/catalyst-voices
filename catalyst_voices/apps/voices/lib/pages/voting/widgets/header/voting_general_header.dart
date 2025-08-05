import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_power_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_picker.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_phase_progress_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingGeneralHeader extends StatelessWidget {
  const VotingGeneralHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),
        Text(
          context.l10n.spaceVotingName,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: _CatalystFund(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7, right: 32),
              child: VotingCategoryPickerSelector(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const SizedBox(
          height: 192,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              VotingPhaseProgressCardSelector(),
              AccountVotingPowerCardSelector(),
            ],
          ),
        ),
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
