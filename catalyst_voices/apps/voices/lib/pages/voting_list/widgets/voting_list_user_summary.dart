import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting/widgets/voting_power_status_chip.dart';
import 'package:catalyst_voices/widgets/separators/voices_vertical_divider.dart';
import 'package:catalyst_voices/widgets/text/voices_gradient_text.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListUserSummary extends StatelessWidget {
  const VotingListUserSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListUserSummaryData>(
      selector: (state) => state.userSummary,
      builder: (context, state) {
        return _VotingListUserSummary(data: state);
      },
    );
  }
}

class _DelegatesSection extends StatelessWidget {
  final int delegatorsCount;

  const _DelegatesSection({
    required this.delegatorsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.xDelegates(delegatorsCount),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        _VoicesGradientText(text: '$delegatorsCount'),
      ],
    );
  }
}

class _IndividualLayout extends StatelessWidget {
  final VotingListUserSummaryData data;

  const _IndividualLayout({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _VotingPowerSection(
          formattedAmount: data.formattedAmount.formattedWithSymbol,
          isRepresentative: false,
        ),
        _UpdatedSection(
          updatedAt: data.updatedAt,
          status: data.status,
        ),
      ],
    );
  }
}

class _RepresentativeLayout extends StatelessWidget {
  final VotingListUserSummaryData data;

  const _RepresentativeLayout({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _VotingPowerSection(
          formattedAmount: data.formattedAmount.formattedWithSymbol,
          isRepresentative: true,
        ),
        const VoicesVerticalDivider(
          width: 1,
          indent: 5.5,
          endIndent: 5.5,
        ),
        SizedBox(
          width: 110,
          child: _DelegatesSection(
            delegatorsCount: data.delegatorsCount,
          ),
        ),
        _UpdatedSection(
          updatedAt: data.updatedAt,
          status: data.status,
        ),
      ],
    );
  }
}

class _UpdatedSection extends StatelessWidget {
  final DateTime? updatedAt;
  final VotingPowerStatus? status;

  const _UpdatedSection({
    required this.updatedAt,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final updatedAt = this.updatedAt;
    final formattedDate = updatedAt != null ? DateFormatter.formatTimeAndDate(updatedAt) : '---';
    final textStyle = context.textTheme.labelMedium?.copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          context.l10n.updated,
          style: textStyle,
        ),
        Text(
          formattedDate,
          style: textStyle,
        ),
        VotingPowerStatusChip(status: status),
      ],
    );
  }
}

class _VoicesGradientText extends StatelessWidget {
  final String text;

  const _VoicesGradientText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return VoicesGradientText(
      text,
      style: theme.textTheme.displaySmall,
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ],
      ),
    );
  }
}

class _VotingListUserSummary extends StatelessWidget {
  final VotingListUserSummaryData data;

  const _VotingListUserSummary({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VotingListUserSummaryTotalVotingPower(data: data),
        ],
      ),
    );
  }
}

class _VotingListUserSummaryTotalVotingPower extends StatelessWidget {
  final VotingListUserSummaryData data;

  const _VotingListUserSummaryTotalVotingPower({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: data.isRepresentative
          ? _RepresentativeLayout(data: data)
          : _IndividualLayout(data: data),
    );
  }
}

class _VotingPowerSection extends StatelessWidget {
  final String formattedAmount;
  final bool isRepresentative;

  const _VotingPowerSection({
    required this.formattedAmount,
    required this.isRepresentative,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.votingPower,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
          ),
        ),
        if (isRepresentative)
          _VoicesGradientText(text: formattedAmount)
        else
          Text(
            formattedAmount,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
          ),
      ],
    );
  }
}
