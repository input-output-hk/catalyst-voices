import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

// TODO(dtscalac): add content for the screen
class SelectWalletDialog extends StatelessWidget {
  final ValueChanged<CardanoWallet> onSelectedWallet;

  const SelectWalletDialog({
    super.key,
    required this.onSelectedWallet,
  });

  @override
  Widget build(BuildContext context) {
    return const VoicesDesktopPanelsDialog(
      left: Column(
        children: [],
      ),
      right: Column(
        children: [],
      ),
    );
  }
}
