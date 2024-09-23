import 'package:flutter/material.dart';

/// A circular icon on a background. Usually represents a user profile.
///
/// [icon] by default will be spaced at 24 logical pixels
/// unless it provides it's own size.
class VoicesAvatar extends StatelessWidget {
  /// The main content of the chip, usually an [Icon] or [Text] widget.
  final Widget icon;

  /// The color of the foreground [icon], [ColorScheme.primary] by default
  final Color? foregroundColor;

  /// The color of the background,
  /// [ColorScheme.primaryContainer] by default.
  final Color? backgroundColor;

  /// The internal padding from the widget borders to the internal content.
  final EdgeInsets padding;

  /// The size of the avatar, expressed as the radius (half the diameter).
  final double radius;

  /// The border around the widget.
  final Border? border;

  /// The callback called when the widget is tapped.
  final VoidCallback? onTap;

  /// The default constructor for the [VoicesAvatar].
  const VoicesAvatar({
    super.key,
    required this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.radius = 20,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius * 2),
          child: Center(
            child: Padding(
              padding: padding,
              child: IconTheme(
                data: IconTheme.of(context).copyWith(
                  size: 24,
                  color:
                      foregroundColor ?? Theme.of(context).colorScheme.primary,
                ),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        height: 1,
                        color: foregroundColor ??
                            Theme.of(context).colorScheme.primary,
                      ),
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
