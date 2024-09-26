import 'package:catalyst_voices/pages/account/creation/task_picture.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// The initial screen for the link wallet flow during registration.
class LinkWalletIntroDialog extends StatelessWidget {
  final VoidCallback onSelectWallet;

  const LinkWalletIntroDialog({
    super.key,
    required this.onSelectWallet,
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
          VoicesFilledButton(
            leading: VoicesAssets.icons.wallet.buildIcon(),
            onTap: onSelectWallet,
            child: Text(context.l10n.chooseCardanoWallet),
          ),
        ],
      ),
    );
  }
}
