import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

enum _Variant { standard, primary, filled, tonal, outlined }

class VoicesIconButton extends StatelessWidget {
  /// The callback function invoked when the button is pressed.
  final VoidCallback? onTap;

  /// Allows for customization of style.
  final ButtonStyle? style;

  /// Icon widget for this button.
  final Widget child;

  final _Variant _variant;

  const VoicesIconButton({
    super.key,
    this.onTap,
    this.style,
    required this.child,
  }) : _variant = _Variant.standard;

  const VoicesIconButton.primary({
    super.key,
    this.onTap,
    this.style,
    required this.child,
  }) : _variant = _Variant.primary;

  const VoicesIconButton.filled({
    super.key,
    this.onTap,
    this.style,
    required this.child,
  }) : _variant = _Variant.filled;

  const VoicesIconButton.tonal({
    super.key,
    this.onTap,
    this.style,
    required this.child,
  }) : _variant = _Variant.tonal;

  const VoicesIconButton.outlined({
    super.key,
    this.onTap,
    this.style,
    required this.child,
  }) : _variant = _Variant.outlined;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: (style ?? const ButtonStyle()).merge(_buildVariantStyle(context)),
      icon: child,
    );
  }

  /// Majority of configuration takes takes places in theme builder
  /// so we need to override only new properties.
  ///
  /// See `catalyst.dart` file in `brands` package.
  ButtonStyle? _buildVariantStyle(BuildContext context) {
    final themeData = Theme.of(context);
    final colors = themeData.colors;
    final colorScheme = themeData.colorScheme;

    return switch (_variant) {
      /// Default themeData configuration corresponds with this variant.
      _Variant.standard => null,
      _Variant.primary => IconButton.styleFrom(
          foregroundColor: colors.iconsPrimary,
        ),
      _Variant.filled => IconButton.styleFrom(
          foregroundColor: colors.iconsBackground,
          backgroundColor: colorScheme.primary,
          disabledForegroundColor: colors.iconsDisabled,
          disabledBackgroundColor: colors.onSurfaceNeutral012,
        ),
      _Variant.tonal => IconButton.styleFrom(
          foregroundColor: colors.iconsForeground,
          backgroundColor: colors.onSurfacePrimary012,
          disabledForegroundColor: colors.iconsDisabled,
          disabledBackgroundColor: colors.onSurfaceNeutral012,
        ),
      _Variant.outlined => IconButton.styleFrom(
          foregroundColor: colors.iconsForeground,
          backgroundColor: Colors.transparent,
        ).copyWith(
          side: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colors.onSurfaceNeutral012!);
              }

              return BorderSide(color: colors.outlineBorderVariant!);
            },
          ),
        ),
    };
  }
}
