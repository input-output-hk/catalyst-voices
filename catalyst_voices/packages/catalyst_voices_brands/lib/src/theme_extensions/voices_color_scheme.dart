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
  final Color? textOnPrimaryLevel0;
  final Color? textOnPrimaryLevel1;
  final Color? textOnPrimaryWhite;
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
  final Color? iconsBackgroundVariant;
  final Color? iconsOnImage;
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
  final Color? elevationsOnSurfaceNeutralLv1Grey;
  final Color? elevationsOnSurfaceNeutralLv1White;
  final Color? elevationsOnSurfaceNeutralLv2;
  final Color? outlineBorder;
  final Color? outlineBorderVariant;
  final Color? primary98;
  final Color? primaryContainer;
  final Color? onPrimaryContainer;
  final Color? onErrorVariant;
  final Color? errorContainer;
  final Color? onErrorContainer;

  const VoicesColorScheme({
    required this.textPrimary,
    required this.textOnPrimary,
    required this.textOnPrimaryLevel0,
    required this.textOnPrimaryLevel1,
    required this.textOnPrimaryWhite,
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
    required this.iconsBackgroundVariant,
    required this.iconsOnImage,
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
    required this.elevationsOnSurfaceNeutralLv1Grey,
    required this.elevationsOnSurfaceNeutralLv1White,
    required this.elevationsOnSurfaceNeutralLv2,
    required this.outlineBorder,
    required this.outlineBorderVariant,
    required this.primary98,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.onErrorVariant,
    required this.errorContainer,
    required this.onErrorContainer,
  });

  @visibleForTesting
  const VoicesColorScheme.optional({
    this.textPrimary,
    this.textOnPrimary,
    this.textOnPrimaryLevel0,
    this.textOnPrimaryLevel1,
    this.textOnPrimaryWhite,
    this.textOnPrimaryContainer,
    this.textDisabled,
    this.success,
    this.onSuccess,
    this.successContainer,
    this.onSuccessContainer,
    this.warning,
    this.onWarning,
    this.warningContainer,
    this.onWarningContainer,
    this.onSurfaceNeutral08,
    this.onSurfaceNeutral012,
    this.onSurfaceNeutral016,
    this.onSurfacePrimaryContainer,
    this.onSurfacePrimary08,
    this.onSurfacePrimary012,
    this.onSurfacePrimary016,
    this.onSurfaceNeutralOpaqueLv0,
    this.onSurfaceNeutralOpaqueLv1,
    this.onSurfaceNeutralOpaqueLv2,
    this.onSurfaceSecondary08,
    this.onSurfaceSecondary012,
    this.onSurfaceSecondary016,
    this.onSurfaceError08,
    this.onSurfaceError012,
    this.onSurfaceError016,
    this.iconsForeground,
    this.iconsBackground,
    this.iconsBackgroundVariant,
    this.iconsOnImage,
    this.iconsDisabled,
    this.iconsPrimary,
    this.iconsSecondary,
    this.iconsSuccess,
    this.iconsWarning,
    this.iconsError,
    this.avatarsPrimary,
    this.avatarsSecondary,
    this.avatarsSuccess,
    this.avatarsWarning,
    this.avatarsError,
    this.elevationsOnSurfaceNeutralLv0,
    this.elevationsOnSurfaceNeutralLv1Grey,
    this.elevationsOnSurfaceNeutralLv1White,
    this.elevationsOnSurfaceNeutralLv2,
    this.outlineBorder,
    this.outlineBorderVariant,
    this.primary98,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.onErrorVariant,
    this.errorContainer,
    this.onErrorContainer,
  });

  @override
  ThemeExtension<VoicesColorScheme> copyWith({
    Color? textPrimary,
    Color? textOnPrimary,
    Color? textOnPrimaryLevel0,
    Color? textOnPrimaryLevel1,
    Color? textOnPrimaryWhite,
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
    Color? iconsBackgroundVariant,
    Color? iconsOnImage,
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
    Color? elevationsOnSurfaceNeutralLv1Grey,
    Color? elevationsOnSurfaceNeutralLv1White,
    Color? elevationsOnSurfaceNeutralLv2,
    Color? outlineBorder,
    Color? outlineBorderVariant,
    Color? primary98,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? onErrorVariant,
    Color? errorContainer,
    Color? onErrorContainer,
  }) {
    return VoicesColorScheme(
      textPrimary: textPrimary ?? this.textPrimary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnPrimaryLevel0: textOnPrimaryLevel0 ?? this.textOnPrimaryLevel0,
      textOnPrimaryLevel1: textOnPrimaryLevel1 ?? this.textOnPrimaryLevel1,
      textOnPrimaryWhite: textOnPrimaryWhite ?? this.textOnPrimaryWhite,
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
      iconsBackgroundVariant:
          iconsBackgroundVariant ?? this.iconsBackgroundVariant,
      iconsOnImage: iconsOnImage ?? this.iconsOnImage,
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
      elevationsOnSurfaceNeutralLv1Grey: elevationsOnSurfaceNeutralLv1Grey ??
          this.elevationsOnSurfaceNeutralLv1Grey,
      elevationsOnSurfaceNeutralLv1White: elevationsOnSurfaceNeutralLv1White ??
          this.elevationsOnSurfaceNeutralLv1White,
      elevationsOnSurfaceNeutralLv2:
          elevationsOnSurfaceNeutralLv2 ?? this.elevationsOnSurfaceNeutralLv2,
      outlineBorder: outlineBorder ?? this.outlineBorder,
      outlineBorderVariant: outlineBorderVariant ?? this.outlineBorderVariant,
      primary98: primary98 ?? this.primary98,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      onErrorVariant: onErrorVariant ?? this.onErrorVariant,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
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
      textOnPrimaryLevel0: Color.lerp(
        textOnPrimaryLevel0,
        other.textOnPrimaryLevel0,
        t,
      ),
      textOnPrimaryLevel1: Color.lerp(
        textOnPrimaryLevel1,
        other.textOnPrimaryLevel1,
        t,
      ),
      textOnPrimaryWhite: Color.lerp(
        textOnPrimaryWhite,
        other.textOnPrimaryWhite,
        t,
      ),
      textOnPrimaryContainer: Color.lerp(
        textOnPrimaryContainer,
        other.textOnPrimaryContainer,
        t,
      ),
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
      iconsBackgroundVariant:
          Color.lerp(iconsBackgroundVariant, other.iconsBackgroundVariant, t),
      iconsOnImage: Color.lerp(iconsOnImage, other.iconsOnImage, t),
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
      elevationsOnSurfaceNeutralLv1Grey: Color.lerp(
        elevationsOnSurfaceNeutralLv1Grey,
        other.elevationsOnSurfaceNeutralLv1Grey,
        t,
      ),
      elevationsOnSurfaceNeutralLv1White: Color.lerp(
        elevationsOnSurfaceNeutralLv1White,
        other.elevationsOnSurfaceNeutralLv1White,
        t,
      ),
      elevationsOnSurfaceNeutralLv2: Color.lerp(
        elevationsOnSurfaceNeutralLv2,
        other.elevationsOnSurfaceNeutralLv2,
        t,
      ),
      outlineBorder: Color.lerp(outlineBorder, other.outlineBorder, t),
      outlineBorderVariant:
          Color.lerp(outlineBorderVariant, other.outlineBorderVariant, t),
      primary98: Color.lerp(primary98, other.primary98, t),
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t),
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t),
      onErrorVariant: Color.lerp(onErrorVariant, other.onErrorVariant, t),
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t),
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t),
    );
  }
}

extension VoicesColorSchemeExtension on ThemeData {
  VoicesColorScheme get colors => extension<VoicesColorScheme>()!;

  Color get linksPrimary => primaryColor;
}
