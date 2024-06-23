import 'package:catalyst_voices/pages/widgets/menu/voices_expandable_list_tile.dart';
import 'package:catalyst_voices/pages/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices/pages/widgets/voices_app_bar/actions/voices_app_bar_actions.dart';
import 'package:catalyst_voices/pages/widgets/voices_app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/pages/widgets/voices_drawer/voices_drawer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesNavigationExample extends StatelessWidget {
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
  Space _selectedSpace = Space.ideas;

  @override
  Widget build(BuildContext context) {
    return VoicesDrawerChooser<Space>(
      items: Space.values,
      selectedItem: _selectedSpace,
      onSelected: _onSpaceSelected,
      itemBuilder: _itemBuilder,
      leading: IconButton(
        icon: const Icon(CatalystVoicesIcons.all_spaces_menu, size: 20),
        onPressed: () {},
      ),
    );
  }

  void _onSpaceSelected(Space space) {
    setState(() {
      _selectedSpace = space;
    });
  }

  Widget _itemBuilder({
    required BuildContext context,
    required Space item,
    required bool isSelected,
  }) {
    if (isSelected) {
      return VoicesDrawerChooserItem(
        icon: item.getIcon(),
        foregroundColor: item.getForegroundColor(context),
        backgroundColor: item.getBackgroundColor(context),
      );
    } else {
      return const VoicesDrawerChooserItemPlaceholder();
    }
  }
}

enum Space {
  ideas,
  discovery,
  proposals,
  settings;

  IconData getIcon() {
    switch (this) {
      case Space.ideas:
        return CatalystVoicesIcons.light_bulb;
      case Space.discovery:
        return CatalystVoicesIcons.shopping_cart;
      case Space.proposals:
        return CatalystVoicesIcons.fund;
      case Space.settings:
        return CatalystVoicesIcons.cog_gear;
    }
  }

  Color getForegroundColor(BuildContext context) {
    switch (this) {
      case Space.ideas:
        return Theme.of(context).colorScheme.primary;
      case Space.discovery:
        return Theme.of(context).colorScheme.secondary;
      case Space.proposals:
        return Colors.white;
      case Space.settings:
        return Colors.white;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    switch (this) {
      case Space.ideas:
        return Theme.of(context).colorScheme.primaryContainer;
      case Space.discovery:
        return Theme.of(context).colorScheme.secondaryContainer;
      case Space.proposals:
        return Colors.orange;
      case Space.settings:
        return Colors.green;
    }
  }
}
