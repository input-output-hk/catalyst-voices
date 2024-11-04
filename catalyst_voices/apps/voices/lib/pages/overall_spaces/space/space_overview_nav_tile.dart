import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SpaceOverviewNavTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const SpaceOverviewNavTile({
    super.key,
    required this.leading,
    required this.title,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconTheme = IconThemeData(
      size: 24,
      color: theme.colors.iconsForeground,
    );

    final textStyle =
        (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel0,
    );

    return IconTheme(
      data: iconTheme,
      child: DefaultTextStyle(
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 56),
          child: Material(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            textStyle: textStyle,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: 12),
                    Expanded(child: title),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
