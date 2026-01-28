import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_picker.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_phase_progress_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VotingGeneralHeader extends StatelessWidget {
  final bool showCategoryPicker;

  const VotingGeneralHeader({
    super.key,
    this.showCategoryPicker = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        const _FundNumberAndVotingPower(),
        const SizedBox(height: 52),
        _VotingTimeline(showCategoryPicker: showCategoryPicker),
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
        const AccountVotingRoleCardSelector(),
      ],
    );
  }
}

class _VotingTimeline extends StatelessWidget {
  final bool showCategoryPicker;

  const _VotingTimeline({required this.showCategoryPicker});

  @override
  Widget build(BuildContext context) {
    // TODO(dt-iohk): implement in https://github.com/input-output-hk/catalyst-voices/issues/3961
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const VotingPhaseProgressCardSelector(),
        if (showCategoryPicker)
          ResponsivePadding(
            md: const EdgeInsets.only(top: 3),
            lg: const EdgeInsets.only(top: 3, right: 32),
            child: const VotingCategoryPickerSelector(),
          ),
      ],
    );
  }
}
