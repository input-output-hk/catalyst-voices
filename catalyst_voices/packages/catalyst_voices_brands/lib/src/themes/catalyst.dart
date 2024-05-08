import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_assets/generated/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension ExtendedColorsExtension on ThemeData {
  CatalystExtendedColors get colors => extension<CatalystExtendedColors>()!;
  Color get linksPrimary => primaryColor;
}

@immutable
class CatalystExtendedColors extends ThemeExtension<CatalystExtendedColors> {
  const CatalystExtendedColors({
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
    required this.onSurfaceSecondary08,
    required this.onSurfaceSecondary012,
    required this.onSurfaceSecondary016,
    required this.onSurfaceError08,
    required this.onSurfaceError012,
    required this.onSurfaceError016,
  });

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

  @override
  ThemeExtension<CatalystExtendedColors> copyWith({
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
  }) {
    return CatalystExtendedColors(
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
    );
  }

  @override
  CatalystExtendedColors lerp(
    ThemeExtension<CatalystExtendedColors>? other,
    double t,
  ) {
    if (other is! CatalystExtendedColors) {
      return this;
    }
    return CatalystExtendedColors(
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
    );
  }
}

ThemeData _buildThemeData(
  ColorScheme colorScheme,
  CatalystExtendedColors extendedColors,
) {
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 57,
        letterSpacing: -1.14,
        fontWeight: FontWeight.w700,
        height: -0.02,
      ),
      displayMedium: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 0.03,
      ),
      displaySmall: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 0.03,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 0.04,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 0.05,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 0.06,
      ),
      titleLarge: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.66,
      ),
      titleMedium: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 0.09,
        letterSpacing: 0.48,
      ),
      titleSmall: GoogleFonts.poppins(
        color: extendedColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 0.10,
        letterSpacing: 0.42,
      ),
      bodyLarge: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 0.09,
        letterSpacing: 0.08,
      ),
      bodyMedium: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 0.10,
        letterSpacing: 0.04,
      ),
      bodySmall: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 0.11,
        letterSpacing: 0.05,
      ),
      labelLarge: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 0.10,
        letterSpacing: 0.10,
      ),
      labelMedium: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 0.11,
      ),
      labelSmall: GoogleFonts.notoSans(
        color: extendedColors.textPrimary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 0.13,
        letterSpacing: 0.50,
      ),
    ),
    colorScheme: colorScheme,
    extensions: <ThemeExtension<dynamic>>[
      extendedColors,
    ],
  );
}

const ColorScheme lightColorScheme = ColorScheme.light(
  primary: VoicesColors.lightPrimary,
  primaryContainer: VoicesColors.lightPrimaryContainer,
  onPrimaryContainer: VoicesColors.lightOnPrimaryContainer,
  secondary: VoicesColors.lightSecondary,
  onSecondary: VoicesColors.lightOnSecondary,
  secondaryContainer: VoicesColors.lightSecondaryContainer,
  onSecondaryContainer: VoicesColors.lightOnSecondaryContainer,
  error: VoicesColors.lightError,
  errorContainer: VoicesColors.lightErrorContainer,
  onErrorContainer: VoicesColors.lightOnErrorContainer,
  outline: VoicesColors.lightOutline,
  outlineVariant: VoicesColors.lightOutlineVariant,
);

const CatalystExtendedColors lightExtendedColors = CatalystExtendedColors(
  textPrimary: VoicesColors.lightTextPrimary,
  textOnPrimary: VoicesColors.lightTextOnPrimary,
  textOnPrimaryContainer: VoicesColors.lightTextOnPrimaryContainer,
  textDisabled: VoicesColors.lightTextDisabled,
  success: VoicesColors.lightSuccess,
  onSuccess: VoicesColors.lightOnSuccess,
  successContainer: VoicesColors.lightSuccessContainer,
  onSuccessContainer: VoicesColors.lightOnSuccessContainer,
  warning: VoicesColors.lightWarning,
  onWarning: VoicesColors.lightOnWarning,
  warningContainer: VoicesColors.lightWarningContainer,
  onWarningContainer: VoicesColors.lightOnWarningContainer,
  onSurfaceNeutral08: VoicesColors.lightOnSurfaceNeutral08,
  onSurfaceNeutral012: VoicesColors.lightOnSurfaceNeutral012,
  onSurfaceNeutral016: VoicesColors.lightOnSurfaceNeutral016,
  onSurfacePrimaryContainer: VoicesColors.lightOnSurfacePrimaryContainer,
  onSurfacePrimary08: VoicesColors.lightOnSurfacePrimary08,
  onSurfacePrimary012: VoicesColors.lightOnSurfacePrimary012,
  onSurfacePrimary016: VoicesColors.lightOnSurfacePrimary016,
  onSurfaceSecondary08: VoicesColors.lightOnSurfaceSecondary08,
  onSurfaceSecondary012: VoicesColors.lightOnSurfaceSecondary012,
  onSurfaceSecondary016: VoicesColors.lightOnSurfaceSecondary016,
  onSurfaceError08: VoicesColors.lightOnSurfaceError08,
  onSurfaceError012: VoicesColors.lightOnSurfaceError012,
  onSurfaceError016: VoicesColors.lightOnSurfaceError016,
);

/// [ThemeData] for the `catalyst` brand.
final ThemeData catalyst = _buildThemeData(
  lightColorScheme,
  lightExtendedColors,
);

/// Dark [ThemeData] for the `catalyst` brand.
final ThemeData darkCatalyst = _buildThemeData(
  lightColorScheme,
  lightExtendedColors,
);
