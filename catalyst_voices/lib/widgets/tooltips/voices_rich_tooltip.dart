import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

final class VoicesRichTooltipActionData {
  final String name;
  final VoidCallback onTap;

  VoicesRichTooltipActionData({
    required this.name,
    required this.onTap,
  });
}

/// A tooltip widget with a rich text message (title and message) and
/// optional actions displayed at the bottom.
///
/// **Notes:**
/// - The tooltip's maximum width is constrained to 312 pixels.
/// - The tooltip's background color and shadow are theme-dependent.
/// - If no actions are provided, the tooltip can be dismissed by tapping
///   anywhere on it. Otherwise, tapping will only trigger the action button
///   taps which will dismiss all tooltips see [Tooltip.dismissAllToolTips].
///
/// **Example Usage:**
/// ```dart
/// final actions = [
///   VoicesRichTooltipActionData(
///     name: "Edit",
///     onTap: () => print("Edit tapped"),
///   ),
///   VoicesRichTooltipActionData(
///     name: "Delete",
///     onTap: () => print("Delete tapped"),
///   ),
/// ];
///
/// VoicesRichTooltip(
///   title: "Tooltip Title",
///   message: "This is a tooltip with a descriptive message.",
///   actions: actions,
///   child: Icon(Icons.info),
/// )
/// ```
class VoicesRichTooltip extends StatelessWidget {
  /// The main title displayed at the top of the tooltip.
  final String title;

  /// The descriptive message displayed below the title.
  final String message;

  /// (Optional) A list of action buttons displayed at the
  /// bottom of the tooltip. Each action has a `name` and an `onTap` callback.
  final List<VoicesRichTooltipActionData> actions;

  /// The widget that triggers tooltip visibility.
  final Widget child;

  const VoicesRichTooltip({
    super.key,
    required this.title,
    required this.message,
    this.actions = const [],
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return Tooltip(
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          key: const ValueKey('VoicesRichTooltipContentKey'),
          constraints: const BoxConstraints(maxWidth: 312),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Content(title, message),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 8),
                _ActionsRow(actions),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colors.onSurfaceNeutralOpaqueLv2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLightTheme ? kElevationToShadow[2] : null,
      ),
      enableTapToDismiss: actions.isEmpty,
      child: child,
    );
  }
}

class _Content extends StatelessWidget {
  final String title;
  final String message;

  const _Content(
    this.title,
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
          .add(const EdgeInsets.only(top: 8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colors.textPrimary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colors.textPrimary,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow(this.actions);

  final List<VoicesRichTooltipActionData> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: actions
            .map<Widget>(
              (action) {
                return VoicesTextButton(
                  onTap: () {
                    Tooltip.dismissAllToolTips();
                    action.onTap();
                  },
                  child: Text(action.name),
                );
              },
            )
            .separatedBy(const SizedBox(width: 8))
            .toList(),
      ),
    );
  }
}
