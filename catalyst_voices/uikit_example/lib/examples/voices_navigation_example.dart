import 'package:catalyst_voices/widgets/app_bar/actions/voices_app_bar_actions.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/menu/voices_expandable_list_tile.dart';
import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesNavigationExample extends StatelessWidget {
  static const String route = '/navigation-example';

  const VoicesNavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(
        actions: [
          NotificationsIndicator(
            badgeText: '5',
            onPressed: () {},
          ),
          UnlockButton(
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(child: Text('Content')),
      drawer: VoicesDrawer(
        bottom: const _DrawerChooser(),
        children: [
          VoicesExpandableListTile(
            title: const Text('My Dashboard'),
            leading: const Icon(CatalystVoicesIcons.home),
            trailing: const Icon(CatalystVoicesIcons.eye),
            expandedChildren: [
              VoicesListTile(
                trailing: const Icon(CatalystVoicesIcons.eye),
                title: const Text('My Catalyst Proposals'),
                onTap: () {},
              ),
              VoicesListTile(
                trailing: const Icon(CatalystVoicesIcons.eye),
                title: const Text('My Actions'),
                onTap: () {},
              ),
              VoicesListTile(
                trailing: const Icon(CatalystVoicesIcons.eye),
                title: const Text('Catalyst Campaign Timeline'),
                onTap: () {},
              ),
            ],
          ),
          const Divider(),
          VoicesListTile(
            leading: const Icon(CatalystVoicesIcons.user),
            trailing: const Icon(CatalystVoicesIcons.eye),
            title: const Text('Catalyst Roles'),
            onTap: () => Navigator.pop(context),
          ),
          VoicesListTile(
            leading: const Icon(CatalystVoicesIcons.annotation),
            trailing: const Icon(CatalystVoicesIcons.eye),
            title: const Text('Feedback'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          VoicesListTile(
            leading: const Icon(CatalystVoicesIcons.arrow_right),
            trailing: const Icon(CatalystVoicesIcons.eye),
            title: const Text('Catalyst Gitbook documentation'),
            onTap: () => Navigator.pop(context),
          ),
          VoicesListTile(
            leading: const Icon(CatalystVoicesIcons.arrow_right),
            trailing: const Icon(CatalystVoicesIcons.eye),
            title: const Text('Opportunity board'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _DrawerChooser extends StatefulWidget {
  const _DrawerChooser();

  @override
  State<_DrawerChooser> createState() => _DrawerChooserState();
}

class _DrawerChooserState extends State<_DrawerChooser> {
  Space _selectedSpace = Space.discovery;

  @override
  Widget build(BuildContext context) {
    return VoicesDrawerSpaceChooser(
      onChanged: _onSpaceSelected,
      currentSpace: _selectedSpace,
    );
  }

  void _onSpaceSelected(Space space) {
    setState(() {
      _selectedSpace = space;
    });
  }
}
