import 'package:catalyst_voices/pages/registration/link_wallet/intro/intro_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/rbac_transaction/rbac_transaction_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/roles_chooser/roles_chooser_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/roles_summary/roles_summary_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/select_wallet/select_wallet_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/wallet_details/wallet_details_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WalletLinkPanel extends StatelessWidget {
  final WalletLinkStage stage;

  const WalletLinkPanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      WalletLinkStage.intro => const IntroPanel(),
      WalletLinkStage.selectWallet => const SelectWalletPanel(),
      WalletLinkStage.walletDetails => const WalletDetailsPanel(),
      WalletLinkStage.rolesChooser => const RolesChooserPanel(),
      WalletLinkStage.rolesSummary => const RolesSummaryPanel(),
      WalletLinkStage.rbacTransaction => const RbacTransactionPanel(),
    };
  }
}
