import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_connection_status.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_summary.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WalletDetailsPanel extends StatelessWidget {
  const WalletDetailsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkWalletDetailsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        const _BlocWalletConnectionStatus(),
        const SizedBox(height: 16),
        const _BlocWalletDetailsText(),
        const SizedBox(height: 24),
        const _BlocWalletSummary(),
        const Spacer(),
        const _BlocNavigation(),
      ],
    );
  }
}

class _BlocWalletConnectionStatus extends StatelessWidget {
  const _BlocWalletConnectionStatus();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<({String icon, String name})?>(
      selector: (state) {
        final wallet = state.selectedWallet?.wallet;
        return wallet != null ? (icon: wallet.icon, name: wallet.name) : null;
      },
      builder: (context, state) {
        if (state != null) {
          return WalletConnectionStatus(
            icon: state.icon,
            name: state.name,
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}

class _BlocWalletDetailsText extends StatelessWidget {
  const _BlocWalletDetailsText();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<String?>(
      selector: (state) => state.selectedWallet?.wallet.name,
      builder: (context, state) {
        return Text(
          context.l10n.walletLinkWalletDetailsContent(state ?? ''),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}

class _BlocWalletSummary extends StatelessWidget {
  const _BlocWalletSummary();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<
        ({
          Coin balance,
          ShelleyAddress address,
          bool hasEnoughBalance,
        })?>(
      selector: (state) {
        final walletDetails = state.selectedWallet;
        return walletDetails != null
            ? (
                balance: walletDetails.balance,
                address: walletDetails.address,
                hasEnoughBalance: walletDetails.hasEnoughBalance,
              )
            : null;
      },
      builder: (context, state) {
        if (state != null) {
          return WalletSummary(
            balance: state.balance,
            address: state.address,
            showLowBalance: !state.hasEnoughBalance,
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<bool>(
      selector: (state) => state.selectedWallet?.hasEnoughBalance ?? false,
      builder: (context, state) {
        if (state) {
          return const RegistrationBackNextNavigation();
        } else {
          return const _NotEnoughBalanceNavigation();
        }
      },
    );
  }
}

class _NotEnoughBalanceNavigation extends StatelessWidget {
  const _NotEnoughBalanceNavigation();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      leading: VoicesAssets.icons.wallet.buildIcon(),
      onTap: () => RegistrationCubit.of(context).previousStep(),
      child: Text(context.l10n.chooseOtherWallet),
    );
  }
}
