import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
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
import 'package:result_type/result_type.dart';

class RbacTransactionPanel extends StatefulWidget {
  const RbacTransactionPanel({super.key});

  @override
  State<RbacTransactionPanel> createState() => _RbacTransactionPanelState();
}

class _RbacTransactionPanelState extends State<RbacTransactionPanel> {
  @override
  void initState() {
    super.initState();
    unawaited(RegistrationCubit.of(context).prepareRegistration());
  }

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
        Expanded(
          child: _BlocTransactionDetails(onRefreshTap: _onRefresh),
        ),
        const _Navigation(),
      ],
    );
  }

  void _onRefresh() {
    unawaited(RegistrationCubit.of(context).prepareRegistration());
  }
}

class _BlocTransactionDetails extends StatelessWidget {
  final VoidCallback onRefreshTap;

  const _BlocTransactionDetails({required this.onRefreshTap});

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder(
      selector: (state) => state.unsignedTx,
      builder: (context, result) {
        return switch (result) {
          Success() => const _TransactionDetails(),
          Failure(:final value) => _Error(error: value, onRetry: onRefreshTap),
          _ => const Center(child: VoicesCircularProgressIndicator()),
        };
      },
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  const _TransactionDetails();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlocSummary(),
        SizedBox(height: 18),
        _PositiveSmallPrint(),
        _BlocTxSubmitError(),
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
        final fee = state.transactionFee;

        if (selectedWallet == null || fee == null) {
          return null;
        }

        return (
          roles: state.selectedRoles ?? state.defaultRoles,
          selectedWallet: selectedWallet,
          transactionFee: fee,
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
                CryptocurrencyFormatter.formatExactAmount(transactionFee),
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

class _BlocTxSubmitError extends StatelessWidget {
  const _BlocTxSubmitError();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder(
      selector: (state) => state.submittedTx,
      builder: (context, result) {
        return switch (result) {
          Failure(:final value) => _Error(
              error: value,
              onRetry: () => _onRetry(context),
            ),
          _ => const Offstage(),
        };
      },
    );
  }

  void _onRetry(BuildContext context) {
    unawaited(RegistrationCubit.of(context).walletLink.submitRegistration());
  }
}

class _Error extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _Error({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: VoicesErrorIndicator(
          message: error is WalletApiException
              ? context.l10n.walletLinkTransactionFailed
              : context.l10n.somethingWentWrong,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlocSubmitTxButton(
          onSubmit: () => unawaited(_submitRegistration(context)),
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

  Future<void> _submitRegistration(BuildContext context) async {
    final cubit = RegistrationCubit.of(context);
    await cubit.walletLink.submitRegistration();
    cubit.nextStep();
  }
}

class _BlocSubmitTxButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const _BlocSubmitTxButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<
        ({
          bool isLoading,
          bool canSubmitTx,
        })>(
      selector: (state) => (
        isLoading: state.isSubmittingTx,
        canSubmitTx:
            (state.unsignedTx?.isSuccess ?? false) && (!state.isSubmittingTx),
      ),
      builder: (context, state) {
        return VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: state.canSubmitTx ? onSubmit : null,
          trailing: state.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: VoicesCircularProgressIndicator(),
                )
              : null,
          child: Text(context.l10n.walletLinkTransactionSign),
        );
      },
    );
  }
}
