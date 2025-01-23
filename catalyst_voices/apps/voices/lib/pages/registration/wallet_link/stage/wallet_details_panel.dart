import 'package:catalyst_voices/pages/registration/widgets/wallet_connection_status.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_summary.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
    return BlocWalletLinkSelector<WalletConnectionData?>(
      selector: (state) => state.walletConnection,
      builder: (context, state) {
        return WalletConnectionStatus(
          icon: state?.icon,
          name: state?.name ?? '',
          isConnected: state?.isConnected ?? false,
        );
      },
    );
  }
}

class _BlocWalletDetailsText extends StatelessWidget {
  const _BlocWalletDetailsText();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<String?>(
      selector: (state) => state.selectedWallet?.metadata.name,
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
    return BlocWalletLinkSelector<WalletSummaryData?>(
      selector: (state) => state.walletSummary,
      builder: (context, state) {
        if (state != null) {
          return WalletSummary(
            walletName: state.walletName,
            balance: state.balance,
            address: state.address,
            clipboardAddress: state.clipboardAddress,
            showLowBalance: state.showLowBalance,
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
    return BlocWalletLinkSelector<bool>(
      selector: (state) => state.hasEnoughBalance,
      builder: (context, state) {
        if (state) {
          return const _RegistrationTextBackNextNavigation();
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

class _RegistrationTextBackNextNavigation extends StatelessWidget {
  const _RegistrationTextBackNextNavigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesFilledButton(
          onTap: () => RegistrationCubit.of(context).nextStep(),
          leading: VoicesAssets.icons.users.buildIcon(),
          child: Text(context.l10n.walletLinkRolesSubheader),
        ),
        const SizedBox(height: 10),
        VoicesOutlinedButton(
          onTap: () => RegistrationCubit.of(context).previousStep(),
          child: Text(
            context.l10n.connectDifferentWallet,
          ),
        ),
      ],
    );
  }
}
