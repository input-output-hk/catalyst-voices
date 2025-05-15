import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalStatusContainer extends StatelessWidget {
  final ProposalStatus type;

  const ProposalStatusContainer({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = type._config(context);

    final iconTheme = IconThemeData(
      size: 16,
      color: config.iconColor,
    );

    final textStyle =
        (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: config.textColor,
    );

    return IconTheme(
      data: iconTheme,
      child: DefaultTextStyle(
        style: textStyle,
        child: Container(
          padding: const EdgeInsets.all(8).add(const EdgeInsets.only(right: 4)),
          decoration: BoxDecoration(
            color: config.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              config.icon.buildIcon(),
              const SizedBox(width: 8),
              Text(config.text),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProposalStatusContainerConfig {
  final SvgGenImage icon;
  final Color? iconColor;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  _ProposalStatusContainerConfig({
    required this.icon,
    this.iconColor,
    required this.text,
    this.textColor,
    this.backgroundColor,
  });
}

extension _ProposalStatusExt on ProposalStatus {
  _ProposalStatusContainerConfig _config(BuildContext context) {
    final colors = Theme.of(context).colors;

    return switch (this) {
      ProposalStatus.ready => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.check,
          iconColor: colors.iconsSuccess,
          text: context.l10n.proposalStatusReady,
          textColor: colors.textPrimary,
          backgroundColor: colors.successContainer,
        ),
      ProposalStatus.draft => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.pencilAlt,
          iconColor: colors.iconsForeground,
          text: context.l10n.draft,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
      ProposalStatus.inProgress => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.annotation,
          iconColor: colors.iconsPrimary,
          text: context.l10n.inProgress,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
      ProposalStatus.private => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.eyeOff,
          iconColor: colors.iconsForeground,
          text: context.l10n.private,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
      ProposalStatus.open => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.checkCircle,
          iconColor: colors.iconsSuccess,
          text: context.l10n.open,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
      ProposalStatus.live => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.play,
          iconColor: colors.iconsForeground,
          text: context.l10n.live.toUpperCase(),
          textColor: colors.textPrimary,
          backgroundColor: colors.successContainer,
        ),
      ProposalStatus.completed => _ProposalStatusContainerConfig(
          icon: VoicesAssets.icons.flag,
          iconColor: colors.iconsForeground,
          text: context.l10n.completed,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
    };
  }
}
