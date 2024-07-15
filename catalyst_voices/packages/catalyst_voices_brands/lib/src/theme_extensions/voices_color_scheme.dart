import 'package:flutter/material.dart';

/// A `ThemeExtension` that encapsulates a set color properties and extends the
/// standard material color scheme.
///
/// `VoicesColorScheme` is used to define a comprehensive set of color
/// attributes that can be used in the Voices application to ensure consistency.
@immutable
class VoicesColorScheme extends ThemeExtension<VoicesColorScheme> {
  final Color? textPrimary;
  final Color? textOnPrimary;
  final Color? textOnPrimaryContainer;
  final Color? textDisabled;
  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? onSurfaceNeutral08;
  final Color? onSurfaceNeutral012;
  final Color? onSurfaceNeutral016;
  final Color? onSurfaceNeutralOpaqueLv0;
  final Color? onSurfaceNeutralOpaqueLv1;
  final Color? onSurfaceNeutralOpaqueLv2;
  final Color? onSurfacePrimaryContainer;
  final Color? onSurfacePrimary08;
  final Color? onSurfacePrimary012;
  final Color? onSurfacePrimary016;
  final Color? onSurfaceSecondary08;
  final Color? onSurfaceSecondary012;
  final Color? onSurfaceSecondary016;
  final Color? onSurfaceError08;
  final Color? onSurfaceError012;
  final Color? onSurfaceError016;
  final Color? iconsForeground;
  final Color? iconsBackground;
  final Color? iconsDisabled;
  final Color? iconsPrimary;
  final Color? iconsSecondary;
  final Color? iconsSuccess;
  final Color? iconsWarning;
  final Color? iconsError;
  final Color? avatarsPrimary;
  final Color? avatarsSecondary;
  final Color? avatarsSuccess;
  final Color? avatarsWarning;
  final Color? avatarsError;
  final Color? elevationsOnSurfaceNeutralLv0;
  final Color? outlineBorder;
  final Color? outlineBorderVariant;

  const VoicesColorScheme({
    required this.textPrimary,
    required this.textOnPrimary,
    required this.textOnPrimaryContainer,
    required this.textDisabled,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.onSurfaceNeutral08,
    required this.onSurfaceNeutral012,
    required this.onSurfaceNeutral016,
    required this.onSurfacePrimaryContainer,
    required this.onSurfacePrimary08,
    required this.onSurfacePrimary012,
    required this.onSurfacePrimary016,
    required this.onSurfaceNeutralOpaqueLv0,
    required this.onSurfaceNeutralOpaqueLv1,
    required this.onSurfaceNeutralOpaqueLv2,
    required this.onSurfaceSecondary08,
    required this.onSurfaceSecondary012,
    required this.onSurfaceSecondary016,
    required this.onSurfaceError08,
    required this.onSurfaceError012,
    required this.onSurfaceError016,
    required this.iconsForeground,
    required this.iconsBackground,
    required this.iconsDisabled,
    required this.iconsPrimary,
    required this.iconsSecondary,
    required this.iconsSuccess,
    required this.iconsWarning,
    required this.iconsError,
    required this.avatarsPrimary,
    required this.avatarsSecondary,
    required this.avatarsSuccess,
    required this.avatarsWarning,
    required this.avatarsError,
    required this.elevationsOnSurfaceNeutralLv0,
    required this.outlineBorder,
    required this.outlineBorderVariant,
  });

  @override
  ThemeExtension<VoicesColorScheme> copyWith({
    Color? textPrimary,
    Color? textOnPrimary,
    Color? textOnPrimaryContainer,
    Color? textDisabled,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? onSurfaceNeutral08,
    Color? onSurfaceNeutral012,
    Color? onSurfaceNeutral016,
    Color? onSurfaceNeutralOpaqueLv0,
    Color? onSurfaceNeutralOpaqueLv1,
    Color? onSurfaceNeutralOpaqueLv2,
    Color? onSurfacePrimaryContainer,
    Color? onSurfacePrimary08,
    Color? onSurfacePrimary012,
    Color? onSurfacePrimary016,
    Color? onSurfaceSecondary08,
    Color? onSurfaceSecondary012,
    Color? onSurfaceSecondary016,
    Color? onSurfaceError08,
    Color? onSurfaceError012,
    Color? onSurfaceError016,
    Color? iconsForeground,
    Color? iconsBackground,
    Color? iconsDisabled,
    Color? iconsPrimary,
    Color? iconsSecondary,
    Color? iconsSuccess,
    Color? iconsWarning,
    Color? iconsError,
    Color? avatarsPrimary,
    Color? avatarsSecondary,
    Color? avatarsSuccess,
    Color? avatarsWarning,
    Color? avatarsError,
    Color? elevationsOnSurfaceNeutralLv0,
    Color? outlineBorder,
    Color? outlineBorderVariant,
  }) {
    return VoicesColorScheme(
      textPrimary: textPrimary ?? this.textPrimary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnPrimaryContainer:
          textOnPrimaryContainer ?? this.textOnPrimaryContainer,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      onSurfaceNeutral08: onSurfaceNeutral08 ?? this.onSurfaceError08,
      onSurfaceNeutral012: onSurfaceNeutral012 ?? this.onSurfaceError012,
      onSurfaceNeutral016: onSurfaceNeutral016 ?? this.onSurfaceError016,
      onSurfaceNeutralOpaqueLv0:
          onSurfaceNeutralOpaqueLv0 ?? this.onSurfaceNeutralOpaqueLv0,
      onSurfaceNeutralOpaqueLv1:
          onSurfaceNeutralOpaqueLv0 ?? this.onSurfaceNeutralOpaqueLv1,
      onSurfaceNeutralOpaqueLv2:
          onSurfaceNeutralOpaqueLv0 ?? this.onSurfaceNeutralOpaqueLv2,
      onSurfacePrimaryContainer:
          onSurfacePrimaryContainer ?? this.onSurfacePrimaryContainer,
      onSurfacePrimary08: onSurfacePrimary08 ?? this.onSurfacePrimary08,
      onSurfacePrimary012: onSurfacePrimary012 ?? this.onSurfacePrimary012,
      onSurfacePrimary016: onSurfacePrimary016 ?? this.onSurfacePrimary016,
      onSurfaceSecondary08: onSurfaceSecondary08 ?? this.onSurfaceSecondary08,
      onSurfaceSecondary012:
          onSurfaceSecondary012 ?? this.onSurfaceSecondary012,
      onSurfaceSecondary016:
          onSurfaceSecondary016 ?? this.onSurfaceSecondary016,
      onSurfaceError08: onSurfaceError08 ?? this.onSurfaceError08,
      onSurfaceError012: onSurfaceError012 ?? this.onSurfaceError012,
      onSurfaceError016: onSurfaceError016 ?? this.onSurfaceError016,
      iconsForeground: iconsForeground ?? this.iconsForeground,
      iconsBackground: iconsBackground ?? this.iconsBackground,
      iconsDisabled: iconsDisabled ?? this.iconsDisabled,
      iconsPrimary: iconsPrimary ?? this.iconsPrimary,
      iconsSecondary: iconsSecondary ?? this.iconsSecondary,
      iconsSuccess: iconsSuccess ?? this.iconsSuccess,
      iconsWarning: iconsWarning ?? this.iconsWarning,
      iconsError: iconsError ?? this.iconsError,
      avatarsPrimary: avatarsPrimary ?? this.avatarsPrimary,
      avatarsSecondary: avatarsSecondary ?? this.avatarsSecondary,
      avatarsSuccess: avatarsSuccess ?? this.avatarsSuccess,
      avatarsWarning: avatarsWarning ?? this.avatarsWarning,
      avatarsError: avatarsError ?? this.avatarsError,
      elevationsOnSurfaceNeutralLv0:
          elevationsOnSurfaceNeutralLv0 ?? this.elevationsOnSurfaceNeutralLv0,
      outlineBorder: outlineBorder ?? this.outlineBorder,
      outlineBorderVariant: outlineBorderVariant ?? this.outlineBorderVariant,
    );
  }

  @override
  VoicesColorScheme lerp(
    ThemeExtension<VoicesColorScheme>? other,
    double t,
  ) {
    if (other is! VoicesColorScheme) {
      return this;
    }
    return VoicesColorScheme(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t),
      textOnPrimaryContainer:
          Color.lerp(textOnPrimaryContainer, other.textOnPrimaryContainer, t),
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t),
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t),
      onSurfaceNeutral08:
          Color.lerp(onSurfaceNeutral08, other.onSurfaceNeutral08, t),
      onSurfaceNeutral012:
          Color.lerp(onSurfaceNeutral012, other.onSurfaceNeutral012, t),
      onSurfaceNeutral016:
          Color.lerp(onSurfaceNeutral016, other.onSurfaceNeutral016, t),
      onSurfaceNeutralOpaqueLv0: Color.lerp(
        onSurfaceNeutralOpaqueLv0,
        other.onSurfaceNeutralOpaqueLv0,
        t,
      ),
      onSurfaceNeutralOpaqueLv1: Color.lerp(
        onSurfaceNeutralOpaqueLv1,
        other.onSurfaceNeutralOpaqueLv1,
        t,
      ),
      onSurfaceNeutralOpaqueLv2: Color.lerp(
        onSurfaceNeutralOpaqueLv2,
        other.onSurfaceNeutralOpaqueLv2,
        t,
      ),
      onSurfacePrimaryContainer: Color.lerp(
        onSurfacePrimaryContainer,
        other.onSurfacePrimaryContainer,
        t,
      ),
      onSurfacePrimary08:
          Color.lerp(onSurfacePrimary08, other.onSurfacePrimary08, t),
      onSurfacePrimary012:
          Color.lerp(onSurfacePrimary012, other.onSurfacePrimary012, t),
      onSurfacePrimary016:
          Color.lerp(onSurfacePrimary016, other.onSurfacePrimary016, t),
      onSurfaceSecondary08:
          Color.lerp(onSurfaceSecondary08, other.onSurfaceSecondary08, t),
      onSurfaceSecondary012:
          Color.lerp(onSurfaceSecondary012, other.onSurfaceSecondary012, t),
      onSurfaceSecondary016:
          Color.lerp(onSurfaceSecondary016, other.onSurfaceSecondary016, t),
      onSurfaceError08: Color.lerp(onSurfaceError08, other.onSurfaceError08, t),
      onSurfaceError012:
          Color.lerp(onSurfaceError012, other.onSurfaceError012, t),
      onSurfaceError016:
          Color.lerp(onSurfaceError016, other.onSurfaceError016, t),
      iconsForeground: Color.lerp(iconsForeground, other.iconsForeground, t),
      iconsBackground: Color.lerp(iconsBackground, other.iconsBackground, t),
      iconsDisabled: Color.lerp(iconsDisabled, other.iconsDisabled, t),
      iconsPrimary: Color.lerp(iconsPrimary, other.iconsPrimary, t),
      iconsSecondary: Color.lerp(iconsSecondary, other.iconsSecondary, t),
      iconsSuccess: Color.lerp(iconsSuccess, other.iconsSuccess, t),
      iconsWarning: Color.lerp(iconsWarning, other.iconsWarning, t),
      iconsError: Color.lerp(iconsError, other.iconsError, t),
      avatarsPrimary: Color.lerp(avatarsPrimary, other.avatarsPrimary, t),
      avatarsSecondary: Color.lerp(avatarsSecondary, other.avatarsSecondary, t),
      avatarsSuccess: Color.lerp(avatarsSuccess, other.avatarsSuccess, t),
      avatarsWarning: Color.lerp(avatarsWarning, other.avatarsWarning, t),
      avatarsError: Color.lerp(avatarsError, other.avatarsError, t),
      elevationsOnSurfaceNeutralLv0: Color.lerp(
        elevationsOnSurfaceNeutralLv0,
        other.elevationsOnSurfaceNeutralLv0,
        t,
      ),
      outlineBorder: Color.lerp(outlineBorder, other.outlineBorder, t),
      outlineBorderVariant:
          Color.lerp(outlineBorderVariant, other.outlineBorderVariant, t),
    );
  }
}

extension VoicesColorSchemeExtension on ThemeData {
  VoicesColorScheme get colors => extension<VoicesColorScheme>()!;
  Color get linksPrimary => primaryColor;
}
