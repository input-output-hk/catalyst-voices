import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/registration/wallet_link/bloc_wallet_link_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletDetailsPanel extends StatelessWidget {
  const WalletDetailsPanel({
    super.key,
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
        const _BlocWalletExtension(),
        const SizedBox(height: 16),
        const _BlocWalletDetailsText(),
        const SizedBox(height: 24),
        const _BlocWalletSummary(),
        const Spacer(),
        const _BlocNavigation(),
      ],
    );
  }
}

class _BlocWalletExtension extends StatelessWidget {
  const _BlocWalletExtension();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<({String icon, String name})?>(
      selector: (state) {
        final wallet = state.selectedWallet?.wallet;
        return wallet != null ? (icon: wallet.icon, name: wallet.name) : null;
      },
      builder: (context, state) {
        if (state != null) {
          return _WalletExtension(
            icon: state.icon,
            name: state.name,
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}

class _WalletExtension extends StatelessWidget {
  final String icon;
  final String name;

  const _WalletExtension({
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        VoicesWalletTileIcon(iconSrc: icon),
        const SizedBox(width: 12),
        Text(name, style: Theme.of(context).textTheme.bodyLarge),
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

class _BlocWalletDetailsText extends StatelessWidget {
  const _BlocWalletDetailsText();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<String?>(
      selector: (state) => state.selectedWallet?.wallet.name,
      builder: (context, state) {
        return Text(
          context.l10n.walletLinkWalletDetailsContent(state ?? ''),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}

class _BlocWalletSummary extends StatelessWidget {
  const _BlocWalletSummary();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<
        ({
          Coin balance,
          ShelleyAddress address,
          bool hasEnoughBalance,
        })?>(
      selector: (state) {
        final walletDetails = state.selectedWallet;
        return walletDetails != null
            ? (
                balance: walletDetails.balance,
                address: walletDetails.address,
                hasEnoughBalance: walletDetails.hasEnoughBalance,
              )
            : null;
      },
      builder: (context, state) {
        if (state != null) {
          return _WalletSummary(
            balance: state.balance,
            address: state.address,
            hasEnoughBalance: state.hasEnoughBalance,
          );
        } else {
          return const Offstage();
        }
      },
    );
  }
}

class _WalletSummary extends StatelessWidget {
  final Coin balance;
  final ShelleyAddress address;
  final bool hasEnoughBalance;

  const _WalletSummary({
    required this.balance,
    required this.address,
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
            balance: balance,
            hasEnoughBalance: hasEnoughBalance,
          ),
          const SizedBox(height: 12),
          _WalletSummaryAddress(address: address),
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
  final Coin balance;
  final bool hasEnoughBalance;

  const _WalletSummaryBalance({
    required this.balance,
    required this.hasEnoughBalance,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.walletBalance),
      value: Row(
        children: [
          Text(
            CryptocurrencyFormatter.formatAmount(balance),
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
  final ShelleyAddress address;

  const _WalletSummaryAddress({
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return _WalletSummaryItem(
      label: Text(context.l10n.walletAddress),
      value: Row(
        children: [
          Text(WalletAddressFormatter.formatShort(address)),
          const SizedBox(width: 4),
          InkWell(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: address.toBech32()),
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

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocWalletLinkBuilder<bool>(
      selector: (state) => state.selectedWallet?.hasEnoughBalance ?? false,
      builder: (context, state) {
        if (state) {
          return const RegistrationBackNextNavigation();
        } else {
          return const _NotEnoughBalanceNavigation();
        }
      },
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
