import 'dart:convert';

import 'package:catalyst_voices/widgets/modals/voices_upload_file_dialog.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class UploadSeedphraseDialog {
  static Future<List<SeedPhraseWord>> show(BuildContext rootContext) async {
    final file = await VoicesUploadFileDialog.show(
      rootContext,
      title: rootContext.l10n.uploadKeychainTitle,
      itemNameToUpload: rootContext.l10n.key,
      info: rootContext.l10n.uploadKeychainInfo,
      allowedExtensions: ['txt'],
    );

    final bytes = file?.bytes;
    if (bytes != null) {
      final decodedText = utf8.decode(bytes);
      final words = decodedText
          .split(' ')
          .mapIndexed((i, e) => SeedPhraseWord(e, nr: i + 1))
          .toList();

      return words;
    } else {
      return [];
    }
  }
}
