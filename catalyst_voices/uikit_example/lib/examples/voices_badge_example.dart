import 'package:flutter/material.dart';

class VoicesBadgeExample extends StatelessWidget {
  static const String route = '/badge-example';

  const VoicesBadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Badges')),
      body: const Padding(
        padding: EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Badge(
              label: Text('3'),
            ),
            Badge(
              label: Text('32'),
            ),
            Badge(),
          ],
        ),
      ),
    );
  }
}
