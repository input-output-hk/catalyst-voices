import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/widget/wallet_list_tile.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/widget/wallets_empty_state.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/widget/wallets_error_state.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/stage/select_wallet/widget/wallets_loading.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_result_builder.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class WalletsListView extends StatelessWidget {
  final AsyncValueSetter<WalletMetadata> onSelectWallet;
  final VoidCallback onRefreshTap;

  const WalletsListView({
    super.key,
    required this.onSelectWallet,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkSelector<Result<List<WalletMetadata>, Exception>?>(
      key: const Key('WalletsLinkBuilder'),
      selector: (state) => state.wallets,
      builder: (context, state) {
        return _WalletsListViewBuilder(
          result: state,
          onRefreshTap: onRefreshTap,
          onSelectWallet: onSelectWallet,
        );
      },
    );
  }
}

class _WalletsListView extends StatelessWidget {
  final List<WalletMetadata> wallets;
  final AsyncValueSetter<WalletMetadata> onSelectWallet;

  const _WalletsListView({
    required this.wallets,
    required this.onSelectWallet,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[0];

        return WalletListTile(
          key: ValueKey('Wallet${wallet.name}ListTile'),
          wallet: wallet,
          onSelectWallet: onSelectWallet,
        );
      },
    );
  }
}

class _WalletsListViewBuilder extends StatelessWidget {
  final Result<List<WalletMetadata>, Exception>? result;
  final AsyncValueSetter<WalletMetadata> onSelectWallet;
  final VoidCallback onRefreshTap;

  const _WalletsListViewBuilder({
    this.result,
    required this.onSelectWallet,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: result,
      successBuilder: (context, wallets) => wallets.isNotEmpty
          ? _WalletsListView(wallets: wallets, onSelectWallet: onSelectWallet)
          : WalletsEmptyState(onRetry: onRefreshTap),
      failureBuilder: (context, error) => WalletsErrorState(onRetry: onRefreshTap),
      loadingBuilder: (context) => const WalletsLoading(),
    );
  }
}
