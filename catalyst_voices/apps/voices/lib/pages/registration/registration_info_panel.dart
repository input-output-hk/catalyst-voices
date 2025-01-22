import 'package:catalyst_voices/pages/registration/pictures/account_completed_picture.dart';
import 'package:catalyst_voices/pages/registration/pictures/base_profile_picture.dart';
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
          key: const Key('RegistrationInfoPanel'),
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
      AccountCreateProgressStep() => _HeaderStrings(
          title: context.l10n.catalystKeychain,
        ),
      RecoverMethodStep() => _HeaderStrings(
          title: context.l10n.recoverCatalystKeychain,
        ),
      RecoverWithSeedPhraseStep() => _HeaderStrings(
          title: context.l10n.recoverCatalystKeychain,
        ),
      CreateBaseProfileStep() => _HeaderStrings(
          title: context.l10n.accountCreationGetStartedTitle,
        ),
      CreateKeychainStep(:final stage) => buildKeychainStageHeader(stage),
      WalletLinkStep(:final stage) => buildWalletLinkStageHeader(stage),
      AccountCompletedStep() => _HeaderStrings(
          title: context.l10n.registrationCompletedTitle,
          subtitle: context.l10n.registrationCompletedSubtitle,
        ),
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

    Widget buildRecoverSeedPhrase(RecoverWithSeedPhraseStage stage) {
      return switch (stage) {
        RecoverWithSeedPhraseStage.seedPhraseInstructions ||
        RecoverWithSeedPhraseStage.seedPhrase ||
        RecoverWithSeedPhraseStage.accountDetails =>
          const KeychainPicture(),
        RecoverWithSeedPhraseStage.unlockPasswordInstructions ||
        RecoverWithSeedPhraseStage.unlockPassword =>
          const _BlocRecoveryPasswordPicture(),
        RecoverWithSeedPhraseStage.success =>
          const KeychainWithPasswordPicture(),
      };
    }

    Widget buildRegistrationProgress(
      List<AccountCreateStepType> completedSteps,
    ) {
      if (completedSteps.lastOrNull == AccountCreateStepType.baseProfile) {
        return const BaseProfilePicture(type: TaskPictureType.success);
      }
      if (completedSteps.lastOrNull == AccountCreateStepType.keychain) {
        return const KeychainWithPasswordPicture();
      }

      return const SizedBox.shrink();
    }

    return switch (step) {
      GetStartedStep() => const KeychainPicture(),
      RecoverMethodStep() => const KeychainPicture(),
      RecoverWithSeedPhraseStep(:final stage) => buildRecoverSeedPhrase(stage),
      CreateBaseProfileStep() => const BaseProfilePicture(),
      CreateKeychainStep(:final stage) => buildKeychainStagePicture(stage),
      AccountCreateProgressStep(:final completedSteps) =>
        buildRegistrationProgress(completedSteps),
      WalletLinkStep(:final stage) => buildWalletLinkStagePicture(stage),
      AccountCompletedStep() => const AccountCompletedPicture(),
    };
  }
}

class _BlocSeedPhraseResultPicture extends StatelessWidget {
  const _BlocSeedPhraseResultPicture();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
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
    return BlocUnlockPasswordSelector<TaskPictureType>(
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
    return BlocUnlockPasswordSelector<TaskPictureType>(
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
