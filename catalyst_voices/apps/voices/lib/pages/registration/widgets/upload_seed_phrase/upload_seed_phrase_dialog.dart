import 'package:catalyst_voices/widgets/modals/upload/voices_upload_file_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

abstract final class UploadSeedPhraseDialog {
  const UploadSeedPhraseDialog._();

  static Future<SeedPhrase?> show(
    BuildContext context, {
    bool validate = true,
    List<String>? allowedExtensions,
  }) async {
    final file = await VoicesUploadFileDialog.show(
      context,
      routeSettings: const RouteSettings(name: '/upload-seed-phrase'),
      title: context.l10n.uploadKeychainTitle,
      itemNameToUpload: context.l10n.key,
      info: context.l10n.uploadKeychainInfo,
      allowedExtensions: allowedExtensions,
    );

    if (file == null) {
      return null;
    }

    final bytes = await file.readAsBytes();

    return SeedPhrase.fromBytes(bytes, validate: validate);
  }
}
