import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class KeychainDeletedDialog extends StatelessWidget {
  const KeychainDeletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxHeight: 260, maxWidth: 900),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                context.l10n.keychainDeletedDialogTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 48),
              Text(
                context.l10n.keychainDeletedDialogSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n.keychainDeletedDialogInfo,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              VoicesFilledButton(
                onTap: () => Navigator.of(context).pop(),
                child: Text(context.l10n.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
