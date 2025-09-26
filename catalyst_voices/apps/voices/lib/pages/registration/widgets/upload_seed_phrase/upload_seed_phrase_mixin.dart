import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/incorrect_seed_phrase_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_confirmation_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/upload_seed_phrase/upload_seed_phrase_dialog.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' show SeedPhrase;
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

const _allowedExtensions = ['txt'];

mixin UploadSeedPhraseMixin<T extends StatefulWidget> on State<T> {
  Future<SeedPhrase?> importSeedPhrase({
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

    final seedPhrase = await _getSeedPhrase();
    if (seedPhrase == null || !mounted) {
      return null;
    }

    if (!validate || SeedPhrase.isValid(mnemonic: seedPhrase.mnemonic)) {
      return seedPhrase;
    }

    final showUpload = await IncorrectSeedPhraseDialog.show(context);
    if (!showUpload || !mounted) {
      return null;
    }

    return importSeedPhrase(
      requireConfirmation: false,
      validate: validate,
    );
  }

  Future<SeedPhrase?> _getSeedPhrase() async {
    if (CatalystOperatingSystem.current.isMobile && !CatalystPlatform.isWeb) {
      final service = Dependencies.instance.get<UploaderService>();
      final pickedFile = await service.uploadFile(allowedExtensions: _allowedExtensions);
      if (pickedFile == null) {
        return null;
      }
      final bytes = await pickedFile.readAsBytes();
      return SeedPhrase.fromBytes(bytes, validate: false);
    }

    return UploadSeedPhraseDialog.show(
      context,
      validate: false,
      allowedExtensions: _allowedExtensions,
    );
  }
}
