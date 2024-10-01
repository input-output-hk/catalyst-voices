import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class VoicesUploadFileDialog extends StatelessWidget {
  const VoicesUploadFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 450),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Catalyst Keychain'.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: [8, 6],
                  color: Theme.of(context).colors.iconsPrimary!,
                  child: Container(),
                ),
              ),
            ),
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colors.iconsPrimary!,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: VoicesOutlinedButton(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancelButtonText),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: VoicesFilledButton(
                    onTap: () {},
                    child: Text('Upload'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
