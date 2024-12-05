import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesMenuExample extends StatefulWidget {
  static const String route = '/menu-example';

  const VoicesMenuExample({super.key});

  @override
  State<VoicesMenuExample> createState() => _VoicesMenuExampleState();
}

class _VoicesMenuExampleState extends State<VoicesMenuExample> {
  String? _selectedItemId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Menu')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _MenuExample1(),
                const _MenuExample2(),
                VoicesNodeMenu(
                  name: 'Problem-sensing stage',
                  onItemTap: (value) {
                    setState(() {
                      if (_selectedItemId == value) {
                        _selectedItemId = null;
                      } else {
                        _selectedItemId = value;
                      }
                    });
                  },
                  selectedItemId: _selectedItemId,
                  items: const [
                    VoicesNodeMenuItem(id: '0', label: 'Start'),
                    VoicesNodeMenuItem(id: '1', label: 'Vote'),
                    VoicesNodeMenuItem(id: '2', label: 'Results'),
                  ],
                ),
              ].separatedBy(const SizedBox(height: 12)).toList(),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class _MenuExample1 extends StatelessWidget {
  const _MenuExample1();

  @override
  Widget build(BuildContext context) {
    return VoicesMenu(
      onTap: (menuItem) => debugPrint('Selected label: ${menuItem.label}'),
      menuItems: [
        MenuItem(
          id: 1,
          label: 'Rename',
          icon: VoicesAssets.icons.pencil.buildIcon(),
        ),
        SubMenuItem(
          id: 4,
          label: 'Move Private Team',
          icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
          children: [
            MenuItem(id: 5, label: 'Team 1: The Vikings'),
            MenuItem(id: 6, label: 'Team 2: Pure Hearts'),
          ],
        ),
        MenuItem(
          id: 2,
          label: 'Move to public',
          icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
          showDivider: true,
          enabled: false,
        ),
        MenuItem(
          id: 3,
          label: 'Delete',
          icon: VoicesAssets.icons.trash.buildIcon(),
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
    );
  }
}

class _MenuExample2 extends StatelessWidget {
  const _MenuExample2();

  @override
  Widget build(BuildContext context) {
    return VoicesMenu(
      onTap: (menuItem) => debugPrint('Selected label: ${menuItem.label}'),
      menuItems: [
        MenuItem(
          id: 1,
          label: 'Rename',
          icon: VoicesAssets.icons.pencil.buildIcon(),
        ),
        SubMenuItem(
          id: 4,
          label: 'Move Private Team',
          icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
          children: [
            MenuItem(id: 5, label: 'Team 1: The Vikings'),
            MenuItem(id: 6, label: 'Team 2: Pure Hearts'),
          ],
        ),
        MenuItem(
          id: 2,
          label: 'Move to public',
          icon: VoicesAssets.icons.switchHorizontal.buildIcon(),
          showDivider: true,
        ),
        MenuItem(
          id: 3,
          label: 'Delete',
          icon: VoicesAssets.icons.trash.buildIcon(),
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
    );
  }
}
