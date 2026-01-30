import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card_widgets.dart';
import 'package:catalyst_voices/widgets/text/voices_gradient_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleRepresentativeTotalPowerCard extends StatelessWidget {
  final VotingPowerAmount totalVotingPower;
  final VotingPowerViewModel ownVotingPower;
  final VotingPowerViewModel delegatedVotingPower;

  const AccountVotingRoleRepresentativeTotalPowerCard({
    super.key,
    required this.totalVotingPower,
    required this.ownVotingPower,
    required this.delegatedVotingPower,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AccountVotingRoleInfoCard(
      padding: const EdgeInsets.fromLTRB(24, 12, 40, 14),
      label: Text(context.l10n.totalVotingPower),
      value: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          VoicesGradientText(
            totalVotingPower.formattedWithSymbol,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          _TotalVotingPowerItem(
            label: context.l10n.own,
            value: ownVotingPower.amount.formatted,
          ),
          _TotalVotingPowerItem(
            label: context.l10n.delegated,
            value: delegatedVotingPower.amount.formatted,
          ),
        ],
      ),
      infoButton: AccountVotingRoleInfoButton(
        onTap: () {
          // TODO(dt-iohk): https://github.com/input-output-hk/catalyst-voices/issues/3968
        },
      ),
    );
  }
}

class _TotalVotingPowerItem extends StatelessWidget {
  final String label;
  final String value;

  const _TotalVotingPowerItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colors.textOnPrimaryLevel1,
            fontSize: 28,
          ),
        ),
      ],
    );
  }
}
