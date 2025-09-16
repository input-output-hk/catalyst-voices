import 'package:catalyst_voices/widgets/buttons/voices_responsive_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoteDelegationButton extends StatelessWidget {
  const VoteDelegationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesResponsiveOutlinedButton(
      icon: VoicesAssets.icons.userGroup.buildIcon(),
      child: Text(context.l10n.delegationButton),
    );
  }
}
