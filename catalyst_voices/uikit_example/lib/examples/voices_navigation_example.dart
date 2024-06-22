import 'package:catalyst_voices/pages/widgets/voices_app_bar/actions/voices_app_bar_actions.dart';
import 'package:catalyst_voices/pages/widgets/voices_app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/pages/widgets/voices_drawer/voices_drawer.dart';
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
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Saved Videos'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop_outlined),
            trailing: const Icon(Icons.visibility_outlined),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
