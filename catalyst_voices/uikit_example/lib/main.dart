import 'dart:async';

import 'package:catalyst_voices/pages/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:uikit_example/examples/voices_navigation_example.dart';

void main() {
  runApp(const UIKitExampleApp());
}

class UIKitExampleApp extends StatelessWidget {
  const UIKitExampleApp({super.key});

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
      theme: ThemeBuilder.buildTheme(BrandKey.catalyst),
      darkTheme: ThemeBuilder.buildDarkTheme(BrandKey.catalyst),
      routes: {
        Navigator.defaultRouteName: (_) => const _ExamplesList(),
        VoicesNavigationExample.route: (_) => const VoicesNavigationExample(),
      },
    );
  }
}

class _ExamplesList extends StatelessWidget {
  const _ExamplesList();

  @override
  Widget build(BuildContext context) {
    final examples = _examples;
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI kit examples'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 32),
        itemCount: examples.length,
        itemBuilder: (context, index) => examples[index],
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  List<_Example> get _examples {
    return const [
      _Example(
        title: 'VoicesNavigation (AppBar + Drawer)',
        route: VoicesNavigationExample.route,
      ),
    ];
  }
}

class _Example extends StatelessWidget {
  final String title;
  final String route;

  const _Example({
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => unawaited(Navigator.of(context).pushNamed(route)),
    );
  }
}
