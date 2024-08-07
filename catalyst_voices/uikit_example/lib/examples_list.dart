import 'dart:async';

import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/voices_buttons_example.dart';
import 'package:uikit_example/examples/voices_checkbox_example.dart';
import 'package:uikit_example/examples/voices_chip_example.dart';
import 'package:uikit_example/examples/voices_navigation_example.dart';
import 'package:uikit_example/examples/voices_radio_example.dart';
import 'package:uikit_example/examples/voices_segmented_button_example.dart';
import 'package:uikit_example/examples/voices_snackbar_example.dart';

class ExamplesListPage extends StatelessWidget {
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
        title: 'Voices Snackbar',
        route: VoicesSnackbarExample.route,
        page: VoicesSnackbarExample(),
      ),
      ExampleTile(
        title: 'Voices SegmentedButton',
        route: VoicesSegmentedButtonExample.route,
        page: VoicesSegmentedButtonExample(),
      ),
      ExampleTile(
        title: 'Voices Buttons',
        route: VoicesButtonsExample.route,
        page: VoicesButtonsExample(),
      ),
      ExampleTile(
        title: 'Voices Radio',
        route: VoicesRadioExample.route,
        page: VoicesRadioExample(),
      ),
      ExampleTile(
        title: 'Voices Checkbox',
        route: VoicesCheckboxExample.route,
        page: VoicesCheckboxExample(),
      ),
    ];
  }

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
