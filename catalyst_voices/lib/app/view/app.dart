import 'package:catalyst_voices/dummy/dummy.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'rootVoices',
      localizationsDelegates: const [
        ...VoicesLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: VoicesLocalizations.supportedLocales,
      localeListResolutionCallback: basicLocaleListResolution,
      home: isUserLoggedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}
