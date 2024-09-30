import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class SelectWalletPanel extends StatefulWidget {
  final Result<List<CardanoWallet>, Exception>? walletsResult;

  const SelectWalletPanel({
    super.key,
    this.walletsResult,
  });

  @override
  State<SelectWalletPanel> createState() => _SelectWalletPanelState();
}

class _SelectWalletPanelState extends State<SelectWalletPanel> {
  @override
  void initState() {
    super.initState();
    _refreshWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkSelectWalletTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkSelectWalletContent,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: _Wallets(
            result: widget.walletsResult,
            onRefreshTap: _refreshWallets,
            onSelectWallet: _onSelectWallet,
          ),
        ),
        const SizedBox(height: 24),
        VoicesBackButton(
          onTap: () {
            RegistrationCubit.of(context).previousStep();
          },
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: () {},
          child: Text(context.l10n.seeAllSupportedWallets),
        ),
      ],
    );
  }

  void _refreshWallets() {
    RegistrationCubit.of(context).refreshWallets();
  }

  void _onSelectWallet(CardanoWallet wallet) {
    RegistrationCubit.of(context).selectWallet(wallet);
  }
}

class _Wallets extends StatelessWidget {
  final Result<List<CardanoWallet>, Exception>? result;
  final ValueChanged<CardanoWallet> onSelectWallet;
  final VoidCallback onRefreshTap;

  const _Wallets({
    this.result,
    required this.onSelectWallet,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      Success(:final value) => value.isNotEmpty
          ? _WalletsList(wallets: value, onSelectWallet: onSelectWallet)
          : _WalletsEmpty(onRetry: onRefreshTap),
      Failure() => _WalletsError(onRetry: onRefreshTap),
      _ => const Center(child: VoicesCircularProgressIndicator()),
    };
  }
}

class _WalletsList extends StatelessWidget {
  final List<CardanoWallet> wallets;
  final ValueChanged<CardanoWallet> onSelectWallet;

  const _WalletsList({
    required this.wallets,
    required this.onSelectWallet,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return VoicesWalletTile(
          iconSrc: wallet.icon,
          name: Text(wallet.name),
          onTap: () => onSelectWallet(wallet),
        );
      },
    );
  }
}

class _WalletsEmpty extends StatelessWidget {
  final VoidCallback onRetry;

  const _WalletsEmpty({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: VoicesErrorIndicator(
          message: context.l10n.noWalletFound,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _WalletsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _WalletsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: VoicesErrorIndicator(
          message: context.l10n.somethingWentWrong,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
