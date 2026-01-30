import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/separators/voices_divider.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final Widget icon;
  final Color? iconBackgroundColor;
  final EdgeInsets iconPadding;
  final Widget? title;
  final Widget desc;
  final Widget? statusIcon;
  final Widget? body;
  final bool isExpanded;

  const ActionCard({
    super.key,
    required this.icon,
    this.iconBackgroundColor,
    this.iconPadding = const EdgeInsets.all(8),
    this.title,
    required this.desc,
    this.statusIcon,
    this.body,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleTextStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel1,
    );

    final descTextStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel1,
    );

    final title = this.title;
    final statusIcon = this.statusIcon;

    return Material(
      color: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12).add(const EdgeInsets.only(left: 4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconContainer(
              iconBackgroundColor: iconBackgroundColor,
              iconPadding: iconPadding,
              child: icon,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    DefaultTextStyle(
                      style: titleTextStyle,
                      child: title,
                    ),
                    const SizedBox(height: 2),
                  ],
                  DefaultTextStyle(
                    style: descTextStyle,
                    child: desc,
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    const VoicesDivider(indent: 0, endIndent: 0),
                    const SizedBox(height: 10),
                    if (body != null) body!,
                  ],
                ],
              ),
            ),
            if (statusIcon != null) _StatusIconAvatar(icon: statusIcon),
          ].separatedBy(const SizedBox(width: 12)).toList(),
        ),
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final Widget child;
  final Color? iconBackgroundColor;
  final EdgeInsets iconPadding;

  const _IconContainer({
    required this.child,
    this.iconBackgroundColor,
    required this.iconPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconThemeData = IconThemeData(
      size: 38,
      color: theme.colors.iconsBackground,
    );

    return DecoratedBox(
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconBackgroundColor ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconTheme(
        data: iconThemeData,
        child: child,
      ),
    );
  }
}

class _StatusIconAvatar extends StatelessWidget {
  final Widget icon;

  const _StatusIconAvatar({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesAvatar(
      radius: 15,
      padding: const EdgeInsets.all(3),
      backgroundColor: theme.colors.elevationsOnSurfaceNeutralLv1White,
      foregroundColor: theme.colorScheme.primary,
      icon: icon,
    );
  }
}
