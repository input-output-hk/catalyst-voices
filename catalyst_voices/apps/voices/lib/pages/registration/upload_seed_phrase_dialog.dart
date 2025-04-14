import 'dart:convert';

import 'package:catalyst_voices/widgets/modals/voices_upload_file_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class UploadSeedPhraseDialog {
  static Future<List<SeedPhraseWord>?> show(BuildContext context) async {
    final file = await VoicesUploadFileDialog.show(
      context,
      routeSettings: const RouteSettings(name: '/upload-seed-phrase'),
      title: context.l10n.uploadKeychainTitle,
      itemNameToUpload: context.l10n.key,
      info: context.l10n.uploadKeychainInfo,
      allowedExtensions: ['txt'],
    );

    if (file == null) {
      return null;
    }

    final bytes = file.bytes;
    final decodedText = utf8.decode(bytes);
    final words = decodedText
        .split(' ')
        .mapIndexed((i, e) => SeedPhraseWord(e, nr: i + 1))
        .toList();

    return words;
  }
}
