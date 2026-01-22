import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/widget/wallets_list_view.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectWalletPanel extends StatefulWidget {
  final bool isDrepLink;

  const SelectWalletPanel({
    super.key,
    this.isDrepLink = false,
  });

  @override
  State<SelectWalletPanel> createState() => _SelectWalletPanelState();
}

class _SelectWalletPanelState extends State<SelectWalletPanel> {
  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      title: RegistrationStageMessage(
        title: Text(context.l10n.walletLinkSelectWalletTitle),
        subtitle: Text(context.l10n.walletLinkSelectWalletContent),
      ),
      body: WalletsListView(
        onRefreshTap: _refreshWallets,
        onSelectWallet: _onSelectWallet,
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VoicesBackButton(
            key: const Key('BackButton'),
            onTap: () {
              RegistrationCubit.of(context).previousStep();
            },
          ),
          const SizedBox(height: 10),
          VoicesTextButton(
            key: const Key('SeeAllSupportedWalletsButton'),
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
            onTap: () async => _launchSupportedWalletsLink(),
            child: Text(context.l10n.seeAllSupportedWallets),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshWallets();
  }

  Future<void> _launchSupportedWalletsLink() async {
    final url = VoicesConstants.officiallySupportedWalletsUrl.getUri();
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _onSelectWallet(WalletMetadata wallet) async {
    final registration = RegistrationCubit.of(context);

    final success = await registration.walletLink.selectWallet(wallet);
    if (!success) return;

    final isValidWallet = registration.validateSelectedWallet();
    if (!isValidWallet) return;

    if (widget.isDrepLink) {
      registration.prepareDrepLinkAccountSummary();
    }

    registration.nextStep();
  }

  void _refreshWallets() {
    unawaited(RegistrationCubit.of(context).walletLink.refreshWallets());
  }
}
