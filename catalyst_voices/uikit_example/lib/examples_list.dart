import 'dart:async';

import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices/widgets/separators/voices_divider.dart';
import 'package:catalyst_voices/widgets/separators/voices_text_divider.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/voices_avatar_example.dart';
import 'package:uikit_example/examples/voices_badge_example.dart';
import 'package:uikit_example/examples/voices_buttons_example.dart';
import 'package:uikit_example/examples/voices_checkbox_example.dart';
import 'package:uikit_example/examples/voices_chip_example.dart';
import 'package:uikit_example/examples/voices_fab_example.dart';
import 'package:uikit_example/examples/voices_headers_examples.dart';
import 'package:uikit_example/examples/voices_indicators_example.dart';
import 'package:uikit_example/examples/voices_list_tile_example.dart';
import 'package:uikit_example/examples/voices_menu_example.dart';
import 'package:uikit_example/examples/voices_modals_example.dart';
import 'package:uikit_example/examples/voices_navigation_example.dart';
import 'package:uikit_example/examples/voices_proposal_card_example.dart';
import 'package:uikit_example/examples/voices_radio_example.dart';
import 'package:uikit_example/examples/voices_rich_text_example.dart';
import 'package:uikit_example/examples/voices_role_panels_example.dart';
import 'package:uikit_example/examples/voices_seed_phrase_example.dart';
import 'package:uikit_example/examples/voices_segmented_button_example.dart';
import 'package:uikit_example/examples/voices_separators_example.dart';
import 'package:uikit_example/examples/voices_snackbar_example.dart';
import 'package:uikit_example/examples/voices_switch_example.dart';
import 'package:uikit_example/examples/voices_tabs_example.dart';
import 'package:uikit_example/examples/voices_text_field_example.dart';
import 'package:uikit_example/examples/voices_tooltips_example.dart';
import 'package:uikit_example/examples/voices_tree_view_example.dart';

class ExamplesListPage extends StatelessWidget {
  static List<ExampleTile> get examples {
    return [
      ...screens,
      ...uiKit,
    ];
  }

  static List<ExampleTile> get screens {
    return const [];
  }

  static List<ExampleTile> get uiKit {
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
      ExampleTile(
        title: 'Voices Switch',
        route: VoicesSwitchExample.route,
        page: VoicesSwitchExample(),
      ),
      ExampleTile(
        title: 'Voices Separators',
        route: VoicesSeparatorsExample.route,
        page: VoicesSeparatorsExample(),
      ),
      ExampleTile(
        title: 'Voices Indicators',
        route: VoicesIndicatorsExample.route,
        page: VoicesIndicatorsExample(),
      ),
      ExampleTile(
        title: 'Voices List Tile',
        route: VoicesListTileExample.route,
        page: VoicesListTileExample(),
      ),
      ExampleTile(
        title: 'Voices Avatars',
        route: VoicesAvatarExample.route,
        page: VoicesAvatarExample(),
      ),
      ExampleTile(
        title: 'Voices Text Field',
        route: VoicesTextFieldExample.route,
        page: VoicesTextFieldExample(),
      ),
      ExampleTile(
        title: 'Voices Badges',
        route: VoicesBadgeExample.route,
        page: VoicesBadgeExample(),
      ),
      ExampleTile(
        title: 'Voices Floating Action Button',
        route: VoicesFabExample.route,
        page: VoicesFabExample(),
      ),
      ExampleTile(
        title: 'Voices Seed Phrase',
        route: VoicesSeedPhraseExample.route,
        page: VoicesSeedPhraseExample(),
      ),
      ExampleTile(
        title: 'Voices Tooltips',
        route: VoicesTooltipsExample.route,
        page: VoicesTooltipsExample(),
      ),
      ExampleTile(
        title: 'Voices Menu',
        route: VoicesMenuExample.route,
        page: VoicesMenuExample(),
      ),
      ExampleTile(
        title: 'Voices Tabs',
        route: VoicesTabsExample.route,
        page: VoicesTabsExample(),
      ),
      ExampleTile(
        title: 'Voices Headers',
        route: VoicesHeadersExamples.route,
        page: VoicesHeadersExamples(),
      ),
      ExampleTile(
        title: 'Voices TreeView',
        route: VoicesTreeViewExample.route,
        page: VoicesTreeViewExample(),
      ),
      ExampleTile(
        title: 'Voices Modals',
        route: VoicesModalsExample.route,
        page: VoicesModalsExample(),
      ),
      ExampleTile(
        title: 'Voices Rich Text',
        route: VoicesRichTextExample.route,
        page: VoicesRichTextExample(),
      ),
      ExampleTile(
        title: 'Voices Proposal Card',
        route: VoicesProposalCardExample.route,
        page: VoicesProposalCardExample(),
      ),
      ExampleTile(
        title: VoicesRoleContainersExample.title,
        route: VoicesRoleContainersExample.route,
        page: VoicesRoleContainersExample(),
      ),
    ];
  }

  const ExamplesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI examples'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 32),
        itemCount: examples.length + 1,
        itemBuilder: (context, index) {
          // leading dummy item for divider
          if (index == 0) {
            return const SizedBox.shrink();
          }

          return examples[index - 1];
        },
        separatorBuilder: (context, index) {
          if (index == 0) {
            return const VoicesTextDivider(child: Text('Screens'));
          }

          if (index == screens.length) {
            return const VoicesTextDivider(child: Text('UI Kit'));
          }

          return const VoicesDivider();
        },
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
