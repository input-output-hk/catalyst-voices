import 'dart:math' as math;

import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/gesture/voices_gesture_detector.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

const double _cardHeight = 128;

class AccountVotingRoleCardDecoration extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final Widget child;

  const AccountVotingRoleCardDecoration({
    super.key,
    this.padding,
    this.color,
    this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: color,
        gradient: gradient,
      ),
      child: child,
    );
  }
}

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
        children: [
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
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$representativesCount',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colors.textOnPrimaryWhite,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      context.l10n.representatives(representativesCount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colors.textOnPrimaryWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
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
        ],
      ),
    );
  }
}

class AccountVotingRoleInfoButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const AccountVotingRoleInfoButton({
    super.key,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIconButton(
      onTap: onTap,
      child: VoicesAssets.icons.informationCircle.buildIcon(
        color: color ?? Theme.of(context).colors.iconsPrimary,
      ),
    );
  }
}

class AccountVotingRoleInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onInfoTap;

  const AccountVotingRoleInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: const EdgeInsets.fromLTRB(24, 12, 8, 18),
      color: theme.colors.elevationsOnSurfaceNeutralLv1White,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colors.textOnPrimaryLevel0,
                ),
              ),
              AccountVotingRoleInfoButton(onTap: onInfoTap),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.displayMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
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
