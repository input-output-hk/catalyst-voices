import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SplashPanel extends StatelessWidget {
  const SplashPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: SingleChildScrollView(
        child: RegistrationStageMessage(
          title: Text(context.l10n.accountCreationSplashTitle),
          subtitle: Text(context.l10n.accountCreationSplashMessage),
        ),
      ),
      footer: VoicesFilledButton(
        key: const Key('CreateKeychainButton'),
        child: Text(context.l10n.accountCreationSplashNextButton),
        onTap: () => RegistrationCubit.of(context).nextStep(),
      ),
    );
  }
}
