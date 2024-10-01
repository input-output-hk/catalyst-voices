import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class VoicesUploadFileDialog extends StatelessWidget {
  const VoicesUploadFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoicesSinglePaneDialog(
      constraints: BoxConstraints(maxWidth: 600, maxHeight: 450),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(),
            SizedBox(height: 24),
            _UploadContainer(),
            _ChosenFileContainer(),
            SizedBox(height: 24),
            _Buttons(),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            child: const Text('Upload'),
          ),
        ),
      ],
    );
  }
}

class _ChosenFileContainer extends StatelessWidget {
  const _ChosenFileContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colors.iconsPrimary!,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: VoicesAssets.icons.documentAdd.buildIcon(
              color: Theme.of(context).colors.iconsPrimary!,
              size: 30,
            ),
          ),
          Text(
            'Catalyst_Keychain_10Sept2024-15:15.ckf',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _UploadContainer extends StatelessWidget {
  const _UploadContainer();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: const [8, 6],
          color: Theme.of(context).colors.iconsPrimary!,
          child: InkWell(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colors.iconsPrimary!,
                        width: 3,
                      ),
                    ),
                    child: VoicesAssets.icons.upload.buildIcon(
                      color: Theme.of(context).colors.iconsPrimary!,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Drop your key here or ',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'browse',
                            style: TextStyle(
                              color: Theme.of(context).colors.iconsPrimary!,
                            ),
                          ),
                        ]),
                  ),
                  Text(
                    "Make sure it's a correct Catalyst keychain file.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]
                    .separatedBy(
                      Container(
                        height: 12,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Upload Catalyst Keychain'.toUpperCase(),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
