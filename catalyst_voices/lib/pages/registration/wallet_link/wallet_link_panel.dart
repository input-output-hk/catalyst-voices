import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/intro_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/rbac_transaction_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/roles_chooser_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/roles_summary_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet_panel.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/wallet_details_panel.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WalletLinkPanel extends StatelessWidget {
  final WalletLinkStage stage;
  final WalletLinkStateData stateData;

  const WalletLinkPanel({
    super.key,
    required this.stage,
    required this.stateData,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      WalletLinkStage.intro => const IntroPanel(),
      WalletLinkStage.selectWallet => SelectWalletPanel(
          walletsResult: stateData.wallets,
        ),
      WalletLinkStage.walletDetails => WalletDetailsPanel(
          minAdaForRegistration: stateData.minAdaForRegistration,
          walletDetails: stateData.selectedWallet!,
        ),
      WalletLinkStage.rolesChooser => RolesChooserPanel(
          defaultRoles: stateData.defaultRoles,
          selectedRoles: stateData.selectedRoles ?? stateData.defaultRoles,
        ),
      WalletLinkStage.rolesSummary => RolesSummaryPanel(
          defaultRoles: stateData.defaultRoles,
          selectedRoles: stateData.selectedRoles ?? stateData.defaultRoles,
        ),
      WalletLinkStage.rbacTransaction => RbacTransactionPanel(
          roles: stateData.selectedRoles ?? stateData.defaultRoles,
          walletDetails: stateData.selectedWallet!,
          // TODO(dtscalac): pass valid fee
          transactionFee: Coin.fromAda(0.9438),
        ),
    };
  }
}
