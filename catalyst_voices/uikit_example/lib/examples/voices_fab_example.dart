import 'package:flutter/material.dart';

class VoicesFabExample extends StatelessWidget {
  static const String route = '/fab-example';

  const VoicesFabExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Floating Action Button')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            FloatingActionButton.small(
              heroTag: 'small',
              child: const Icon(Icons.edit),
              onPressed: () {},
            ),
            FloatingActionButton(
              heroTag: 'regular',
              child: const Icon(Icons.edit),
              onPressed: () {},
            ),
            FloatingActionButton.large(
              heroTag: 'large',
              child: const Icon(Icons.edit),
              onPressed: () {},
            ),
            FloatingActionButton.extended(
              heroTag: 'extended',
              icon: const Icon(Icons.edit),
              label: const Text('Label'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
