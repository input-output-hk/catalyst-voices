import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// [VoicesSnackBar] is a custom [SnackBar] widget that displays messages with
/// different types and actions.
///
/// [VoicesSnackBar] comes with different types (info, success, warning, error)
/// and optional actions such as primary, secondary, and close buttons.
class VoicesSnackBar extends StatelessWidget {
  /// The type of the [VoicesSnackBar],
  /// which determines its appearance and behavior.
  final VoicesSnackBarType type;

  /// A custom title. Overrides the default one specified by [type].
  final String? title;

  /// A custom message. Overrides the default one specified by [type].
  final String? message;

  /// The list of actions attached to the bottom of the snackBar.
  ///
  /// See [VoicesSnackBarPrimaryAction] and [VoicesSnackBarSecondaryAction].
  final List<Widget> actions;

  /// Callback function to be executed when the close button is pressed.
  final VoidCallback? onClosePressed;

  /// The behavior of the [VoicesSnackBar], which can be fixed or floating.
  final SnackBarBehavior? behavior;

  /// The padding around the the [VoicesSnackBar].
  final EdgeInsetsGeometry? padding;

  /// The width of the [VoicesSnackBar].
  final double? width;

  const VoicesSnackBar({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actions = const [],
    this.onClosePressed,
    this.width,
    this.behavior = SnackBarBehavior.fixed,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: type.backgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _IconAndTitle(
                    type: type,
                    icon: type.icon().buildIcon(
                          size: 20,
                          color: type.iconColor(context),
                        ),
                    title: title ?? type.title(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text(
                      message ?? type.message(context),
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: actions
                            .separatedBy(const SizedBox(width: 8))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: IconButton(
              icon: VoicesAssets.icons.x.buildIcon(
                size: 24,
                color: theme.colors.iconsForeground,
              ),
              onPressed: onClosePressed,
            ),
          ),
        ],
      ),
    );
  }

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: this,
        behavior: behavior,
        width: behavior == SnackBarBehavior.floating ? width : null,
        padding: padding,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static void hideCurrent(BuildContext context) =>
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

class _IconAndTitle extends StatelessWidget {
  final VoicesSnackBarType type;
  final Widget icon;
  final String title;

  const _IconAndTitle({
    required this.type,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: type.titleColor(context),
              fontSize: textTheme.titleMedium?.fontSize,
              fontWeight: textTheme.titleMedium?.fontWeight,
              fontFamily: textTheme.titleMedium?.fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
