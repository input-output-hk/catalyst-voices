import 'package:catalyst_voices/widgets/buttons/voices_button_affix_decoration.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

enum _Variant { primary, neutral, secondary, custom }

/// A button that combines a `TextButton` with optional leading and trailing
/// elements.
///
/// This widget provides a convenient way to add icons or other widgets before
/// or after the button's child.
class VoicesTextButton extends StatelessWidget {
  /// The callback function invoked when the button is pressed.
  final VoidCallback? onTap;

  /// The widget to be displayed before the button's main content.
  final Widget? leading;

  /// The widget to be displayed after the button's main content.
  final Widget? trailing;

  /// The main content of the button.
  final Widget child;

  /// The foreground color of the button.
  final Color? color;

  final _Variant _variant;

  const VoicesTextButton({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    required this.child,
  }) : _variant = _Variant.primary;

  const VoicesTextButton.neutral({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    required this.child,
  }) : _variant = _Variant.neutral;

  const VoicesTextButton.secondary({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.color,
    required this.child,
  }) : _variant = _Variant.secondary;

  const VoicesTextButton.custom({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    required this.color,
    required this.child,
  }) : _variant = _Variant.custom;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: _buildVariantStyle(context),
      child: VoicesButtonAffixDecoration(
        leading: leading,
        trailing: trailing,
        child: child,
      ),
    );
  }

  /// Majority of configuration takes takes places in theme builder
  /// so we need to override only new properties.
  ///
  /// See `catalyst.dart` file in `brands` package.
  ButtonStyle? _buildVariantStyle(BuildContext context) {
    return switch (_variant) {
      /// Default theme configuration corresponds with this variant
      _Variant.primary => null,
      _Variant.neutral => TextButton.styleFrom(
          foregroundColor: Theme.of(context).colors.textPrimary,
        ),
      _Variant.secondary => TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.secondary,
        ),
      _Variant.custom => TextButton.styleFrom(
          foregroundColor: color,
        ),
    };
  }
}
