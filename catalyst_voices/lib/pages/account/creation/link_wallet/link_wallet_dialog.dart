import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/pages/account/creation/link_wallet/intro/link_wallet_intro_dialog.dart';
import 'package:catalyst_voices/pages/account/creation/link_wallet/link_wallet_stage.dart';
import 'package:catalyst_voices/pages/account/creation/link_wallet/select_wallet/select_wallet_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:flutter/material.dart';

/// The link wallet flow consisting
/// of [LinkWalletStage]'s during the registration.
class LinkWalletDialog extends StatefulWidget {
  const LinkWalletDialog._();

  /// Shows the [LinkWalletDialog] flow.
  static Future<void> show({required BuildContext context}) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/register/link-wallet'),
      builder: (context) => const LinkWalletDialog._(),
    );
  }

  @override
  State<LinkWalletDialog> createState() => _LinkWalletDialogState();
}

class _LinkWalletDialogState extends State<LinkWalletDialog> {
  LinkWalletStage _stage = LinkWalletStage.intro;

  @override
  Widget build(BuildContext context) {
    return switch (_stage) {
      LinkWalletStage.intro => LinkWalletIntroDialog(
          onSelectWallet: _onSelectWallet,
        ),
      LinkWalletStage.selectWallet => SelectWalletDialog(
          onSelectedWallet: _onSelectedWallet,
        ),
    };
  }

  void _onSelectWallet() {
    setState(() {
      _stage = LinkWalletStage.selectWallet;
    });
  }

  void _onSelectedWallet(CardanoWallet wallet) {
    // TODO(dtscalac): store selected wallet and proceed to next stage
  }
}
