import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletDetailsPanel extends StatelessWidget {
  final Coin minAdaForRegistration;
  final CardanoWalletDetails walletDetails;

  const WalletDetailsPanel({
    super.key,
    required this.minAdaForRegistration,
    required this.walletDetails,
  });

  @override
  Widget build(BuildContext context) {
    final hasEnoughBalance = walletDetails.balance >= minAdaForRegistration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkWalletDetailsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        _WalletExtension(wallet: walletDetails.wallet),
        const SizedBox(height: 16),
        Text(
          context.l10n
              .walletLinkWalletDetailsContent(walletDetails.wallet.name),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        _WalletSummary(
          details: walletDetails,
          hasEnoughBalance: hasEnoughBalance,
        ),
        const Spacer(),
        if (hasEnoughBalance)
          const RegistrationBackNextNavigation()
        else
          const _NotEnoughBalanceNavigation(),
      ],
    );
  }
}

class _WalletExtension extends StatelessWidget {
  final CardanoWallet wallet;

  const _WalletExtension({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        VoicesWalletTileIcon(iconSrc: wallet.icon),
        const SizedBox(width: 12),
        Text(wallet.name, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 8),
        VoicesAvatar(
          radius: 10,
          padding: const EdgeInsets.all(4),
          icon: VoicesAssets.icons.check.buildIcon(),
          foregroundColor: Theme.of(context).colors.success,
          backgroundColor: Theme.of(context).colors.successContainer,
        ),
      ],
    );
  }
}

class _WalletSummary extends StatelessWidget {
  final CardanoWalletDetails details;
  final bool hasEnoughBalance;

  const _WalletSummary({
    required this.details,
    required this.hasEnoughBalance,
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
            context.l10n.walletDetectionSummary,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          _WalletSummaryBalance(
            details: details,
            hasEnoughBalance: hasEnoughBalance,
          ),
          const SizedBox(height: 12),
          _WalletSummaryAddress(details: details),
          if (!hasEnoughBalance) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.notice,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.walletLinkWalletDetailsNotice,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.walletLinkWalletDetailsNoticeTopUp,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            BulletList(
              items: [
                context.l10n.walletLinkWalletDetailsNoticeTopUpLink,
              ],
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _WalletSummaryBalance extends StatelessWidget {
  final CardanoWalletDetails details;
  final bool hasEnoughBalance;

  const _WalletSummaryBalance({
    required this.details,
    required this.hasEnoughBalance,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.walletBalance),
      value: Row(
        children: [
          Text(
            CryptocurrencyFormatter.formatAmount(details.balance),
            style: hasEnoughBalance
                ? null
                : TextStyle(color: Theme.of(context).colors.iconsError),
          ),
          if (!hasEnoughBalance) ...[
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: VoicesAssets.icons.exclamation.buildIcon(
                color: Theme.of(context).colors.iconsError,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WalletSummaryAddress extends StatelessWidget {
  final CardanoWalletDetails details;

  const _WalletSummaryAddress({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.walletAddress),
      value: Row(
        children: [
          Text(WalletAddressFormatter.formatShort(details.address)),
          const SizedBox(width: 4),
          InkWell(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: details.address.toBech32()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: VoicesAssets.icons.clipboardCopy.buildIcon(size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletSummaryItem extends StatelessWidget {
  final Widget label;
  final Widget value;

  const _WalletSummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            child: label,
          ),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelMedium!,
            child: value,
          ),
        ),
      ],
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
