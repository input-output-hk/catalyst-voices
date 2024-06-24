import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesChip extends StatelessWidget {
  final Widget content;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const VoicesChip({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
    required this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.onTap,
  });

  const VoicesChip.round({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.onTap,
  }) : borderRadius = const BorderRadius.all(Radius.circular(32));

  const VoicesChip.rectangular({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.onTap,
  }) : borderRadius = const BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: backgroundColor != null
            ? null
            : Border.all(
                color: Theme.of(context).colors.outlineBorderVariant!,
              ),
        borderRadius: borderRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: IconTheme(
                      data: const IconThemeData(size: 18),
                      child: leading!,
                    ),
                  ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.labelLarge!,
                  child: content,
                ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: IconTheme(
                      data: const IconThemeData(size: 18),
                      child: trailing!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
