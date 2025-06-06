import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class RegistrationTile extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const RegistrationTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.primary;
    final foregroundColor = theme.colorScheme.onPrimary;
    final overlayColor = theme.filledButtonTheme.style?.overlayColor;

    final subtitle = this.subtitle;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 80),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          overlayColor: overlayColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                icon.buildIcon(
                  size: 48,
                  color: foregroundColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        key: const Key('RegistrationTileTitle'),
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(color: foregroundColor),
                      ),
                      if (subtitle != null)
                        Text(
                          key: const Key('RegistrationTileSubtitle'),
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: theme.textTheme.bodySmall?.copyWith(color: foregroundColor),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                VoicesAssets.icons.chevronRight.buildIcon(
                  color: foregroundColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
