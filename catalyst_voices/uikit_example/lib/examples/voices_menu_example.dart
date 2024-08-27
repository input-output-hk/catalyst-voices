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
                onTap: (menuItem) =>
                    debugPrint('Selected label: ${menuItem.label}'),
                menuItems: [
                  MenuItem(
                    id: 1,
                    label: 'Rename',
                    icon: CatalystVoicesIcons.pencil,
                  ),
                  SubMenuItem(
                    id: 4,
                    label: 'Move Private Team',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    children: [
                      MenuItem(id: 5, label: 'Team 1: The Vikings'),
                      MenuItem(id: 6, label: 'Team 2: Pure Hearts'),
                    ],
                  ),
                  MenuItem(
                    id: 2,
                    label: 'Move to public',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    showDivider: true,
                    enabled: false,
                  ),
                  MenuItem(
                    id: 3,
                    label: 'Delete',
                    icon: CatalystVoicesIcons.trash,
                  ),
                ],
                child: const SizedBox(
                  height: 56,
                  width: 200,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My first proposal'),
                  ),
                ),
              ),
              VoicesMenu(
                onTap: (menuItem) =>
                    debugPrint('Selected label: ${menuItem.label}'),
                menuItems: [
                  MenuItem(
                    id: 1,
                    label: 'Rename',
                    icon: CatalystVoicesIcons.pencil,
                  ),
                  SubMenuItem(
                    id: 4,
                    label: 'Move Private Team',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    children: [
                      MenuItem(id: 5, label: 'Team 1: The Vikings'),
                      MenuItem(id: 6, label: 'Team 2: Pure Hearts'),
                    ],
                  ),
                  MenuItem(
                    id: 2,
                    label: 'Move to public',
                    icon: CatalystVoicesIcons.switch_horizontal,
                    showDivider: true,
                  ),
                  MenuItem(
                    id: 3,
                    label: 'Delete',
                    icon: CatalystVoicesIcons.trash,
                  ),
                ],
                child: const SizedBox(
                  height: 56,
                  width: 200,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My second proposal'),
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
