import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A simple tooltip widget with a plain text message and a child widget.
///
/// **Notes:**
/// - The tooltip's colors might need to be adjusted based on the final design.
/// - The tooltip's text is constrained to a maximum width of 200 pixels.
///
/// **Usage:**
/// ```dart
/// VoicesPlainTooltip(
///   message: "This is a tooltip message.",
///   child: Icon(Icons.info),
/// )
/// ```
class VoicesPlainTooltip extends StatelessWidget {
  /// The text message to display in the tooltip.
  final String message;

  /// Optional widget that will be shown before [message].
  final Widget? leading;

  /// Optional widget that will be shown after [message].
  final Widget? trailing;

  /// The widget that triggers tooltip visibility.
  final Widget child;

  const VoicesPlainTooltip({
    super.key,
    required this.message,
    this.leading,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colors.iconsBackground,
    );

    return Tooltip(
      key: const Key('Tooltip'),
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          key: const ValueKey('VoicesPlainTooltipContentKey'),
          constraints: const BoxConstraints(maxWidth: 200),
          child: DefaultTextStyle(
            style: textStyle,
            child: AffixDecorator(
              prefix: leading,
              suffix: trailing,
              gap: 12,
              child: Text(message),
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colors.iconsForeground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
