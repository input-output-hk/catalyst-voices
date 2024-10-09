import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_connection_status.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_summary.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AccountDetailsPanel extends StatelessWidget {
  const AccountDetailsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(context.l10n.recoveryAccountTitle),
        const SizedBox(height: 24),
        const Expanded(
          child: SingleChildScrollView(
            child: _BlocAccountSummery(),
          ),
        ),
        const SizedBox(height: 24),
        VoicesFilledButton(
          onTap: () {},
          child: Text(context.l10n.recoveryAccountDetailsAction),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          onTap: () {},
          child: Text(context.l10n.back),
        ),
      ],
    );
  }
}

class _BlocAccountSummery extends StatelessWidget {
  const _BlocAccountSummery();

  @override
  Widget build(BuildContext context) {
    return _RecoveredAccountSummary(
      walletIcon: null,
      walletName: 'Testing',
      balance: const Coin(10),
      address: ShelleyAddress(const [0]),
    );
  }
}

class _RecoveredAccountSummary extends StatelessWidget {
  final String? walletIcon;
  final String walletName;
  final Coin balance;
  final ShelleyAddress address;

  const _RecoveredAccountSummary({
    this.walletIcon,
    required this.walletName,
    required this.balance,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const WalletConnectionStatus(
          icon: null,
          name: 'Testing',
        ),
        const SizedBox(height: 24),
        WalletSummary(
          balance: const Coin(10),
          address: ShelleyAddress([0]),
        ),
      ],
    );
  }
}
