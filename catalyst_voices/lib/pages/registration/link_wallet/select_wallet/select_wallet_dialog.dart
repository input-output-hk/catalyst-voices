import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/pages/account/creation/task_picture.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): add content for the screen
class SelectWalletDialog extends StatelessWidget {
  final ValueChanged<CardanoWallet> onSelectedWallet;
  final VoidCallback onBack;

  const SelectWalletDialog({
    super.key,
    required this.onSelectedWallet,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopPanelsDialog(
      left: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletLinkHeader,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.walletLinkSubheader,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 50),
          const TaskKeychainPicture(),
          const Spacer(),
          VoicesLearnMoreButton(
            onTap: () {},
          ),
        ],
      ),
      right: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            context.l10n.walletLinkIntroTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.walletLinkIntroContent,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          VoicesOutlinedButton(
            leading: VoicesAssets.icons.wallet.buildIcon(),
            onTap: onBack,
            child: Text(context.l10n.chooseCardanoWallet),
          ),
        ],
      ),
    );
  }
}
