import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): add content for the screen
class LinkWalletIntroDialog extends StatelessWidget {
  final VoidCallback onChooseCardanoWallet;

  const LinkWalletIntroDialog({
    super.key,
    required this.onChooseCardanoWallet,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopPanelsDialog(
      left: const Column(
        children: [Text('Left')],
      ),
      right: Column(
        children: [
          const Text('Right'),
          VoicesFilledButton(
            leading: VoicesAssets.icons.wallet.buildIcon(),
            onTap: onChooseCardanoWallet,
            child: Text(context.l10n.chooseCardanoWallet),
          ),
        ],
      ),
    );
  }
}
