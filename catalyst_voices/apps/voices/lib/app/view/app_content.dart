import 'package:catalyst_voices/app/view/app_active_state_listener.dart';
import 'package:catalyst_voices/app/view/app_mobile_access_restriction.dart';
import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/app_session_listener.dart';
import 'package:catalyst_voices/app/view/app_splash_screen_manager.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_precache.dart';
import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _restorationScopeId = 'rootVoices';

class AppContent extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const AppContent({
    super.key,
    required this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, ThemeMode>(
      selector: (state) => state.settings.theme.asThemeMode(),
      builder: (context, state) {
        return _AppContent(
          routerConfig: routerConfig,
          themeMode: state,
        );
      },
    );
  }
}

final class _AppContent extends StatelessWidget {
  final RouterConfig<Object> routerConfig;
  final ThemeMode themeMode;

  const _AppContent({
    required this.routerConfig,
    required this.themeMode,
  });

  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return const [
      ...VoicesLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate(),
      FlutterQuillLocalizations.delegate,
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
      themeMode: themeMode,
      theme: ThemeBuilder.buildTheme(),
      darkTheme: ThemeBuilder.buildTheme(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      builder: (_, child) {
        return AppActiveStateListener(
          child: AppVideoPrecache(
            child: GlobalPrecacheImages(
              child: GlobalSessionListener(
                // IMPORTANT: AppSplashScreenManager must be placed above all
                // widgets that render visible UI elements. Any widget that
                // displays content should be a descendant of
                // AppSplashScreenManager to ensure proper splash
                // screen behavior.
                child: AppSplashScreenManager(
                  child: AppMobileAccessRestriction(
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
