import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            VoicesFilledButton(
              child: const Text('Upload file dialog'),
              onTap: () async {
                final file = await VoicesUploadFileDialog.show(
                  context,
                  title: context.l10n.uploadKeychainTitle,
                  itemNameToUpload: context.l10n.key,
                  info: context.l10n.uploadKeychainInfo,
                  allowedExtensions: ['ckf', 'log'],
                  onUpload: (_) async {
                    await Future<void>.delayed(const Duration(seconds: 2));
                  },
                );
                if (file != null) {
                  debugPrint('uploaded file: ${file.name}');
                }
              },
            ),
            VoicesFilledButton(
              child: const Text('Desktop info dialog'),
              onTap: () async {
                await VoicesDialog.show<void>(
                  context: context,
                  builder: (context) {
                    return const VoicesDesktopInfoDialog(
                      title: Text('Desktop modal'),
                    );
                  },
                );
              },
            ),
            VoicesFilledButton(
              child: const Text('Alert Dialog'),
              onTap: () => unawaited(
                VoicesDialog.show<void>(
                  context: context,
                  builder: (context) {
                    return VoicesAlertDialog(
                      title: const Text('WARNING'),
                      icon: VoicesAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        icon: VoicesAssets.icons.exclamation.buildIcon(
                          size: 36,
                          color: Theme.of(context).colors.iconsError,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colors.iconsError,
                          width: 3,
                        ),
                      ),
                      subtitle: const Text('ACCOUNT CREATION INCOMPLETE!'),
                      content: const Text(
                        'If attempt to leave without creating your keychain'
                        ' - account creation will be incomplete.\n\nYou are'
                        ' not able to login without completing your keychain.',
                      ),
                      buttons: [
                        VoicesFilledButton(
                          child: const Text('Continue keychain creation'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        VoicesTextButton(
                          child: const Text('Cancel anyway'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
