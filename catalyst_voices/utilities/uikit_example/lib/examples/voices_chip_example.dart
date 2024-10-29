import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesChipExample extends StatelessWidget {
  static const String route = '/chips-example';

  const VoicesChipExample({super.key});

  @override
  Widget build(BuildContext context) {
    final backgrounds = [
      null,
      Theme.of(context).colorScheme.primaryContainer,
    ];

    final leadings = [
      null,
      VoicesAssets.icons.library.buildIcon(),
    ];

    final trailings = [
      null,
      VoicesAssets.icons.x.buildIcon(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Voices Chips')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final background in backgrounds)
              for (final leading in leadings)
                for (final trailing in trailings) ...[
                  VoicesChip.round(
                    content: const Text('Label'),
                    leading: leading,
                    trailing: trailing,
                    backgroundColor: background,
                    onTap: () {},
                  ),
                  VoicesChip.rectangular(
                    content: const Text('Label'),
                    leading: leading,
                    trailing: trailing,
                    backgroundColor: background,
                    onTap: () {},
                  ),
                ],
          ],
        ),
      ),
    );
  }
}
