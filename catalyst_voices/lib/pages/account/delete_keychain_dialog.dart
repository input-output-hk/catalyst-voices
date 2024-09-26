import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class DeleteKeychainDialog extends StatelessWidget {
  const DeleteKeychainDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxHeight: 500, maxWidth: 900),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Delete Keychain?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 48),
                  Text(
                    '''
Are you sure you wants to delete your  Catalyst Keychain from this device?''',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    children: [
                      VoicesAssets.icons.exclamation.buildIcon(
                        color: Theme.of(context).colors.iconsError,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 8),
                        child: Text(
                          '''
Make sure you have a working Catalyst 12-word seedphrase!''',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '''
Your Catalyst account will be removed, this action cannot be undone!''',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'To avoid mistakes, please type ‘Remove Keychain’ below.',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        'Confirm removal',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 300,
                        child: VoicesTextField(
                          decoration: VoicesTextFieldDecoration(
                            filled: true,
                            fillColor: Theme.of(context)
                                .colors
                                .elevationsOnSurfaceNeutralLv1White,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    children: [
                      VoicesFilledButton(
                        backgroundColor: Theme.of(context).colors.iconsError,
                        onTap: () {},
                        child: const Text('Delete'),
                      ),
                      const SizedBox(width: 8),
                      VoicesTextButton.custom(
                        color: Theme.of(context).colors.iconsError,
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
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
