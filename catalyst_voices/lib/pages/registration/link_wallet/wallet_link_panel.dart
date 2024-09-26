import 'package:catalyst_voices/pages/registration/link_wallet/intro/intro_panel.dart';
import 'package:catalyst_voices/pages/registration/link_wallet/select_wallet/select_wallet_panel.dart';
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
    };
  }
}
