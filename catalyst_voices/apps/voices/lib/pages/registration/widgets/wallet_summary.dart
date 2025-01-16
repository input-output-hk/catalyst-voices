import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletSummary extends StatelessWidget {
  final String balance;
  final String address;
  final String clipboardAddress;
  final bool showLowBalance;

  const WalletSummary({
    super.key,
    required this.balance,
    required this.address,
    required this.clipboardAddress,
    this.showLowBalance = false,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletDetectionSummary,
            style: Theme.of(context).textTheme.titleSmall,
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
          if (showLowBalance) ...[
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
  final String balance;
  final bool showLowBalance;

  const _WalletSummaryBalance({
    required this.balance,
    required this.showLowBalance,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.walletBalance),
      value: Row(
        children: [
          Text(
            balance,
            style: showLowBalance
                ? TextStyle(color: Theme.of(context).colors.iconsError)
                : null,
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
      label: Text(context.l10n.walletAddress),
      value: Row(
        children: [
          Text(address),
          const SizedBox(width: 4),
          InkWell(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: clipboardAddress),
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
