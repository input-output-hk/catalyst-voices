import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class IntroPanel extends StatelessWidget {
  const IntroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      body: SingleChildScrollView(
        child: RegistrationStageMessage(
          title: Text(context.l10n.walletLinkIntroTitle),
          subtitle: Text(context.l10n.walletLinkIntroContent),
        ),
      ),
      footer: VoicesFilledButton(
        key: const Key('ChooseCardanoWalletButton'),
        leading: VoicesAssets.icons.wallet.buildIcon(),
        onTap: () {
          RegistrationCubit.of(context).nextStep();
        },
        child: Text(context.l10n.chooseCardanoWallet),
      ),
    );
  }
}
