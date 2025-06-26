import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
          _NextButton(),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('CreateBaseProfileNext'),
      onTap: () => RegistrationCubit.of(context).nextStep(),
      child: Text(context.l10n.createProfileInstructionsNext),
    );
  }
}

class _PanelMainMessage extends StatelessWidget {
  const _PanelMainMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RegistrationStageMessage(
      title: Text(l10n.createProfileInstructionsTitle),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(l10n.createProfileInstructionsMessage),
          const _WalletBalanceNotice(),
        ],
      ),
    );
  }
}

class _WalletBalanceNotice extends StatelessWidget {
  const _WalletBalanceNotice();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.notice,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.createProfileInstructionsNotice(
            CardanoWalletDetails.minAdaForRegistration.ada,
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
