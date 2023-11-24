import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...VoicesLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: VoicesLocalizations.supportedLocales,
        localeListResolutionCallback: basicLocaleListResolution,
        home: widget,
      ),
    );
  }
}
