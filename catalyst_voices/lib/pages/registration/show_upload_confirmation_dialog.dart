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
  bool Function(List<SeedPhraseWord> value)? onValidate,
}) async {
  await VoicesDialog.show<void>(
    context: rootContext,
    builder: (context) {
      return VoicesAlertDialog(
        title: Text(context.l10n.alert.toUpperCase()),
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
        subtitle: Text(context.l10n.uploadConfirmDialogSubtitle),
        content: Text(context.l10n.uploadConfirmDialogContent),
        buttons: [
          VoicesFilledButton(
            child: Text(context.l10n.uploadConfirmDialogYesButton),
            onTap: () async {
              Navigator.of(context).pop();
              await _showUploadDialog(
                rootContext,
                onUploadSuccessful,
                onValidate,
              );
            },
          ),
          VoicesTextButton(
            child: Text(context.l10n.uploadConfirmDialogResumeButton),
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
  bool Function(List<SeedPhraseWord> value)? onValidate,
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
          .mapIndexed((i, e) => SeedPhraseWord(e, nr: i + 1))
          .toList();
      final isValid = onValidate?.call(words) ?? false;

      if (isValid) {
        onUploadSuccessful?.call(words);
      } else {
        Navigator.of(rootContext).pop();
        await _showIncorrectUploadDialog(
          rootContext,
          onUploadSuccessful,
          onValidate,
        );
      }
    },
  );
}

Future<void> _showIncorrectUploadDialog(
  BuildContext rootContext,
  ValueChanged<List<SeedPhraseWord>>? onUploadSuccessful,
  bool Function(List<SeedPhraseWord> value)? onValidate,
) async {
  await VoicesDialog.show<void>(
    context: rootContext,
    builder: (context) {
      return VoicesAlertDialog(
        title: Text(context.l10n.warning.toUpperCase()),
        icon: CatalystImage.asset(
          VoicesAssets.images.keyIncorrect.path,
          width: 80,
          height: 80,
        ),
        subtitle: Text(context.l10n.incorrectUploadDialogSubtitle),
        content: Text(
          context.l10n.incorrectUploadDialogContent,
        ),
        buttons: [
          VoicesFilledButton(
            child: Text(context.l10n.incorrectUploadDialogTryAgainButton),
            onTap: () async {
              Navigator.of(context).pop();
              await _showUploadDialog(
                rootContext,
                onUploadSuccessful,
                onValidate,
              );
            },
          ),
          VoicesTextButton(
            child: Text(context.l10n.cancelButtonText),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
