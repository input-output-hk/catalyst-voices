import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_connection_status.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_summary.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WalletDetailsPanel extends StatelessWidget {
  const WalletDetailsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      title: Text(
        context.l10n.walletLinkWalletDetailsTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          _BlocWalletConnectionStatus(),
          SizedBox(height: 16),
          _BlocWalletDetailsText(),
          SizedBox(height: 24),
          _BlocWalletSummary(),
        ],
      ),
      footer: const _Footer(),
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<bool>(
      selector: (state) => state.hasEnoughBalance && state.isNetworkIdMatching,
      builder: (context, canContinue) {
        if (canContinue) {
          return const RegistrationBackNextNavigation();
        } else {
          return const _ChooseOtherWalletNavigation();
        }
      },
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
          name: (state?.name ?? '').capitalize(),
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
          context.l10n.walletLinkWalletDetailsContent((state ?? '').capitalize()),
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
            showExpectedNetworkId: state.showExpectedNetworkId,
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}

class _ChooseOtherWalletNavigation extends StatelessWidget {
  const _ChooseOtherWalletNavigation();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      leading: VoicesAssets.icons.wallet.buildIcon(),
      onTap: () => RegistrationCubit.of(context).previousStep(),
      child: Text(context.l10n.chooseOtherWallet),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<bool>(
      selector: (state) => state.walletSummary?.showLowBalance ?? false,
      builder: (context, showLowBalance) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            if (showLowBalance) const _WalletBalanceHeadsUp(),
            const Center(child: _BlocNavigation()),
          ],
        );
      },
    );
  }
}

class _WalletBalanceHeadsUp extends StatelessWidget {
  const _WalletBalanceHeadsUp();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          context.l10n.headsUp,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ActionCard(
          key: const Key('WalletBalanceHeadsUp'),
          icon: VoicesAssets.icons.wallet.buildIcon(),
          title: Text(
            context.l10n.walletBalance,
            key: const Key('WalletBalanceHeadsUpTitle'),
          ),
          desc: Text(
            key: const Key('WalletBalanceHeadsUpList'),
            context.l10n.walletLinkWalletDetailsLowBalanceHeadsUpText(
              CardanoWalletDetails.minAdaForRegistration.ada,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colors.textOnPrimaryLevel1,
                ),
          ),
        ),
      ],
    );
  }
}
