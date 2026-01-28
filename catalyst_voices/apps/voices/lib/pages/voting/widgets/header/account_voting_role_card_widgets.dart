import 'dart:math' as math;

import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/gesture/voices_gesture_detector.dart';
import 'package:catalyst_voices/widgets/text/voices_gradient_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
                      context.l10n.xRepresentatives(representativesCount),
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
              _InfoButton(
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

class AccountVotingRoleInfoCard extends StatelessWidget {
  final EdgeInsets padding;
  final String label;
  final Widget value;
  final VoidCallback onInfoTap;

  const AccountVotingRoleInfoCard({
    super.key,
    this.padding = const EdgeInsets.fromLTRB(24, 12, 8, 18),
    required this.label,
    required this.value,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AccountVotingRoleCardDecoration(
      padding: padding,
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
              _InfoButton(onTap: onInfoTap),
            ],
          ),
          DefaultTextStyle(
            style: theme.textTheme.displayMedium!.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
            child: value,
          ),
        ],
      ),
    );
  }
}

class AccountVotingRoleRepresentativeTotalPower extends StatelessWidget {
  final VotingPowerAmount totalVotingPower;
  final VotingPowerViewModel ownVotingPower;
  final VotingPowerViewModel delegatedVotingPower;
  final VoidCallback onInfoTap;

  const AccountVotingRoleRepresentativeTotalPower({
    super.key,
    required this.totalVotingPower,
    required this.ownVotingPower,
    required this.delegatedVotingPower,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AccountVotingRoleInfoCard(
      padding: const EdgeInsets.fromLTRB(24, 12, 40, 18),
      label: context.l10n.totalVotingPower,
      value: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
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
      onInfoTap: onInfoTap,
    );
  }
}

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
              _InfoButton(
                onTap: onInfoTap,
                color: theme.colors.iconsBackground,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$delegatorsCount',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colors.textOnPrimaryWhite,
                ),
              ),
              const SizedBox(width: 4),
              Opacity(
                opacity: 0.8,
                child: Text(
                  context.l10n.xDelegates(delegatorsCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colors.textOnPrimaryWhite,
                  ),
                ),
              ),
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

class _InfoButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const _InfoButton({
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
      spacing: 8,
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
          ),
        ),
      ],
    );
  }
}
