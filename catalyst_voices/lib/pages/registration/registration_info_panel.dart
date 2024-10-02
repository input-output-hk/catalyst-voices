import 'package:catalyst_voices/pages/registration/information_panel.dart';
import 'package:catalyst_voices/pages/registration/pictures/keychain_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/password_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/seed_phrase_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  const RegistrationInfoPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final headerStrings = _buildHeaderStrings(
          context,
          step: state.step,
        );

        return InformationPanel(
          title: headerStrings.title,
          subtitle: headerStrings.subtitle,
          body: headerStrings.body,
          picture: _RegistrationPicture(state: state),
          progress: state.progress,
        );
      },
    );
  }

  _HeaderStrings _buildHeaderStrings(
    BuildContext context, {
    required RegistrationStep step,
  }) {
    _HeaderStrings buildKeychainStageHeader(CreateKeychainStage stage) {
      return switch (stage) {
        CreateKeychainStage.splash ||
        CreateKeychainStage.instructions =>
          _HeaderStrings(title: context.l10n.catalystKeychain),
        CreateKeychainStage.seedPhrase => _HeaderStrings(
            title: context.l10n.catalystKeychain,
            subtitle: context.l10n.createKeychainSeedPhraseSubtitle,
            body: context.l10n.createKeychainSeedPhraseBody,
          ),
        CreateKeychainStage.checkSeedPhraseInstructions =>
          _HeaderStrings(title: context.l10n.catalystKeychain),
        CreateKeychainStage.checkSeedPhrase => _HeaderStrings(
            title: context.l10n.catalystKeychain,
            subtitle: context.l10n.createKeychainSeedPhraseCheckSubtitle,
            body: context.l10n.createKeychainSeedPhraseCheckBody,
          ),
        CreateKeychainStage.checkSeedPhraseResult ||
        CreateKeychainStage.unlockPasswordInstructions =>
          _HeaderStrings(title: context.l10n.catalystKeychain),
        CreateKeychainStage.unlockPasswordCreate =>
          _HeaderStrings(title: 'TODO'),
      };
    }

    _HeaderStrings buildWalletLinkStageHeader(WalletLinkStage stage) {
      return switch (stage) {
        WalletLinkStage.intro ||
        WalletLinkStage.selectWallet ||
        WalletLinkStage.walletDetails =>
          _HeaderStrings(
            title: context.l10n.walletLinkHeader,
            subtitle: context.l10n.walletLinkWalletSubheader,
          ),
        WalletLinkStage.rolesChooser ||
        WalletLinkStage.rolesSummary =>
          _HeaderStrings(
            title: context.l10n.walletLinkHeader,
            subtitle: context.l10n.walletLinkRolesSubheader,
          ),
        WalletLinkStage.rbacTransaction => _HeaderStrings(
            title: context.l10n.walletLinkHeader,
            subtitle: context.l10n.walletLinkTransactionSubheader,
          ),
      };
    }

    return switch (step) {
      GetStartedStep() => _HeaderStrings(title: context.l10n.getStarted),
      FinishAccountCreationStep() => _HeaderStrings(title: 'TODO'),
      RecoverStep() => _HeaderStrings(title: 'TODO'),
      CreateKeychainStep(:final stage) => buildKeychainStageHeader(stage),
      WalletLinkStep(:final stage) => buildWalletLinkStageHeader(stage),
      AccountCompletedStep() => _HeaderStrings(title: 'TODO'),
    };
  }
}

class _RegistrationPicture extends StatelessWidget {
  final RegistrationState state;

  const _RegistrationPicture({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildKeychainStagePicture(
      CreateKeychainStage stage, {
      required bool isSeedPhraseCheckConfirmed,
    }) {
      return switch (stage) {
        CreateKeychainStage.splash ||
        CreateKeychainStage.instructions =>
          const KeychainPicture(),
        CreateKeychainStage.seedPhrase => const SeedPhrasePicture(),
        CreateKeychainStage.checkSeedPhraseInstructions ||
        CreateKeychainStage.checkSeedPhrase =>
          const SeedPhrasePicture(
            indicateSelection: true,
          ),
        CreateKeychainStage.checkSeedPhraseResult => SeedPhrasePicture(
            type: isSeedPhraseCheckConfirmed
                ? TaskPictureType.success
                : TaskPictureType.error,
            indicateSelection: true,
          ),
        CreateKeychainStage.unlockPasswordInstructions ||
        CreateKeychainStage.unlockPasswordCreate =>
          const PasswordPicture(),
      };
    }

    Widget buildWalletLinkStagePicture(WalletLinkStage stage) {
      return switch (stage) {
        WalletLinkStage.intro ||
        WalletLinkStage.selectWallet ||
        WalletLinkStage.walletDetails ||
        WalletLinkStage.rolesChooser ||
        WalletLinkStage.rolesSummary ||
        WalletLinkStage.rbacTransaction =>
          const KeychainPicture(),
      };
    }

    return switch (state) {
      GetStarted() => const KeychainPicture(),
      FinishAccountCreation() => const KeychainPicture(),
      Recover() => const KeychainPicture(),
      CreateKeychain(:final stage, :final seedPhraseState) =>
        buildKeychainStagePicture(
          stage,
          isSeedPhraseCheckConfirmed: seedPhraseState.isCheckConfirmed,
        ),
      WalletLink(:final stage) => buildWalletLinkStagePicture(stage),
      AccountCompleted() => const KeychainPicture(),
    };
  }
}
