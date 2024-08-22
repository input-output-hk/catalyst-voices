import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    VoicesColorScheme voicesColors = const VoicesColorScheme.optional(),
  }) {
    final effectiveTheme = (theme ?? ThemeData()).copyWith(
      extensions: [
        voicesColors,
      ],
    );

    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...VoicesLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: VoicesLocalizations.supportedLocales,
        localeListResolutionCallback: basicLocaleListResolution,
        theme: effectiveTheme,
        home: widget,
      ),
    );
  }
}
