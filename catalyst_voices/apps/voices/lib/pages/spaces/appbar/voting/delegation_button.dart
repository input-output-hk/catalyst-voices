import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DelegationButton extends StatelessWidget {
  const DelegationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      leading: VoicesAssets.icons.vote.buildIcon(),
      child: Text(context.l10n.delegationButton),
    );
  }
}
