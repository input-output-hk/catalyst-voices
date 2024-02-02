import 'package:catalyst_voices/routes/routes.dart' show AppRouter;
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:go_router/go_router.dart';

const _restorationScopeId = 'rootVoices';

final class AppContent extends StatelessWidget {
  const AppContent({super.key});

  List<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return const [
      ...VoicesLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {},
      child: MaterialApp.router(
        restorationScopeId: _restorationScopeId,
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: VoicesLocalizations.supportedLocales,
        localeListResolutionCallback: basicLocaleListResolution,
        routerConfig: _routeConfig(context),
        theme: ThemeData(
          brightness: Brightness.dark,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  GoRouter _routeConfig(BuildContext context) {
    return AppRouter.init(
      authenticationBloc: context.read<AuthenticationBloc>(),
    );
  }
}
