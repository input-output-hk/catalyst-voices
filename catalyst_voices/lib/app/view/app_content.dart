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
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return const [
      ...VoicesLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate(),
    ];
  }

  ThemeMode _mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: _restorationScopeId,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: VoicesLocalizations.supportedLocales,
      localeListResolutionCallback: basicLocaleListResolution,
      routerConfig: widget.routerConfig,
      themeMode: _mode,
      theme: ThemeBuilder.buildTheme(BrandKey.catalyst),
      darkTheme: ThemeBuilder.buildDarkTheme(BrandKey.catalyst),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _mode = switch (_mode) {
                ThemeMode.system => ThemeMode.light,
                ThemeMode.light => ThemeMode.dark,
                ThemeMode.dark => ThemeMode.light,
              };
            });
          },
          child: GlobalPrecacheImages(
            child: child ?? SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
