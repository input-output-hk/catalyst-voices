import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_button_affix_decoration.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A button with a gradient background.
///
/// This widget provides a filled button with a customizable gradient background.
/// When disabled, the button will appear with reduced opacity.
class VoicesGradientButton extends StatelessWidget {
  /// The callback function invoked when the button is pressed.
  final VoidCallback? onTap;

  /// The widget to be displayed before the button's main content.
  final Widget? leading;

  /// The widget to be displayed after the button's main content.
  final Widget? trailing;

  /// The gradient to use for the button background.
  final Gradient? gradient;

  final BorderRadius borderRadius;

  final EdgeInsetsGeometry padding;

  /// The opacity when the button is disabled.
  final double disabledOpacity;

  /// The main content of the button.
  final Widget child;

  const VoicesGradientButton({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
    this.disabledOpacity = 0.38,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final effectiveGradient = gradient ?? context.colorScheme.votingGradient;
    final foregroundColor = context.colors.textOnPrimaryWhite;

    return Opacity(
      opacity: isEnabled ? 1.0 : disabledOpacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: borderRadius,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            splashColor: foregroundColor.withValues(alpha: 0.2),
            child: Padding(
              padding: padding,
              child: Center(
                child: DefaultTextStyle(
                  style:
                      context.textTheme.labelLarge?.copyWith(color: foregroundColor) ??
                      TextStyle(color: foregroundColor),
                  child: IconTheme(
                    data: IconThemeData(
                      color: foregroundColor,
                    ),
                    child: VoicesButtonAffixDecoration(
                      leading: leading,
                      trailing: trailing,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
