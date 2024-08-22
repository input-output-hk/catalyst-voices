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
                  onSelected: (label) => debugPrint('Selected label: $label'),
                  menuItems: [
                    MenuItem(
                      label: 'Rename',
                      icon: const Icon(CatalystVoicesIcons.pencil, size: 20),
                    ),
                    SubMenuItem(
                      label: 'Move Private Team',
                      icon: const Icon(CatalystVoicesIcons.cube, size: 20),
                      children: [
                        MenuItem(label: 'Team 1: The Vikings'),
                        MenuItem(label: 'Team 2: Pure Hearts'),
                      ],
                    ),
                    MenuItem(
                      label: 'Move to public',
                      icon: const Icon(CatalystVoicesIcons.cube, size: 20),
                    ),
                    MenuItem(
                      label: 'Delete',
                      icon: const Icon(CatalystVoicesIcons.trash, size: 20),
                    ),
                  ],
                  child: const SizedBox(
                    height: 56,
                    width: 200,
                    child: ListTile(
                      title: Text('My first proposal'),
                    ),
                  )),
              VoicesMenu(
                  onSelected: (label) => debugPrint('Selected label: $label'),
                  menuItems: [
                    MenuItem(
                      label: 'Rename',
                      icon: const Icon(CatalystVoicesIcons.pencil, size: 20),
                    ),
                    SubMenuItem(
                      label: 'Move Private Team',
                      icon: const Icon(CatalystVoicesIcons.cube, size: 20),
                      children: [
                        MenuItem(label: 'Team 1: The Vikings'),
                        MenuItem(label: 'Team 2: Pure Hearts'),
                      ],
                    ),
                    MenuItem(
                      label: 'Move to public',
                      icon: const Icon(CatalystVoicesIcons.cube, size: 20),
                    ),
                    MenuItem(
                      label: 'Delete',
                      icon: const Icon(CatalystVoicesIcons.trash, size: 20),
                    ),
                  ],
                  child: const SizedBox(
                    height: 56,
                    width: 200,
                    child: ListTile(
                      title: Text('My second proposal'),
                    ),
                  )),
            ],
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}
