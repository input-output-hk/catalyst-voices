import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A tooltip widget that renders Markdown formatted text with a child widget.
///
/// **Notes:**
/// - Supports Markdown syntax in the message
/// - The tooltip's text is constrained to a maximum
/// width of 200 pixels by default
///
/// **Usage:**
/// ```dart
/// VoicesMarkdownTooltip(
///   message: "**Bold** and *italic* text",
///   child: Icon(Icons.info),
/// )
/// ```
class VoicesMarkdownTooltip extends StatelessWidget {
  /// The Markdown formatted message to display in the tooltip.
  final String message;

  /// Optional widget that will be shown before the Markdown content.
  final Widget? leading;

  /// Optional widget that will be shown after the Markdown content.
  final Widget? trailing;

  /// Optional constraints for tooltip widget.
  final BoxConstraints constraints;

  /// The widget that triggers tooltip visibility.
  final Widget child;

  const VoicesMarkdownTooltip({
    super.key,
    required this.message,
    this.leading,
    this.trailing,
    this.constraints = const BoxConstraints(maxWidth: 200),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colors.iconsBackground,
    );

    return Tooltip(
      key: const Key('MarkdownTooltip'),
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          key: const ValueKey('VoicesMarkdownTooltipContentKey'),
          constraints: constraints,
          child: DefaultTextStyle(
            style: textStyle,
            child: AffixDecorator(
              prefix: leading,
              suffix: trailing,
              gap: 12,
              child: MarkdownText(
                MarkdownData(message),
                pColor: context.colors.textOnPrimaryLevel0,
              ),
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2,
            color: Color(0x02600000),
          ),
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color(0x4D000000),
          ),
        ],
      ),
      child: child,
    );
  }
}
