import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/src/brands/brand.dart';
import 'package:catalyst_voices_brands/src/theme_extensions/brand_assets.dart';
import 'package:catalyst_voices_brands/src/theme_extensions/voices_color_scheme.dart';
import 'package:catalyst_voices_brands/src/themes/widgets/buttons_theme.dart';
import 'package:catalyst_voices_brands/src/themes/widgets/toggles_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const ColorScheme darkColorScheme = ColorScheme.dark(
  primary: VoicesColors.darkPrimary,
  onPrimary: VoicesColors.darkOnPrimary,
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

const VoicesColorScheme darkVoicesColorScheme = VoicesColorScheme(
  textPrimary: VoicesColors.darkTextPrimary,
  textOnPrimary: VoicesColors.darkTextOnPrimary,
  textOnPrimaryLevel0: VoicesColors.darkTextOnPrimaryLevel0,
  textOnPrimaryLevel1: VoicesColors.darkTextOnPrimaryLevel1,
  textOnPrimaryWhite: VoicesColors.darkTextOnPrimaryWhite,
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
  onSurfaceNeutralOpaqueLv0: VoicesColors.darkOnSurfaceNeutralOpaqueLv0,
  onSurfaceNeutralOpaqueLv1: VoicesColors.darkOnSurfaceNeutralOpaqueLv1,
  onSurfaceNeutralOpaqueLv2: VoicesColors.darkOnSurfaceNeutralOpaqueLv2,
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
  iconsBackgroundVariant: VoicesColors.darkIconsBackgroundVariant,
  iconsOnImage: VoicesColors.darkIconsOnImage,
  iconsDisabled: VoicesColors.darkIconsDisabled,
  iconsPrimary: VoicesColors.darkIconsPrimary,
  iconsSecondary: VoicesColors.darkIconsSecondary,
  iconsSuccess: VoicesColors.darkIconsSuccess,
  iconsWarning: VoicesColors.darkIconsWarning,
  iconsError: VoicesColors.darkIconsError,
  avatarsPrimary: VoicesColors.darkAvatarsPrimary,
  avatarsSecondary: VoicesColors.darkAvatarsSecondary,
  avatarsSuccess: VoicesColors.darkAvatarsSuccess,
  avatarsWarning: VoicesColors.darkAvatarsWarning,
  avatarsError: VoicesColors.darkAvatarsError,
  elevationsOnSurfaceNeutralLv0: VoicesColors.darkElevationsOnSurfaceNeutralLv0,
  elevationsOnSurfaceNeutralLv1Grey:
      VoicesColors.darkElevationsOnSurfaceNeutralLv1Grey,
  elevationsOnSurfaceNeutralLv1White:
      VoicesColors.darkElevationsOnSurfaceNeutralLv1White,
  elevationsOnSurfaceNeutralLv2: VoicesColors.darkElevationsOnSurfaceNeutralLv2,
  outlineBorder: VoicesColors.darkOutlineBorderOutline,
  outlineBorderVariant: VoicesColors.darkOutlineBorderOutlineVariant,
  primary98: VoicesColors.darkPrimary98,
  primaryContainer: VoicesColors.darkPrimaryContainer,
  onPrimaryContainer: VoicesColors.darkOnPrimaryContainer,
  onErrorVariant: VoicesColors.darkOnErrorVariant,
  errorContainer: VoicesColors.darkErrorContainer,
  onErrorContainer: VoicesColors.darkOnErrorContainer,
);

const ColorScheme lightColorScheme = ColorScheme.light(
  primary: VoicesColors.lightPrimary,
  // ignore: avoid_redundant_argument_values
  onPrimary: VoicesColors.lightOnPrimary,
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

const VoicesColorScheme lightVoicesColorScheme = VoicesColorScheme(
  textPrimary: VoicesColors.lightTextPrimary,
  textOnPrimary: VoicesColors.lightTextOnPrimary,
  textOnPrimaryLevel0: VoicesColors.lightTextOnPrimaryLevel0,
  textOnPrimaryLevel1: VoicesColors.lightTextOnPrimaryLevel1,
  textOnPrimaryWhite: VoicesColors.lightTextOnPrimaryWhite,
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
  onSurfaceNeutralOpaqueLv0: VoicesColors.lightOnSurfaceNeutralOpaqueLv0,
  onSurfaceNeutralOpaqueLv1: VoicesColors.lightOnSurfaceNeutralOpaqueLv1,
  onSurfaceNeutralOpaqueLv2: VoicesColors.lightOnSurfaceNeutralOpaqueLv2,
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
  iconsBackgroundVariant: VoicesColors.lightIconsBackgroundVariant,
  iconsOnImage: VoicesColors.lightIconsOnImage,
  iconsDisabled: VoicesColors.lightIconsDisabled,
  iconsPrimary: VoicesColors.lightIconsPrimary,
  iconsSecondary: VoicesColors.lightIconsSecondary,
  iconsSuccess: VoicesColors.lightIconsSuccess,
  iconsWarning: VoicesColors.lightIconsWarning,
  iconsError: VoicesColors.lightIconsError,
  avatarsPrimary: VoicesColors.lightAvatarsPrimary,
  avatarsSecondary: VoicesColors.lightAvatarsSecondary,
  avatarsSuccess: VoicesColors.lightAvatarsSuccess,
  avatarsWarning: VoicesColors.lightAvatarsWarning,
  avatarsError: VoicesColors.lightAvatarsError,
  elevationsOnSurfaceNeutralLv0:
      VoicesColors.lightElevationsOnSurfaceNeutralLv0,
  elevationsOnSurfaceNeutralLv1Grey:
      VoicesColors.lightElevationsOnSurfaceNeutralLv1Grey,
  elevationsOnSurfaceNeutralLv1White:
      VoicesColors.lightElevationsOnSurfaceNeutralLv1White,
  elevationsOnSurfaceNeutralLv2:
      VoicesColors.lightElevationsOnSurfaceNeutralLv2,
  outlineBorder: VoicesColors.lightOutlineBorderOutline,
  outlineBorderVariant: VoicesColors.lightOutlineBorderOutlineVariant,
  primary98: VoicesColors.lightPrimary98,
  primaryContainer: VoicesColors.lightPrimaryContainer,
  onPrimaryContainer: VoicesColors.lightOnPrimaryContainer,
  onErrorVariant: VoicesColors.lightOnErrorVariant,
  errorContainer: VoicesColors.lightErrorContainer,
  onErrorContainer: VoicesColors.lightOnErrorContainer,
);

/// [ThemeData] for the `catalyst` brand.
final ThemeData catalyst = _buildThemeData(
  lightColorScheme,
  lightVoicesColorScheme,
  lightBrandAssets,
);

const BrandAssets darkBrandAssets = BrandAssets(
  brand: Brand.catalyst,
);

/// Dark [ThemeData] for the `catalyst` brand.
final ThemeData darkCatalyst = _buildThemeData(
  darkColorScheme,
  darkVoicesColorScheme,
  darkBrandAssets,
);

const BrandAssets lightBrandAssets = BrandAssets(
  brand: Brand.catalyst,
);

TextTheme _buildTextTheme(VoicesColorScheme voicesColorScheme) {
  return TextTheme(
    displayLarge: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 57,
      letterSpacing: -1.14,
      fontWeight: FontWeight.w700,
      height: 1.12,
    ),
    displayMedium: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      height: 1.15,
    ),
    displaySmall: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.22,
    ),
    headlineLarge: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.28,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.33,
    ),
    titleLarge: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.27,
      letterSpacing: 0.66,
    ),
    titleMedium: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: 0.48,
    ),
    titleSmall: GoogleFonts.poppins(
      color: voicesColorScheme.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.42,
      letterSpacing: 0.42,
    ),
    bodyLarge: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.08,
    ),
    bodyMedium: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.42,
      letterSpacing: 0.04,
    ),
    bodySmall: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.33,
      letterSpacing: 0.05,
    ),
    labelLarge: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.42,
      letterSpacing: 0.10,
    ),
    labelMedium: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1,
    ),
    labelSmall: GoogleFonts.notoSans(
      color: voicesColorScheme.textPrimary,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.50,
    ),
  );
}

/// Note:
///
/// If we're going to introduce other themes then catalyst this method
/// should be extracted.
ThemeData _buildThemeData(
  ColorScheme colorScheme,
  VoicesColorScheme voicesColorScheme,
  BrandAssets brandAssets,
) {
  final textTheme = _buildTextTheme(voicesColorScheme);

  return ThemeData(
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      backgroundColor: voicesColorScheme.onSurfaceNeutralOpaqueLv1,
      scrolledUnderElevation: 0,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: voicesColorScheme.onSurfaceNeutralOpaqueLv0,
    ),
    dialogTheme: DialogTheme(
      // N10-38
      barrierColor: const Color(0x212A3D61),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      backgroundColor: voicesColorScheme.elevationsOnSurfaceNeutralLv1White,
    ),
    listTileTheme: ListTileThemeData(
      shape: const StadiumBorder(),
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      titleTextStyle: textTheme.labelLarge,
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      space: 16,
      thickness: 1,
    ),
    tabBarTheme: const TabBarTheme(
      tabAlignment: TabAlignment.start,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.secondaryContainer,
      circularTrackColor: colorScheme.secondaryContainer,
      refreshBackgroundColor: colorScheme.secondaryContainer,
    ),
    textTheme: textTheme,
    colorScheme: colorScheme,
    iconTheme: IconThemeData(
      color: voicesColorScheme.iconsForeground,
    ),
    primaryIconTheme: IconThemeData(
      color: colorScheme.onPrimary,
    ),
    scaffoldBackgroundColor: voicesColorScheme.onSurfaceNeutralOpaqueLv1,
    extensions: <ThemeExtension<dynamic>>[
      voicesColorScheme,
      brandAssets,
    ],
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: voicesColorScheme.textPrimary,
    ),
  ).copyWithButtonsTheme().copyWithTogglesTheme();
}
