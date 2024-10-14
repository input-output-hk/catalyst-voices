import 'package:catalyst_voices/pages/registration/bloc_unlock_password_builder.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/bloc_seed_phrase_builder.dart';
import 'package:catalyst_voices/pages/registration/pictures/keychain_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/keychain_with_password_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/password_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/seed_phrase_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices/pages/registration/widgets/information_panel.dart';
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
    return BlocSelector<
        RegistrationCubit,
        RegistrationState,
        ({
          RegistrationStep step,
          double? progress,
        })>(
      selector: (state) => (
        step: state.step,
        progress: state.progress,
      ),
      builder: (context, state) {
        final headerStrings = _buildHeaderStrings(
          context,
          step: state.step,
        );

        return InformationPanel(
          title: headerStrings.title,
          subtitle: headerStrings.subtitle,
          body: headerStrings.body,
          picture: _RegistrationPicture(step: state.step),
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
          _HeaderStrings(
            title: context.l10n.catalystKeychain,
          ),
        CreateKeychainStage.seedPhrase => _HeaderStrings(
            title: context.l10n.catalystKeychain,
            subtitle: context.l10n.createKeychainSeedPhraseSubtitle,
            body: context.l10n.createKeychainSeedPhraseBody,
          ),
        CreateKeychainStage.checkSeedPhraseInstructions => _HeaderStrings(
            title: context.l10n.catalystKeychain,
          ),
        CreateKeychainStage.checkSeedPhrase => _HeaderStrings(
            title: context.l10n.catalystKeychain,
            subtitle: context.l10n.createKeychainSeedPhraseCheckSubtitle,
            body: context.l10n.createKeychainSeedPhraseCheckBody,
          ),
        CreateKeychainStage.checkSeedPhraseResult ||
        CreateKeychainStage.unlockPasswordInstructions =>
          _HeaderStrings(
            title: context.l10n.catalystKeychain,
          ),
        CreateKeychainStage.unlockPasswordCreate => _HeaderStrings(
            title: context.l10n.catalystKeychain,
            subtitle: context.l10n.createKeychainUnlockPasswordIntoSubtitle,
            body: context.l10n.createKeychainUnlockPasswordIntoBody,
          ),
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
      FinishAccountCreationStep() => _HeaderStrings(
          title: context.l10n.catalystKeychain,
        ),
      RecoverMethodStep() => _HeaderStrings(
          title: context.l10n.recoverCatalystKeychain,
        ),
      SeedPhraseRecoverStep() => _HeaderStrings(
          title: context.l10n.recoverCatalystKeychain,
        ),
      CreateKeychainStep(:final stage) => buildKeychainStageHeader(stage),
      WalletLinkStep(:final stage) => buildWalletLinkStageHeader(stage),
      AccountCompletedStep() => _HeaderStrings(title: 'TODO'),
    };
  }
}

class _RegistrationPicture extends StatelessWidget {
  final RegistrationStep step;

  const _RegistrationPicture({
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildKeychainStagePicture(CreateKeychainStage stage) {
      return switch (stage) {
        CreateKeychainStage.splash ||
        CreateKeychainStage.instructions =>
          const KeychainPicture(),
        CreateKeychainStage.seedPhrase => const SeedPhrasePicture(),
        CreateKeychainStage.checkSeedPhraseInstructions ||
        CreateKeychainStage.checkSeedPhrase =>
          const SeedPhrasePicture(indicateSelection: true),
        CreateKeychainStage.checkSeedPhraseResult =>
          const _BlocSeedPhraseResultPicture(),
        CreateKeychainStage.unlockPasswordInstructions ||
        CreateKeychainStage.unlockPasswordCreate =>
          const _BlocCreationPasswordPicture(),
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

    Widget buildRecoverSeedPhrase(RecoverSeedPhraseStage stage) {
      return switch (stage) {
        RecoverSeedPhraseStage.seedPhraseInstructions ||
        RecoverSeedPhraseStage.seedPhrase ||
        RecoverSeedPhraseStage.accountDetails =>
          const KeychainPicture(),
        RecoverSeedPhraseStage.unlockPasswordInstructions ||
        RecoverSeedPhraseStage.unlockPassword =>
          const _BlocRecoveryPasswordPicture(),
        RecoverSeedPhraseStage.success => const KeychainWithPasswordPicture(),
      };
    }

    return switch (step) {
      GetStartedStep() => const KeychainPicture(),
      RecoverMethodStep() => const KeychainPicture(),
      SeedPhraseRecoverStep(:final stage) => buildRecoverSeedPhrase(stage),
      CreateKeychainStep(:final stage) => buildKeychainStagePicture(stage),
      FinishAccountCreationStep() => const KeychainWithPasswordPicture(),
      WalletLinkStep(:final stage) => buildWalletLinkStagePicture(stage),
      AccountCompletedStep() => const KeychainPicture(),
    };
  }
}

class _BlocSeedPhraseResultPicture extends StatelessWidget {
  const _BlocSeedPhraseResultPicture();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseBuilder<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        return SeedPhrasePicture(
          type: state ? TaskPictureType.success : TaskPictureType.error,
          indicateSelection: true,
        );
      },
    );
  }
}

class _BlocCreationPasswordPicture extends StatelessWidget {
  const _BlocCreationPasswordPicture();

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<TaskPictureType>(
      stateSelector: (state) => state.keychainStateData.unlockPasswordState,
      selector: (state) => state.pictureType,
      builder: (context, state) => PasswordPicture(type: state),
    );
  }
}

class _BlocRecoveryPasswordPicture extends StatelessWidget {
  const _BlocRecoveryPasswordPicture();

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<TaskPictureType>(
      stateSelector: (state) => state.recoverStateData.unlockPasswordState,
      selector: (state) => state.pictureType,
      builder: (context, state) => PasswordPicture(type: state),
    );
  }
}

extension _UnlockPasswordStateExt on UnlockPasswordState {
  TaskPictureType get pictureType {
    if (showPasswordMisMatch) {
      return TaskPictureType.error;
    }
    if (isNextEnabled) {
      return TaskPictureType.success;
    }
    return TaskPictureType.normal;
  }
}
