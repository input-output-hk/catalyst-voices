import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

const _restorationScopeId = 'rootVoices';

final class AppContent extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const AppContent({
    super.key,
    required this.routerConfig,
  });

  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return const [
      ...VoicesLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: _restorationScopeId,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: VoicesLocalizations.supportedLocales,
      localeListResolutionCallback: basicLocaleListResolution,
      routerConfig: routerConfig,
      // Light mode is "go to" for now.
      themeMode: ThemeMode.dark,
      theme: ThemeBuilder.buildTheme(BrandKey.catalyst),
      darkTheme: ThemeBuilder.buildDarkTheme(BrandKey.catalyst),
      builder: (context, child) {
        return GlobalPrecacheImages(
          child: child ?? SizedBox.shrink(),
        );
      },
    );
  }
}
