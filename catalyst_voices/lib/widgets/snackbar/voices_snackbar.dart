import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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

  /// Function to be executed when the primary action button is pressed.
  final VoidCallback? onPrimaryPressed;

  /// Callback function to be executed when the secondary action button is
  /// pressed.
  final VoidCallback? onSecondaryPressed;

  /// Callback function to be executed when the close button is pressed.
  final VoidCallback? onClosePressed;

  /// The behavior of the [VoicesSnackBar], which can be fixed or floating.
  final SnackBarBehavior? behavior;

  /// The padding around the content of the [VoicesSnackBar].
  final EdgeInsetsGeometry? padding;

  /// The width of the [VoicesSnackBar].
  final double? width;

  const VoicesSnackBar({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onClosePressed,
    this.width,
    this.behavior = SnackBarBehavior.fixed,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: type.backgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: VoicesAssets.icons.x.buildIcon(
                size: 24,
                color: theme.colors.iconsForeground,
              ),
              onPressed: onClosePressed,
            ),
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    type.icon().buildIcon(
                          size: 20,
                          color: type.iconColor(context),
                        ),
                    const SizedBox(width: 16),
                    Text(
                      title ?? type.title(context),
                      style: TextStyle(
                        color: type.titleColor(context),
                        fontSize: textTheme.titleMedium?.fontSize,
                        fontWeight: textTheme.titleMedium?.fontWeight,
                        fontFamily: textTheme.titleMedium?.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48,
                ),
                child: Row(
                  children: [
                    Text(
                      message ?? type.message(context),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: onPrimaryPressed,
                      child: Text(
                        type == VoicesSnackBarType.success
                            ? l10n.snackbarOkButtonText
                            : l10n.snackbarRefreshButtonText,
                        style: TextStyle(
                          color: theme.colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onSecondaryPressed,
                      child: Text(
                        l10n.snackbarMoreButtonText,
                        style: TextStyle(
                          color: theme.colors.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
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
