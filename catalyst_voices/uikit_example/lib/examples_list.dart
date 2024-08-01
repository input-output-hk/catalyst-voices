import 'dart:async';

import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/voices_chip_example.dart';
import 'package:uikit_example/examples/voices_navigation_example.dart';
import 'package:uikit_example/examples/voices_widgets_example.dart';

class ExamplesListPage extends StatelessWidget {
  const ExamplesListPage({super.key});

  @override
  Widget build(BuildContext context) {
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

  static List<ExampleTile> get examples {
    return const [
      ExampleTile(
        title: 'VoicesNavigation (AppBar + Drawer)',
        route: VoicesNavigationExample.route,
        page: VoicesNavigationExample(),
      ),
      ExampleTile(
        title: 'Voices Chips',
        route: VoicesChipExample.route,
        page: VoicesChipExample(),
      ),
      ExampleTile(
        title: 'Voices Widgets',
        route: VoicesWidgetsExample.route,
        page: VoicesWidgetsExample(),
      ),
    ];
  }
}

class ExampleTile extends StatelessWidget {
  final String title;
  final String route;
  final Widget page;

  const ExampleTile({
    super.key,
    required this.title,
    required this.route,
    required this.page,
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
