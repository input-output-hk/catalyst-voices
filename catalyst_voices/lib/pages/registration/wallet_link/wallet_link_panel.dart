import 'package:catalyst_voices/pages/registration/wallet_link/intro/intro_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/rbac_transaction/rbac_transaction_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/roles_chooser/roles_chooser_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/roles_summary/roles_summary_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/select_wallet/select_wallet_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/wallet_details/wallet_details_panel.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WalletLinkPanel extends StatelessWidget {
  final WalletLinkStage stage;
  final WalletLinkStateData state;

  const WalletLinkPanel({
    super.key,
    required this.stage,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      WalletLinkStage.intro => const IntroPanel(),
      WalletLinkStage.selectWallet => SelectWalletPanel(
          walletsResult: state.wallets,
        ),
      WalletLinkStage.walletDetails => const WalletDetailsPanel(),
      WalletLinkStage.rolesChooser => const RolesChooserPanel(),
      WalletLinkStage.rolesSummary => const RolesSummaryPanel(),
      WalletLinkStage.rbacTransaction => const RbacTransactionPanel(),
    };
  }
}
