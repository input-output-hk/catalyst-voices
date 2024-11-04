import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UpdateReady extends StatelessWidget {
  final VoidCallback? onTap;

  const UpdateReady({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = TextStyle(
      color: theme.colors.textOnPrimaryLevel0,
    );
    final iconTheme = IconThemeData(
      color: theme.colors.iconsForeground,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: IconTheme(
        data: iconTheme,
        child: Material(
          color: theme.colors.elevationsOnSurfaceNeutralLv1White,
          borderRadius: BorderRadius.circular(12),
          textStyle: textStyle,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _UpdateReadyText(),
                      _ClickToRestartText(),
                    ],
                  ),
                  SizedBox(width: 16),
                  _DownloadIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateReadyText extends StatelessWidget {
  const _UpdateReadyText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.voicesUpdateReady,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _ClickToRestartText extends StatelessWidget {
  const _ClickToRestartText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.clickToRestart,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _DownloadIcon extends StatelessWidget {
  const _DownloadIcon();

  @override
  Widget build(BuildContext context) {
    return VoicesAssets.icons.cloudDownload.buildIcon();
  }
}
