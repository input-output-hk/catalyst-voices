import 'package:catalyst_voices/pages/registration/next_step.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeedPhraseCheckResultPanel extends StatelessWidget {
  const SeedPhraseCheckResultPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: _BlocRegistrationStageMessage(),
          ),
        ),
        _BlocNextStep(),
        SizedBox(height: 10),
        _BlocNavigation(),
      ],
    );
  }
}

class _BlocRegistrationStageMessage extends StatelessWidget {
  const _BlocRegistrationStageMessage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        return previous
                .keychainStateData.seedPhraseStateData.areUserWordsCorrect !=
            current.keychainStateData.seedPhraseStateData.areUserWordsCorrect;
      },
      builder: (context, state) {
        final areUserWordsCorrect =
            state.keychainStateData.seedPhraseStateData.areUserWordsCorrect;

        // TODO(damian-molinski): use correct strings when available.
        return RegistrationStageMessage(
          title: Text(
            areUserWordsCorrect
                ? context.l10n.createKeychainSeedPhraseCheckSuccessTitle
                : 'Seed phrase words does not match!',
          ),
          subtitle: Text(
            areUserWordsCorrect
                ? context.l10n.createKeychainSeedPhraseCheckSuccessSubtitle
                : 'Go back ana make sure order is correct',
          ),
        );
      },
    );
  }
}

class _BlocNextStep extends StatelessWidget {
  const _BlocNextStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        return previous
                .keychainStateData.seedPhraseStateData.areUserWordsCorrect !=
            current.keychainStateData.seedPhraseStateData.areUserWordsCorrect;
      },
      builder: (context, state) {
        return Offstage(
          offstage:
              !state.keychainStateData.seedPhraseStateData.areUserWordsCorrect,
          child: NextStep(
            context.l10n.createKeychainSeedPhraseCheckSuccessNextStep,
          ),
        );
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      buildWhen: (previous, current) {
        return previous
                .keychainStateData.seedPhraseStateData.areUserWordsCorrect !=
            current.keychainStateData.seedPhraseStateData.areUserWordsCorrect;
      },
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled:
              state.keychainStateData.seedPhraseStateData.areUserWordsCorrect,
        );
      },
    );
  }
}
