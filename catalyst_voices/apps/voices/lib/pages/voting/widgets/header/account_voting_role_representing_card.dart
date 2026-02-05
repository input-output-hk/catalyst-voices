import 'dart:async';

import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card_widgets.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_learn_more_dialog.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_popup_menu.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleRepresentingCard extends StatelessWidget {
  final VotingPowerViewModel totalVotingPower;
  final int delegatorsCount;

  const AccountVotingRoleRepresentingCard({
    super.key,
    required this.totalVotingPower,
    required this.delegatorsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: const EdgeInsets.fromLTRB(24, 12, 8, 18),
      gradient: LinearGradient(
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
              AccountVotingRolePopupInfoButton(
                color: theme.colors.iconsBackground,
                menuBuilder: (context) {
                  return AccountVotingRolePopupMenu(
                    title: context.l10n.delegation,
                    message: context.l10n.votingRoleRepresentingPopupMessage,
                    updatedAt: totalVotingPower.updatedAt,
                    status: totalVotingPower.status,
                    onLearnMore: () {
                      unawaited(
                        AccountVotingRoleLearnMoreDialog.show(
                          context: context,
                          title: context.l10n.votingRoleRepresentingLearnMoreDialogTitle,
                          message: context.l10n.votingRoleRepresentingLearnMoreDialogMessage,
                        ),
                      );
                    },
                  );
                },
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

  const _DelegatesCount({required this.count});

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
