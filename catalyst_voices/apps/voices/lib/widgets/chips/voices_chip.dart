import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A contextual chip acting as a label with some extra
/// small piece of information.
class VoicesChip extends StatelessWidget {
  /// The main content of the chip, usually a [Text] widget.
  final Widget content;

  /// The widget in front of the [content].
  final Widget? leading;

  /// The widget in back of the [content].
  final Widget? trailing;

  /// The color of the background, transparent by default.
  final Color? backgroundColor;

  /// The radius of rounded corners of the chip.
  final BorderRadius borderRadius;

  /// The internal padding from the widget borders to the internal content.
  final EdgeInsets padding;

  /// The callback called when the widget is tapped.
  final VoidCallback? onTap;

  /// The default constructor for the [VoicesChip].
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

  /// A constructor that creates a [VoicesChip] with fully rounded corners.
  const VoicesChip.round({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.onTap,
  }) : borderRadius = const BorderRadius.all(Radius.circular(32));

  /// A constructor that creates a [VoicesChip] with slightly rounded,
  /// rectangular corners.
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
    final iconTheme = IconTheme.of(context).copyWith(size: 18);
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
            child: AffixDecorator(
              iconTheme: iconTheme,
              prefix: leading,
              suffix: trailing,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.labelLarge!,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
