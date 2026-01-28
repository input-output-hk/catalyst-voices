import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card_widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleRepresentingCard extends StatelessWidget {
  final int delegatorsCount;
  final VoidCallback onInfoTap;

  const AccountVotingRoleRepresentingCard({
    super.key,
    required this.delegatorsCount,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: const EdgeInsets.fromLTRB(24, 12, 8, 18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.representing,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colors.textOnPrimaryWhite,
                ),
              ),
              AccountVotingRoleInfoButton(
                onTap: onInfoTap,
                color: theme.colors.iconsBackground,
              ),
            ],
          ),
          _DelegatesCount(count: delegatorsCount),
        ],
      ),
    );
  }
}

class _DelegatesCount extends StatelessWidget {
  final int count;

  const _DelegatesCount({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$count',
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.colors.textOnPrimaryWhite,
          ),
        ),
        const SizedBox(width: 4),
        Opacity(
          opacity: 0.8,
          child: Text(
            context.l10n.xDelegates(count),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textOnPrimaryWhite,
            ),
          ),
        ),
      ],
    );
  }
}
