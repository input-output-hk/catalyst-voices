import 'package:catalyst_voices/pages/registration/wallet_link/stage/rbac_transaction_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/roles_confirmation_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/select_wallet_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/wallet_drep_link_account_details_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WalletDrepLinkPanel extends StatelessWidget {
  final WalletDrepLinkStage stage;

  const WalletDrepLinkPanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      WalletDrepLinkStage.rolesConfirmation => const RolesConfirmationPanel(),
      WalletDrepLinkStage.selectWallet => const SelectWalletPanel(isDrepLink: true),
      WalletDrepLinkStage.walletAccountDetails => const WalletDrepLinkAccountDetailsPanel(),
      WalletDrepLinkStage.rbacTransaction => const RbacTransactionPanel(isDrepLink: true),
    };
  }
}
