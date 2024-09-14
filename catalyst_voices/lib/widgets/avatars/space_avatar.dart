import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Widget for [Space] [VoicesAvatar] adaptation.
class SpaceAvatar extends StatelessWidget {
  final Space data;

  /// See [VoicesAvatar.onTap].
  final VoidCallback? onTap;

  /// See [VoicesAvatar.padding].
  final EdgeInsets padding;

  /// See [VoicesAvatar.radius].
  final double radius;

  const SpaceAvatar(
    this.data, {
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final config = data._config(context);

    return VoicesAvatar(
      icon: config.icon.buildIcon(),
      backgroundColor: config.backgroundColor,
      foregroundColor: config.foregroundColor,
      padding: padding,
      radius: radius,
    );
  }
}

final class _SpaceAvatarConfig {
  final SvgGenImage icon;
  final Color backgroundColor;
  final Color foregroundColor;

  _SpaceAvatarConfig({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}

extension _SpaceExt on Space {
  _SpaceAvatarConfig _config(BuildContext context) {
    final theme = Theme.of(context);

    return switch (this) {
      Space.treasury => _SpaceAvatarConfig(
          icon: VoicesAssets.icons.fund,
          backgroundColor: theme.colors.successContainer!,
          foregroundColor: theme.colors.iconsSuccess!,
        ),
      Space.discovery => _SpaceAvatarConfig(
          icon: VoicesAssets.icons.lightBulb,
          backgroundColor: theme.colors.iconsSecondary!.withOpacity(0.16),
          foregroundColor: theme.colors.iconsSecondary!,
        ),
      Space.workspace => _SpaceAvatarConfig(
          icon: VoicesAssets.icons.briefcase,
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.primary,
        ),
      Space.voting => _SpaceAvatarConfig(
          icon: VoicesAssets.icons.vote,
          backgroundColor: theme.colors.warningContainer!,
          foregroundColor: theme.colors.iconsWarning!,
        ),
      Space.fundedProjects => _SpaceAvatarConfig(
          icon: VoicesAssets.icons.flag,
          backgroundColor: theme.colors.iconsSecondary!.withOpacity(0.16),
          foregroundColor: theme.colors.iconsSecondary!,
        ),
    };
  }
}
