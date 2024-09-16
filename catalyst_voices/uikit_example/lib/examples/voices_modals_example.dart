import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesModalsExample extends StatelessWidget {
  static const String route = '/modals-example';

  const VoicesModalsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modals')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            VoicesFilledButton(
              child: const Text('Desktop info dialog'),
              onTap: () async {
                await VoicesDialog.show<void>(
                  context,
                  builder: (context) {
                    return const VoicesDesktopInfoDialog(
                      title: 'Desktop modal',
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
