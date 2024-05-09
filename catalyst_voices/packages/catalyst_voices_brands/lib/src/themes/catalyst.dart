import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_assets/generated/colors.gen.dart';
import 'package:catalyst_voices_brands/src/themes/extended_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData _buildThemeData(
  ColorScheme colorScheme,
  ExtendedColorScheme extendedColorScheme,
) {
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 57,
        letterSpacing: -1.14,
        fontWeight: FontWeight.w700,
        height: -0.02,
      ),
      displayMedium: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 0.03,
      ),
      displaySmall: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 0.03,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 0.04,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 0.05,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 0.06,
      ),
      titleLarge: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.66,
      ),
      titleMedium: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 0.09,
        letterSpacing: 0.48,
      ),
      titleSmall: GoogleFonts.poppins(
        color: extendedColorScheme.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 0.10,
        letterSpacing: 0.42,
      ),
      bodyLarge: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 0.09,
        letterSpacing: 0.08,
      ),
      bodyMedium: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 0.10,
        letterSpacing: 0.04,
      ),
      bodySmall: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 0.11,
        letterSpacing: 0.05,
      ),
      labelLarge: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 0.10,
        letterSpacing: 0.10,
      ),
      labelMedium: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 0.11,
      ),
      labelSmall: GoogleFonts.notoSans(
        color: extendedColorScheme.textPrimary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 0.13,
        letterSpacing: 0.50,
      ),
    ),
    colorScheme: colorScheme,
    extensions: <ThemeExtension<dynamic>>[
      extendedColorScheme,
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

const ExtendedColorScheme lightExtendedColorScheme = ExtendedColorScheme(
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
  iconsForeground: VoicesColors.lightIconsForeground,
  iconsBackground: VoicesColors.lightIconsBackground,
  iconsDisabled: VoicesColors.lightIconsDisabled,
  iconsPrimary: VoicesColors.lightIconsPrimary,
  iconsSecondary: VoicesColors.lightIconsSecondary,
  iconsSuccess: VoicesColors.lightIconsSuccess,
  iconsWarning: VoicesColors.lightIconsWarning,
  iconsError: VoicesColors.lightIconsError,
);

const ColorScheme darkColorScheme = ColorScheme.dark(
  primary: VoicesColors.darkPrimary,
  primaryContainer: VoicesColors.darkPrimaryContainer,
  onPrimaryContainer: VoicesColors.darkOnPrimaryContainer,
  secondary: VoicesColors.darkSecondary,
  onSecondary: VoicesColors.darkOnSecondary,
  secondaryContainer: VoicesColors.darkSecondaryContainer,
  onSecondaryContainer: VoicesColors.darkOnSecondaryContainer,
  error: VoicesColors.darkError,
  errorContainer: VoicesColors.darkErrorContainer,
  onErrorContainer: VoicesColors.darkOnErrorContainer,
  outline: VoicesColors.darkOutline,
  outlineVariant: VoicesColors.darkOutlineVariant,
);

const ExtendedColorScheme darkExtendedColorScheme = ExtendedColorScheme(
  textPrimary: VoicesColors.darkTextPrimary,
  textOnPrimary: VoicesColors.darkTextOnPrimary,
  textOnPrimaryContainer: VoicesColors.darkTextOnPrimaryContainer,
  textDisabled: VoicesColors.darkTextDisabled,
  success: VoicesColors.darkSuccess,
  onSuccess: VoicesColors.darkOnSuccess,
  successContainer: VoicesColors.darkSuccessContainer,
  onSuccessContainer: VoicesColors.darkOnSuccessContainer,
  warning: VoicesColors.darkWarning,
  onWarning: VoicesColors.darkOnWarning,
  warningContainer: VoicesColors.darkWarningContainer,
  onWarningContainer: VoicesColors.darkOnWarningContainer,
  onSurfaceNeutral08: VoicesColors.darkOnSurfaceNeutral08,
  onSurfaceNeutral012: VoicesColors.darkOnSurfaceNeutral012,
  onSurfaceNeutral016: VoicesColors.darkOnSurfaceNeutral016,
  onSurfacePrimaryContainer: VoicesColors.darkOnSurfacePrimaryContainer,
  onSurfacePrimary08: VoicesColors.darkOnSurfacePrimary08,
  onSurfacePrimary012: VoicesColors.darkOnSurfacePrimary012,
  onSurfacePrimary016: VoicesColors.darkOnSurfacePrimary016,
  onSurfaceSecondary08: VoicesColors.darkOnSurfaceSecondary08,
  onSurfaceSecondary012: VoicesColors.darkOnSurfaceSecondary012,
  onSurfaceSecondary016: VoicesColors.darkOnSurfaceSecondary016,
  onSurfaceError08: VoicesColors.darkOnSurfaceError08,
  onSurfaceError012: VoicesColors.darkOnSurfaceError012,
  onSurfaceError016: VoicesColors.darkOnSurfaceError016,
  iconsForeground: VoicesColors.darkIconsForeground,
  iconsBackground: VoicesColors.darkIconsBackground,
  iconsDisabled: VoicesColors.darkIconsDisabled,
  iconsPrimary: VoicesColors.darkIconsPrimary,
  iconsSecondary: VoicesColors.darkIconsSecondary,
  iconsSuccess: VoicesColors.darkIconsSuccess,
  iconsWarning: VoicesColors.darkIconsWarning,
  iconsError: VoicesColors.darkIconsError,
);

/// [ThemeData] for the `catalyst` brand.
final ThemeData catalyst = _buildThemeData(
  lightColorScheme,
  lightExtendedColorScheme,
);

/// Dark [ThemeData] for the `catalyst` brand.
final ThemeData darkCatalyst = _buildThemeData(
  darkColorScheme,
  darkExtendedColorScheme,
);
