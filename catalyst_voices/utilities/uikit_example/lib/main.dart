import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:uikit_example/examples_list.dart';

void main() {
  runApp(const UIKitExampleApp());
}

class UIKitExampleApp extends StatefulWidget {
  const UIKitExampleApp({super.key});

  @override
  State<UIKitExampleApp> createState() => _UIKitExampleAppState();
}

class _ThemeModeSwitcherWrapper extends StatelessWidget {
  final Brightness brightness;
  final ValueChanged<ThemeMode> onChanged;
  final Widget child;

  const _ThemeModeSwitcherWrapper({
    required this.brightness,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: child,
        ),
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: VoicesSwitch(
                value: brightness == Brightness.dark,
                onChanged: (value) {
                  onChanged(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UIKitExampleAppState extends State<UIKitExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI kit examples',
      supportedLocales: VoicesLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...VoicesLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate(),
      ],
      localeListResolutionCallback: basicLocaleListResolution,
      theme: ThemeBuilder.buildTheme(),
      darkTheme: ThemeBuilder.buildTheme(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final page = ExamplesListPage.examples
            .where((e) => e.route == settings.name)
            .map((e) => e.page)
            .firstOrNull ??
        const ExamplesListPage();

    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        return _ThemeModeSwitcherWrapper(
          brightness: _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
          onChanged: _onThemeModeChanged,
          child: page,
        );
      },
    );
  }

  void _onThemeModeChanged(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
