import 'package:catalyst_voices/pages/registration/widgets/next_step.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseCheckResultPanel extends StatelessWidget {
  const SeedPhraseCheckResultPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const RegistrationDetailsPanelScaffold(
      body: SingleChildScrollView(child: _BlocRegistrationStageMessage()),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BlocNextStep(),
          SizedBox(height: 10),
          _BlocNavigation(),
        ],
      ),
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
        );
      },
    );
  }
}

class _BlocNextStep extends StatelessWidget {
  const _BlocNextStep();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: NextStep(
            context.l10n.createKeychainSeedPhraseCheckSuccessNextStep,
          ),
        );
      },
    );
  }
}

class _BlocRegistrationStageMessage extends StatelessWidget {
  const _BlocRegistrationStageMessage();

  @override
  Widget build(BuildContext context) {
    return BlocSeedPhraseSelector<bool>(
      selector: (state) => state.areUserWordsCorrect,
      builder: (context, state) {
        // TODO(damian-molinski): use correct strings when available.
        return RegistrationStageMessage(
          title: Text(
            state
                ? context.l10n.createKeychainSeedPhraseCheckSuccessTitle
                : 'Seed phrase words does not match!',
          ),
          subtitle: Text(
            state
                ? context.l10n.createKeychainSeedPhraseCheckSuccessSubtitle
                : 'Go back ana make sure order is correct',
          ),
        );
      },
    );
  }
}
