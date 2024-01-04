import 'package:catalyst_voices/routes/routes.dart' show AppRouter;
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

final class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {},
      child: MaterialApp.router(
        restorationScopeId: 'rootVoices',
        localizationsDelegates: const [
          ...VoicesLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: VoicesLocalizations.supportedLocales,
        localeListResolutionCallback: basicLocaleListResolution,
        routerConfig: AppRouter.init(
          authenticationBloc: context.read<AuthenticationBloc>(),
        ),
        title: 'Catalyst Voices',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
