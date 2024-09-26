import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SelectWalletPanel extends StatelessWidget {
  const SelectWalletPanel({super.key});

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
        const Expanded(child: _Wallets()),
        const SizedBox(height: 24),
        VoicesBackButton(
          onTap: () {
            RegistrationBloc.of(context).add(const PreviousStepEvent());
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
}

class _Wallets extends StatefulWidget {
  const _Wallets();

  @override
  State<_Wallets> createState() => _WalletsState();
}

class _WalletsState extends State<_Wallets> {
  @override
  void initState() {
    super.initState();

    final bloc = RegistrationBloc.of(context);
    if (bloc.cardanoWallets.value is UninitializedCardanoWallets) {
      unawaited(bloc.refreshCardanoWallets());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: RegistrationBloc.of(context).cardanoWallets,
      builder: (context, state, _) {
        return switch (state) {
          UninitializedCardanoWallets() =>
            const Center(child: VoicesCircularProgressIndicator()),
          CardanoWalletsList(:final wallets) => wallets.isNotEmpty
              ? _WalletsList(wallets: wallets)
              : _WalletsEmpty(onRetry: _onRetry),
          CardanoWalletsError() => _WalletsError(onRetry: _onRetry),
        };
      },
    );
  }

  void _onRetry() {
    unawaited(RegistrationBloc.of(context).refreshCardanoWallets());
  }
}

class _WalletsList extends StatelessWidget {
  final List<CardanoWallet> wallets;

  const _WalletsList({required this.wallets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return VoicesWalletTile(
          iconSrc: wallet.icon,
          name: Text(wallet.name),
          onTap: () {
            RegistrationBloc.of(context).add(const NextStepEvent());
          },
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
