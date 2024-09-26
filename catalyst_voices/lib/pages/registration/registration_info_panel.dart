import 'package:catalyst_voices/pages/registration/information_panel.dart';
import 'package:catalyst_voices/pages/registration/task_picture.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class _HeaderStrings {
  final String title;
  final String? subtitle;
  final String? body;

  _HeaderStrings({
    required this.title,
    this.subtitle,
    this.body,
  });
}

class RegistrationInfoPanel extends StatelessWidget {
  final RegistrationState state;

  const RegistrationInfoPanel({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final headerStrings = _buildHeaderStrings(context);

    return InformationPanel(
      title: headerStrings.title,
      subtitle: headerStrings.subtitle,
      body: headerStrings.body,
      picture: const TaskKeychainPicture(),
    );
  }

  _HeaderStrings _buildHeaderStrings(BuildContext context) {
    _HeaderStrings buildKeychainStageHeader(CreateKeychainStage stage) {
      return switch (stage) {
        CreateKeychainStage.splash ||
        CreateKeychainStage.instructions =>
          _HeaderStrings(title: context.l10n.catalystKeychain),
        CreateKeychainStage.seedPhrase ||
        CreateKeychainStage.checkSeedPhraseInstructions ||
        CreateKeychainStage.checkSeedPhrase ||
        CreateKeychainStage.checkSeedPhraseResult ||
        CreateKeychainStage.unlockPasswordInstructions ||
        CreateKeychainStage.unlockPasswordCreate ||
        CreateKeychainStage.created =>
          _HeaderStrings(title: 'TODO'),
      };
    }

    _HeaderStrings buildWalletStageHeader(WalletLinkStage stage) {
      return switch (stage) {
        WalletLinkStage.intro => _HeaderStrings(
            title: 'Link keys to your  Catalyst Keychain',
            subtitle: 'Link your Cardano wallet',
          ),
        WalletLinkStage.selectWallet => _HeaderStrings(
            title: 'Link keys to your  Catalyst Keychain',
            subtitle: 'Link your Cardano wallet',
          ),
      };
    }

    return switch (state) {
      GetStarted() => _HeaderStrings(title: context.l10n.getStarted),
      FinishAccountCreation() => _HeaderStrings(title: 'TODO'),
      Recover() => _HeaderStrings(title: 'TODO'),
      CreateKeychain(:final stage) => buildKeychainStageHeader(stage),
      WalletLink(:final stage) => buildWalletStageHeader(stage),
    };
  }
}
