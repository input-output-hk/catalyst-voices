import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices/widgets/menu/voices_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesMenuExample extends StatelessWidget {
  static const String route = '/menu-example';

  const VoicesMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Menu')),
      body: Row(
        children: [
          Column(
            children: [
              VoicesMenu(
                onTap: (label) => debugPrint('Selected label: $label'),
                menuItems: [
                  MenuItem(
                    label: 'Rename',
                    icon: CatalystVoicesIcons.pencil,
                  ),
                  SubMenuItem(
                    label: 'Move Private Team',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    children: [
                      MenuItem(label: 'Team 1: The Vikings'),
                      MenuItem(label: 'Team 2: Pure Hearts'),
                    ],
                  ),
                  MenuItem(
                    label: 'Move to public',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    showDivider: true,
                    enabled: false,
                  ),
                  MenuItem(
                    label: 'Delete',
                    icon: CatalystVoicesIcons.trash,
                  ),
                ],
                child: const SizedBox(
                  height: 56,
                  width: 200,
                  child: VoicesListTile(
                    title: Text('My first proposal'),
                  ),
                ),
              ),
              VoicesMenu(
                onTap: (label) => debugPrint('Selected label: $label'),
                menuItems: [
                  MenuItem(
                    label: 'Rename',
                    icon: CatalystVoicesIcons.pencil,
                  ),
                  SubMenuItem(
                    label: 'Move Private Team',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    children: [
                      MenuItem(label: 'Team 1: The Vikings'),
                      MenuItem(label: 'Team 2: Pure Hearts'),
                    ],
                  ),
                  MenuItem(
                    label: 'Move to public',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    showDivider: true,
                  ),
                  MenuItem(
                    label: 'Delete',
                    icon: CatalystVoicesIcons.trash,
                  ),
                ],
                child: const SizedBox(
                  height: 56,
                  width: 200,
                  child: VoicesListTile(
                    title: Text('My second proposal'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
