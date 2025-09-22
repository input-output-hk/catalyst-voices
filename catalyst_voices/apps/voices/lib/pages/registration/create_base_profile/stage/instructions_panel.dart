import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/instructions_acknowledgements.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/instructions_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class InstructionsPanel extends StatelessWidget {
  const InstructionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegistrationDetailsPanelScaffold(
      body: SingleChildScrollView(child: _PanelMainMessage()),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InstructionsAcknowledgements(),
          SizedBox(height: 24),
          InstructionsNavigation(),
        ],
      ),
    );
  }
}

class _PanelMainMessage extends StatelessWidget {
  const _PanelMainMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final money = CardanoWalletDetails.minAdaForRegistration.toMoney();

    return RegistrationStageMessage(
      title: Text(
        l10n.createProfileInstructionsTitle,
        semanticsIdentifier: 'createProfileInstructionsTitle',
      ),
      spacing: 12,
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            l10n.createProfileInstructionsMessage(
              MoneyFormatter.formatCompactRounded(money, includeSymbol: false),
              money.currency.isoCode.code,
            ),
            semanticsIdentifier: 'createProfileInstructionsMessage',
          ),
        ],
      ),
    );
  }
}
