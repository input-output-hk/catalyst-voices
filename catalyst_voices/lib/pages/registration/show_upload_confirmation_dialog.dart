import 'dart:convert';

import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_alert_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_upload_file_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

Future<void> showUploadConfirmationDialog(
  BuildContext rootContext, {
  ValueChanged<List<SeedPhraseWord>>? onUploadSuccessful,
}) async {
  await VoicesDialog.show<void>(
    context: rootContext,
    builder: (context) {
      return VoicesAlertDialog(
        title: const Text('ALERT'),
        icon: VoicesAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          icon: VoicesAssets.icons.exclamation.buildIcon(
            size: 36,
            color: Theme.of(context).colors.iconsError,
          ),
          border: Border.all(
            color: Theme.of(context).colors.iconsError!,
            width: 3,
          ),
        ),
        subtitle: const Text('SWITCH TO FILE UPLOAD'),
        content: const Text(
          'Do you want to cancel manual input, and switch to Catalyst key upload?',
        ),
        buttons: [
          VoicesFilledButton(
            child: const Text('Yes, switch to Catalyst key upload'),
            onTap: () async {
              Navigator.of(context).pop();
              await _showUploadDialog(rootContext, onUploadSuccessful);
            },
          ),
          VoicesTextButton(
            child: const Text('Resume manual input'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Future<void> _showUploadDialog(
  BuildContext rootContext,
  ValueChanged<List<SeedPhraseWord>>? onUploadSuccessful,
) async {
  await VoicesUploadFileDialog.show(
    rootContext,
    title: rootContext.l10n.uploadKeychainTitle,
    itemNameToUpload: rootContext.l10n.key,
    info: rootContext.l10n.uploadKeychainInfo,
    allowedExtensions: ['txt'],
    onUpload: (file) async {
      final bytes = file.bytes;
      final decodedText = utf8.decode(bytes);
      final words = decodedText
          .split(' ')
          .mapIndexed((i, e) => SeedPhraseWord(e, nr: i))
          .toList();
      final isValid = SeedPhrase.isValid(
        words: words,
      );

      if (isValid) {
        onUploadSuccessful?.call(words);
      } else {
        Navigator.of(rootContext).pop();
        await _showIncorrectUploadDialog(
          rootContext,
          onUploadSuccessful,
        );
      }
    },
    onCancel: () => debugPrint(
      'onCancel, we can cancel upload here',
    ),
  );
}

Future<void> _showIncorrectUploadDialog(
  BuildContext rootContext,
  ValueChanged<List<SeedPhraseWord>>? onUploadSuccessful,
) async {
  await VoicesDialog.show<void>(
    context: rootContext,
    builder: (context) {
      return VoicesAlertDialog(
        title: const Text('WARNING'),
        icon: CatalystImage.asset(
          VoicesAssets.images.keyIncorrect.path,
          width: 80,
          height: 80,
        ),
        subtitle: const Text('CATALYST KEY INCORRECT'),
        content: const Text(
          'The Catalyst keychain that you entered or uploaded is incorrect, please try again.',
        ),
        buttons: [
          VoicesFilledButton(
            child: const Text('Try again'),
            onTap: () async {
              Navigator.of(context).pop();
              await _showUploadDialog(
                rootContext,
                onUploadSuccessful,
              );
            },
          ),
          VoicesTextButton(
            child: const Text('Cancel'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
