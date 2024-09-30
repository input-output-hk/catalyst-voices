import 'package:catalyst_cardano/catalyst_cardano.dart';
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
  final CardanoWalletDetails details;

  const WalletDetailsPanel({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkWalletDetailsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 32),
        _WalletExtension(wallet: details.wallet),
        const SizedBox(height: 16),
        Text(
          context.l10n.walletLinkWalletDetailsContent(details.wallet.name),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        _WalletSummary(details: details),
        const Spacer(),
        const _Navigation(),
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

  const _WalletSummary({required this.details});

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
          const SizedBox(height: 16),
          _WalletSummaryItem(
            label: Text(context.l10n.walletBalance),
            value: Text(CryptocurrencyFormatter.formatAmount(details.balance)),
          ),
          const SizedBox(height: 12),
          _WalletSummaryItem(
            label: Text(context.l10n.walletAddress),
            value: Row(
              children: [
                Text(WalletAddressFormatter.formatShort(details.address)),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: details.address.toBech32()),
                    );
                  },
                  child: VoicesAssets.icons.clipboardCopy.buildIcon(size: 16),
                ),
              ],
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
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
            child: label,
          ),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 1,
                ),
            child: value,
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
    return Row(
      children: [
        Expanded(
          child: VoicesBackButton(
            onTap: () => RegistrationCubit.of(context).previousStep(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VoicesNextButton(
            onTap: () => RegistrationCubit.of(context).nextStep(),
          ),
        ),
      ],
    );
  }
}
