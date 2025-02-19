import 'dart:math';

import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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

  /// A custom icon. Overrides the default one specified by [type].
  final Widget? icon;

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

  /// The duration of the snackbar before it's automatically dismissed.
  ///
  /// Defaults to 4s.
  final Duration duration;

  /// The padding around the the [VoicesSnackBar].
  final EdgeInsetsGeometry? padding;

  /// The width of the [VoicesSnackBar].
  ///
  /// If null and [behavior] is [SnackBarBehavior.floating] then snackbar
  /// will calculate it's size using the following formula:
  /// - max(screenWidth * 0.4, 300)
  /// but no more than the screenWidth.
  final double? width;

  const VoicesSnackBar({
    super.key,
    required this.type,
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    this.onClosePressed,
    this.width,
    this.behavior = SnackBarBehavior.fixed,
    this.duration = const Duration(seconds: 4),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
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
                    icon: icon ?? type.icon().buildIcon(),
                    title: title ?? type.title(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text(
                      message ?? type.message(context),
                      style: textTheme.bodyMedium?.copyWith(
                        color: type.messageColor(context),
                      ),
                    ),
                  ),
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        spacing: 8,
                        children: actions,
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
                color: type.iconColor(context),
              ),
              onPressed: onClosePressed ?? () => hideCurrent(context),
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
        duration: duration,
        width: _calculateSnackBarWidth(
          screenWidth: MediaQuery.sizeOf(context).width,
        ),
        padding: padding,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  double? _calculateSnackBarWidth({required double screenWidth}) {
    switch (behavior) {
      case null:
      case SnackBarBehavior.fixed:
        // custom width not supported
        return null;
      case SnackBarBehavior.floating:
        return max(screenWidth * 0.4, 300).clamp(0.0, screenWidth).toDouble();
    }
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

    return AffixDecorator(
      prefix: IconTheme(
        data: IconThemeData(
          size: 20,
          color: type.iconColor(context),
        ),
        child: icon,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: type.titleColor(context),
          fontSize: textTheme.titleMedium?.fontSize,
          fontWeight: textTheme.titleMedium?.fontWeight,
          fontFamily: textTheme.titleMedium?.fontFamily,
        ),
      ),
    );
  }
}
