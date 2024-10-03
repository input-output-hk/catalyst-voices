import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

const _restorationScopeId = 'rootVoices';

final class AppContent extends StatefulWidget {
  final RouterConfig<Object> routerConfig;

  const AppContent({
    super.key,
    required this.routerConfig,
  });

  @override
  State<AppContent> createState() => AppContentState();

  /// Returns the state associated with the [AppContent].
  static AppContentState of(BuildContext context) {
    return context.findAncestorStateOfType<AppContentState>()!;
  }
}

class AppContentState extends State<AppContent> {
  ThemeMode _themeMode = ThemeMode.light;

  void updateThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: _restorationScopeId,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: VoicesLocalizations.supportedLocales,
      localeListResolutionCallback: basicLocaleListResolution,
      routerConfig: widget.routerConfig,
      themeMode: _themeMode,
      theme: ThemeBuilder.buildTheme(
        brand: Brand.catalyst,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeBuilder.buildTheme(
        brand: Brand.catalyst,
        brightness: Brightness.dark,
      ),
      builder: (context, child) {
        return GlobalPrecacheImages(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return const [
      ...VoicesLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate(),
    ];
  }
}
