import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/menu/voices_wallet_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
        const SizedBox(height: 40),
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
        const SizedBox(width: 16),
        Text(wallet.name, style: Theme.of(context).textTheme.bodyLarge),
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
      child: Column(
        children: [
          Text(
            context.l10n.walletDetectionSummary,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
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
                  child: VoicesAssets.icons.clipboardCopy.buildIcon(),
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
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.bold),
            child: label,
          ),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!,
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
