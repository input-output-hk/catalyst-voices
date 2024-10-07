import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class RbacTransactionPanel extends StatelessWidget {
  const RbacTransactionPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkTransactionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const _BlocSummary(),
        const SizedBox(height: 18),
        const _PositiveSmallPrint(),
        const Spacer(),
        const _Navigation(),
      ],
    );
  }
}

class _BlocSummary extends StatelessWidget {
  const _BlocSummary();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<
        ({
          Set<AccountRole> roles,
          CardanoWalletDetails selectedWallet,
          Coin transactionFee,
        })?>(
      selector: (state) {
        final selectedWallet = state.selectedWallet;
        if (selectedWallet == null) {
          return null;
        }

        return (
          roles: state.selectedRoles ?? state.defaultRoles,
          selectedWallet: selectedWallet,
          transactionFee: state.transactionFee,
        );
      },
      builder: (context, state) {
        if (state == null) {
          return const Offstage();
        }

        return _Summary(
          roles: state.roles,
          walletDetails: state.selectedWallet,
          transactionFee: state.transactionFee,
        );
      },
    );
  }
}

class _Summary extends StatelessWidget {
  final Set<AccountRole> roles;
  final CardanoWalletDetails walletDetails;
  final Coin transactionFee;

  const _Summary({
    required this.roles,
    required this.walletDetails,
    required this.transactionFee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colors.outlineBorderVariant!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletLinkTransactionAccountCompletion,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n
                .walletLinkTransactionLinkItem(walletDetails.wallet.name),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          for (final role in roles) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.walletLinkTransactionRoleItem(
                role.getName(context).toLowerCase(),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.total,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                CryptocurrencyFormatter.formatAmount(transactionFee),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositiveSmallPrint extends StatelessWidget {
  const _PositiveSmallPrint();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.walletLinkTransactionPositiveSmallPrint,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: BulletList(
            items: [
              context.l10n.walletLinkTransactionPositiveSmallPrintItem1,
              context.l10n.walletLinkTransactionPositiveSmallPrintItem2,
              context.l10n.walletLinkTransactionPositiveSmallPrintItem3,
            ],
            spacing: 4,
          ),
        ),
      ],
    );
  }
}

class _Navigation extends StatefulWidget {
  const _Navigation();

  @override
  State<_Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<_Navigation> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: _isLoading ? null : _submitRegistration,
          trailing: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: VoicesCircularProgressIndicator(),
                )
              : null,
          child: Text(context.l10n.walletLinkTransactionSign),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).changeRoleSetup();
          },
          child: Text(context.l10n.walletLinkTransactionChangeRoles),
        ),
      ],
    );
  }

  Future<void> _submitRegistration() async {
    try {
      _updateLoading(true);

      await RegistrationCubit.of(context).submitRegistration();
    } finally {
      _updateLoading(false);
    }
  }

  void _updateLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }
}
