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
      size: 18,
      color: config.iconColor,
    );

    final textStyle = (theme.textTheme.labelLarge ?? TextStyle()).copyWith(
      color: config.textColor,
    );

    return IconTheme(
      data: iconTheme,
      child: DefaultTextStyle(
        style: textStyle,
        child: Container(
          padding: EdgeInsets.all(8).add(EdgeInsets.only(right: 4)),
          decoration: BoxDecoration(
            color: config.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(config.iconData),
              SizedBox(width: 8),
              Text(config.text)
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProposalStatusContainerConfig {
  final IconData iconData;
  final Color? iconColor;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  _ProposalStatusContainerConfig({
    required this.iconData,
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
          iconData: CatalystVoicesIcons.check,
          iconColor: colors.iconsSuccess,
          text: context.l10n.proposalStatusReady,
          textColor: colors.textPrimary,
          backgroundColor: colors.successContainer,
        ),
      ProposalStatus.draft => _ProposalStatusContainerConfig(
          iconData: CatalystVoicesIcons.pencil_alt,
          iconColor: colors.iconsForeground,
          text: context.l10n.proposalStatusDraft,
          textColor: colors.textPrimary,
          backgroundColor: colors.onSurfaceNeutralOpaqueLv1,
        ),
    };
  }
}
