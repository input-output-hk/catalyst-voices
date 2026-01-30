import 'dart:math' as math;

import 'package:catalyst_voices/pages/voting/widgets/header/account_voting_role_card_widgets.dart';
import 'package:catalyst_voices/widgets/gesture/voices_gesture_detector.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AccountVotingRoleDelegatedToCard extends StatelessWidget {
  final int representativesCount;
  final VoidCallback onInfoTap;
  final VoidCallback onRepresentativesTap;

  const AccountVotingRoleDelegatedToCard({
    super.key,
    required this.representativesCount,
    required this.onInfoTap,
    required this.onRepresentativesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: const EdgeInsets.fromLTRB(24, 12, 8, 18),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.onPrimaryContainer,
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AccountVotingRoleInfoButton(
                onTap: onInfoTap,
                color: theme.colors.iconsBackground,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 4),
                child: _ArrowRightButton(onTap: onRepresentativesTap),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  context.l10n.delegatedTo,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colors.textOnPrimaryWhite,
                  ),
                ),
              ),
              _RepresentativesCount(count: representativesCount),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArrowRightButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ArrowRightButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesGestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 14,
        foregroundColor: theme.colors.iconsPrimary,
        backgroundColor: theme.colors.iconsBackground,
        child: Transform.rotate(
          // Rotate 45deg counter-clockwise
          angle: -math.pi / 4,
          child: VoicesAssets.icons.arrowRight.buildIcon(size: 20),
        ),
      ),
    );
  }
}

class _RepresentativesCount extends StatelessWidget {
  final int count;

  const _RepresentativesCount({required this.count});

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
            context.l10n.xRepresentatives(count),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textOnPrimaryWhite,
            ),
          ),
        ),
      ],
    );
  }
}
