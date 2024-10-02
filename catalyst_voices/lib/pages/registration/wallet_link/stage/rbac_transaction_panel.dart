import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class RbacTransactionPanel extends StatelessWidget {
  final Set<AccountRole> roles;
  final CardanoWalletDetails walletDetails;
  final Coin transactionFee;

  const RbacTransactionPanel({
    super.key,
    required this.roles,
    required this.walletDetails,
    required this.transactionFee,
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
        _Summary(
          roles: roles,
          walletDetails: walletDetails,
          transactionFee: transactionFee,
        ),
        const SizedBox(height: 18),
        const _PositiveSmallPrint(),
        const Spacer(),
        const _Navigation(),
      ],
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

class _Navigation extends StatelessWidget {
  const _Navigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: () {
            RegistrationCubit.of(context).submitRegistration();
          },
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
}
