import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_power_card.dart';
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
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        Text(
          context.l10n.spaceVotingName,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 12,
            children: [
              const _CatalystFund(),
              if (showCategoryPicker)
                ResponsivePadding(
                  md: const EdgeInsets.only(top: 3),
                  lg: const EdgeInsets.only(top: 3, right: 32),
                  child: const VotingCategoryPickerSelector(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const _Cards(),
      ],
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards();

  @override
  Widget build(BuildContext context) {
    return ResponsiveChildBuilder(
      sm: (_) => const _SmallCards(),
      md: (_) => const _DesktopCards(),
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

class _DesktopCards extends StatelessWidget {
  const _DesktopCards();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        VotingPhaseProgressCardSelector(),
        AccountVotingPowerCardSelector(),
      ],
    );
  }
}

class _SmallCards extends StatelessWidget {
  const _SmallCards();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        VotingPhaseProgressCardSelector(),
        AccountVotingPowerCardSelector(),
      ],
    );
  }
}
