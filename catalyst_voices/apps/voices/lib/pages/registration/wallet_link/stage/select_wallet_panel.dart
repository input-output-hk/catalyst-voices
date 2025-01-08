import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_result_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';
import 'package:url_launcher/url_launcher.dart';

/// Callback called when a [wallet] is selected.
typedef _OnSelectWallet = Future<void> Function(WalletMetadata wallet);

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
          key: const Key('BackButton'),
          onTap: () {
            RegistrationCubit.of(context).previousStep();
          },
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: () async => _launchSupportedWalletsLink(),
          child: Text(context.l10n.seeAllSupportedWallets),
        ),
      ],
    );
  }

  void _refreshWallets() {
    unawaited(RegistrationCubit.of(context).walletLink.refreshWallets());
  }

  Future<void> _onSelectWallet(WalletMetadata wallet) async {
    final registration = RegistrationCubit.of(context);

    final success = await registration.walletLink.selectWallet(wallet);
    if (success) {
      registration.nextStep();
    }
  }

  Future<void> _launchSupportedWalletsLink() async {
    final url = VoicesConstants.supportedWalletsUrl.getUri();
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
    return BlocWalletLinkBuilder<Result<List<WalletMetadata>, Exception>?>(
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
  final Result<List<WalletMetadata>, Exception>? result;
  final _OnSelectWallet onSelectWallet;
  final VoidCallback onRefreshTap;

  const _Wallets({
    this.result,
    required this.onSelectWallet,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: result,
      successBuilder: (context, wallets) => wallets.isNotEmpty
          ? _WalletsList(wallets: wallets, onSelectWallet: onSelectWallet)
          : _WalletsEmpty(onRetry: onRefreshTap),
      failureBuilder: (context, error) => _WalletsError(onRetry: onRefreshTap),
      loadingBuilder: (context) => const _WalletsLoading(),
    );
  }
}

class _WalletsList extends StatelessWidget {
  final List<WalletMetadata> wallets;
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
  final WalletMetadata wallet;
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

class _WalletsLoading extends StatelessWidget {
  const _WalletsLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: VoicesCircularProgressIndicator(),
    );
  }
}
