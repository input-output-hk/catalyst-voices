import 'package:catalyst_voices/widgets/app_bar/actions/voices_app_bar_actions.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/menu/voices_expandable_list_tile.dart';
import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
  _Space _selectedSpace = _Space.ideas;

  @override
  Widget build(BuildContext context) {
    return VoicesDrawerChooser<_Space>(
      items: _Space.values,
      selectedItem: _selectedSpace,
      onSelected: _onSpaceSelected,
      itemBuilder: _itemBuilder,
      leading: IconButton(
        icon: const Icon(CatalystVoicesIcons.all_spaces_menu, size: 20),
        onPressed: () {},
      ),
    );
  }

  void _onSpaceSelected(_Space space) {
    setState(() {
      _selectedSpace = space;
    });
  }

  Widget _itemBuilder({
    required BuildContext context,
    required _Space item,
    required bool isSelected,
  }) {
    if (isSelected) {
      return VoicesDrawerChooserItem(
        icon: item.icon(),
        foregroundColor: item.foregroundColor(context),
        backgroundColor: item.backgroundColor(context),
      );
    } else {
      return const VoicesDrawerChooserItemPlaceholder();
    }
  }
}

enum _Space {
  ideas,
  discovery,
  proposals,
  settings;

  IconData icon() {
    switch (this) {
      case _Space.ideas:
        return CatalystVoicesIcons.light_bulb;
      case _Space.discovery:
        return CatalystVoicesIcons.shopping_cart;
      case _Space.proposals:
        return CatalystVoicesIcons.fund;
      case _Space.settings:
        return CatalystVoicesIcons.cog_gear;
    }
  }

  Color foregroundColor(BuildContext context) {
    switch (this) {
      case _Space.ideas:
        return Theme.of(context).colorScheme.primary;
      case _Space.discovery:
        return Theme.of(context).colorScheme.secondary;
      case _Space.proposals:
        return Colors.white;
      case _Space.settings:
        return Colors.white;
    }
  }

  Color backgroundColor(BuildContext context) {
    switch (this) {
      case _Space.ideas:
        return Theme.of(context).colorScheme.primaryContainer;
      case _Space.discovery:
        return Theme.of(context).colorScheme.secondaryContainer;
      case _Space.proposals:
        return Colors.orange;
      case _Space.settings:
        return Colors.green;
    }
  }
}
