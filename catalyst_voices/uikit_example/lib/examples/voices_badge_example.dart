import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesBadgeExample extends StatelessWidget {
  static const String route = '/badge-example';

  const VoicesBadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.error,
      Theme.of(context).colors.success!,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Voices Badges')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final color in colors) ...[
              Badge(
                label: const Text('3'),
                backgroundColor: color,
              ),
              Badge(
                label: const Text('32'),
                backgroundColor: color,
              ),
              Badge(
                backgroundColor: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
