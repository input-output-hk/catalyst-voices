import 'package:catalyst_voices/app/view/app_active_state_listener.dart';
import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/app_session_listener.dart';
import 'package:catalyst_voices/common/ext/preferences_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

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
      theme: ThemeBuilder.buildTheme(
        brand: Brand.catalyst,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeBuilder.buildTheme(
        brand: Brand.catalyst,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Scaffold(
          primary: false,
          backgroundColor: Colors.transparent,
          body: AppActiveStateListener(
            child: GlobalPrecacheImages(
              child: GlobalSessionListener(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }
}
