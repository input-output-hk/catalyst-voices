import 'package:catalyst_voices/pages/registration/incorrect_seed_phrase_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_confirmation_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_dialog.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show SeedPhrase, SeedPhraseWord;
import 'package:flutter/widgets.dart';

mixin UploadSeedPhraseMixin<T extends StatefulWidget> on State<T> {
  Future<List<SeedPhraseWord>?> importSeedPhraseWords({
    bool requireConfirmation = true,
    bool validate = true,
  }) async {
    if (requireConfirmation) {
      final confirmed = await UploadSeedPhraseConfirmationDialog.show(context);
      if (!confirmed) {
        return null;
      }
    }

    if (!mounted) {
      return null;
    }

    final words = await UploadSeedPhraseDialog.show(context);
    if (words == null || !mounted) {
      return null;
    }

    if (!validate || SeedPhrase.isValid(words: words)) {
      return words;
    }

    final showUpload = await IncorrectSeedPhraseDialog.show(context);
    if (!showUpload || !mounted) {
      return null;
    }

    return importSeedPhraseWords(
      requireConfirmation: false,
      validate: validate,
    );
  }
}
