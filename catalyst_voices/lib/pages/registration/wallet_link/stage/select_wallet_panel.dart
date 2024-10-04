import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

/// Callback called when a [wallet] is selected.
typedef _OnSelectWallet = Future<void> Function(CardanoWallet wallet);

class SelectWalletPanel extends StatefulWidget {
  const SelectWalletPanel({
    super.key,
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
        RegistrationStageMessage(
          title: Text(context.l10n.walletLinkSelectWalletTitle),
          subtitle: Text(context.l10n.walletLinkSelectWalletContent),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: _BlocWallets(
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
    unawaited(RegistrationCubit.of(context).walletLink.refreshWallets());
  }

  Future<void> _onSelectWallet(CardanoWallet wallet) async {
    final registration = RegistrationCubit.of(context);

    final success = await registration.walletLink.selectWallet(wallet);
    if (success) {
      registration.nextStep();
    }
  }
}

class _BlocWallets extends StatelessWidget {
  final _OnSelectWallet onSelectWallet;
  final VoidCallback onRefreshTap;

  const _BlocWallets({
    required this.onSelectWallet,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<Result<List<CardanoWallet>, Exception>?>(
      selector: (state) => state.wallets,
      builder: (context, state) {
        return _Wallets(
          result: state,
          onRefreshTap: onRefreshTap,
          onSelectWallet: onSelectWallet,
        );
      },
    );
  }
}

class _Wallets extends StatelessWidget {
  final Result<List<CardanoWallet>, Exception>? result;
  final _OnSelectWallet onSelectWallet;
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
  final _OnSelectWallet onSelectWallet;

  const _WalletsList({
    required this.wallets,
    required this.onSelectWallet,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        return _WalletTile(
          wallet: wallets[index],
          onSelectWallet: onSelectWallet,
        );
      },
    );
  }
}

class _WalletTile extends StatefulWidget {
  final CardanoWallet wallet;
  final _OnSelectWallet onSelectWallet;

  const _WalletTile({
    required this.wallet,
    required this.onSelectWallet,
  });

  @override
  State<_WalletTile> createState() => _WalletTileState();
}

class _WalletTileState extends State<_WalletTile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return VoicesWalletTile(
      iconSrc: widget.wallet.icon,
      name: Text(widget.wallet.name),
      isLoading: _isLoading,
      onTap: _onSelectWallet,
    );
  }

  Future<void> _onSelectWallet() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await widget.onSelectWallet(widget.wallet).withMinimumDelay();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
