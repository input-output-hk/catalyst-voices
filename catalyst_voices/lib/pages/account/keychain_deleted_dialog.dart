import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class KeychainDeletedDialog extends StatelessWidget {
  const KeychainDeletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxHeight: 260, maxWidth: 900),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Catalyst keychain removed',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 48),
                  Text(
                    '''
Your Catalyst Keychain is removed successfully from this device.''',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '''
We reverted this device to Catalyst first use.''',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  VoicesFilledButton(
                    //backgroundColor: Theme.of(context).colors.iconsError,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
          const DialogCloseButton(),
        ],
      ),
    );
  }
}
