import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension TimezonePreferencesExt on TimezonePreferences {
  String localizedName(BuildContext context) {
    return switch (this) {
      TimezonePreferences.utc => 'UTC',
      TimezonePreferences.local => context.l10n.local,
    };
  }

  SvgGenImage icon() {
    return switch (this) {
      TimezonePreferences.utc => VoicesAssets.icons.globeAlt,
      TimezonePreferences.local => VoicesAssets.icons.locationMarker,
    };
  }
}

extension ThemePreferencesExt on ThemePreferences {
  ThemeMode asThemeMode() {
    return switch (this) {
      ThemePreferences.dark => ThemeMode.dark,
      ThemePreferences.light => ThemeMode.light,
    };
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      ThemePreferences.dark => context.l10n.themeDark,
      ThemePreferences.light => context.l10n.themeLight,
    };
  }

  SvgGenImage icon() {
    return switch (this) {
      ThemePreferences.dark => VoicesAssets.icons.moon,
      ThemePreferences.light => VoicesAssets.icons.sun,
    };
  }
}
