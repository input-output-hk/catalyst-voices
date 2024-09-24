import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): add content for the screen
class SelectWalletDialog extends StatelessWidget {
  final ValueChanged<CardanoWallet> onSelectedWallet;

  const SelectWalletDialog({
    super.key,
    required this.onSelectedWallet,
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
            onTap: () {
              // TODO(dtscalac): call onSelectedWallet
            },
            child: Text(context.l10n.chooseCardanoWallet),
          ),
        ],
      ),
    );
  }
}
