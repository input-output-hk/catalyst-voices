import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/buttons/clipboard_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WalletSummary extends StatelessWidget {
  final String walletName;
  final String balance;
  final String address;
  final String clipboardAddress;
  final bool showLowBalance;
  final NetworkId? showExpectedNetworkId;

  const WalletSummary({
    super.key,
    required this.walletName,
    required this.balance,
    required this.address,
    required this.clipboardAddress,
    this.showLowBalance = false,
    this.showExpectedNetworkId,
  });

  @override
  Widget build(BuildContext context) {
    final showExpectedNetworkId = this.showExpectedNetworkId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colors.outlineBorderVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key: const Key('WalletDetectionSummary'),
            context.l10n.walletDetectionSummary,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          _WalletSummaryName(
            walletName: walletName,
          ),
          const SizedBox(height: 12),
          _WalletSummaryBalance(
            balance: balance,
            showLowBalance: showLowBalance,
          ),
          const SizedBox(height: 12),
          _WalletSummaryAddress(
            address: address,
            clipboardAddress: clipboardAddress,
          ),
          if (showExpectedNetworkId != null) ...[
            const SizedBox(height: 12),
            _NetworkIdMismatchError(networkId: showExpectedNetworkId),
          ],
          const SizedBox(height: 12),
          const _WalletBalanceNotice(),
        ],
      ),
    );
  }
}

class _NetworkIdMismatchError extends StatelessWidget {
  final NetworkId networkId;

  const _NetworkIdMismatchError({
    required this.networkId,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.registrationNetworkIdMismatch(
        networkId.localizedName(context),
      ),
      style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context).colors.iconsError,
          ),
    );
  }
}

class _WalletBalanceNotice extends StatelessWidget {
  const _WalletBalanceNotice();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          context.l10n.notice,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          context.l10n.walletLinkWalletDetailsNotice,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _WalletSummaryAddress extends StatelessWidget {
  final String address;
  final String clipboardAddress;

  const _WalletSummaryAddress({
    required this.address,
    required this.clipboardAddress,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(
        context.l10n.walletAddress,
        key: const Key('WalletAddressLabel'),
      ),
      value: Row(
        children: [
          Text(
            address,
            key: const Key('WalletAddressValue'),
          ),
          const SizedBox(width: 4),
          VoicesClipboardIconButton(clipboardData: clipboardAddress),
        ],
      ),
    );
  }
}

class _WalletSummaryBalance extends StatelessWidget {
  final String balance;
  final bool showLowBalance;

  const _WalletSummaryBalance({
    required this.balance,
    required this.showLowBalance,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(
        context.l10n.walletBalance,
        key: const Key('WalletBalanceLabel'),
      ),
      value: Row(
        children: [
          Text(
            key: const Key('WalletBalanceValue'),
            balance,
            style: showLowBalance ? TextStyle(color: Theme.of(context).colors.iconsError) : null,
          ),
          if (showLowBalance) ...[
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

class _WalletSummaryName extends StatelessWidget {
  final String walletName;

  const _WalletSummaryName({
    required this.walletName,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.nameOfWallet, key: const Key('NameOfWalletLabel')),
      value: Text(
        walletName.capitalize(),
        key: const Key('NameOfWalletValue'),
      ),
    );
  }
}
