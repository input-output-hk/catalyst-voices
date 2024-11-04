import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/generated/assets.gen.dart';

class VoicesAvatarExample extends StatelessWidget {
  static const String route = '/avatars-example';

  const VoicesAvatarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Avatars')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            VoicesAvatar(
              icon: VoicesAssets.icons.check.buildIcon(),
            ),
            VoicesAvatar(
              backgroundColor: Colors.transparent,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              icon: VoicesAssets.icons.check.buildIcon(),
            ),
            VoicesAvatar(
              icon: const Text('A'),
              onTap: () {},
            ),
            VoicesAvatar(
              icon: VoicesAssets.icons.lightBulb.buildIcon(),
              foregroundColor: Theme.of(context).colors.iconsSecondary,
              backgroundColor:
                  Theme.of(context).colors.iconsSecondary?.withOpacity(0.16),
            ),
            VoicesAvatar(
              icon: Image.asset(UiKitAssets.images.robotAvatar.path),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
