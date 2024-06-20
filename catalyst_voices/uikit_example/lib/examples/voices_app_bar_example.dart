import 'package:catalyst_voices/pages/widgets/voices_app_bar/actions/voices_app_bar_actions.dart';
import 'package:catalyst_voices/pages/widgets/voices_app_bar/voices_app_bar.dart';
import 'package:flutter/material.dart';

class VoicesAppBarExample extends StatelessWidget {
  const VoicesAppBarExample({super.key});

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
    );
  }
}
