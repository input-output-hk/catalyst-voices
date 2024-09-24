import 'package:catalyst_voices/widgets/buttons/specialized/voices_learn_more_button.dart';
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
      left: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletLink_header,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.walletLink_subheader,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Placeholder(),
          const Spacer(),
          VoicesLearnMoreButton(
            onTap: () {},
          ),
        ],
      ),
      right: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.walletLink_intro_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.walletLink_intro_content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
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
