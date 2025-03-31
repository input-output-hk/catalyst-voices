import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/tip_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoWalletFoundDialog extends StatelessWidget {
  const NoWalletFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoicesTwoPaneDialog(
      left: _LeftSide(),
      right: _RightSide(),
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool?>(
      context: context,
      routeSettings: const RouteSettings(name: '/no-wallet-found'),
      builder: (context) => const NoWalletFoundDialog(),
    );
    return result ?? false;
  }
}

class SupportedWallet extends StatelessWidget with LaunchUrlMixin {
  final AssetGenImage image;
  final String name;
  final String url;

  const SupportedWallet({
    super.key,
    required this.image,
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CatalystImage.asset(image.path),
          const SizedBox(width: 16),
          Text(name),
          const Spacer(),
          VoicesIconButton(
            onTap: _launchUrl,
            child: VoicesAssets.icons.externalLink.buildIcon(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    await launchUri(url.getUri());
  }
}

class _LeftSide extends StatelessWidget {
  const _LeftSide();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.cantFindYourWallet,
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.potentialReasons,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 12),
        _NoWalletErrorReason(
          icon: VoicesAssets.icons.exclamation,
          title: context.l10n.wrongBrowserTitle,
          description: context.l10n.wrongBrowserDescription,
        ),
        _NoWalletErrorReason(
          icon: VoicesAssets.icons.wallet,
          title: context.l10n.disableExtensionTitle,
          description: context.l10n.disableExtensionDescription,
        ),
        _NoWalletErrorReason(
          icon: VoicesAssets.icons.x,
          title: context.l10n.failedAuthenticationTitle,
          description: context.l10n.failedAuthenticationDescription,
        ),
        _NoWalletErrorReason(
          icon: VoicesAssets.icons.wallet,
          title: context.l10n.noWalletInstalledTitle,
          description: context.l10n.noWalletInstalledDescription,
        ),
        VoicesTextButton(
          onTap: () {
            // TODO(LynxLynxx): implement url launching
          },
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          child: Text(context.l10n.visitCatalystWalletDocumentationTextButton),
        ),
      ],
    );
  }
}

class _NoWalletAction extends StatefulWidget {
  const _NoWalletAction();

  @override
  State<_NoWalletAction> createState() => _NoWalletActionState();
}

class _NoWalletActionState extends State<_NoWalletAction> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: VoicesCircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: VoicesErrorIndicator(
              message: context.l10n.somethingWentWrong,
              onRetry: () async => _checkAvailableWallets(context),
            ),
          );
  }

  void _changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> _checkAvailableWallets(BuildContext context) async {
    _changeIsLoading();
    final hasWallets =
        await context.read<SessionCubit>().checkAvailableWallets();
    if (hasWallets && context.mounted) {
      Navigator.of(context).pop(true);
    } else {
      _changeIsLoading();
    }
  }
}

class _NoWalletErrorReason extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String description;

  const _NoWalletErrorReason({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: context.colorScheme.primary,
            ),
            child: icon.buildIcon(
              color: context.colors.iconsBackground,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 262,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: context.colors.textOnPrimaryLevel1),
                ),
                Text(
                  description,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: context.colors.textOnPrimaryLevel1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RightSide extends StatelessWidget {
  const _RightSide();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.installCardanoWallet,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.currentlySupportedWallets,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 24),
        SupportedWallet(
          image: VoicesAssets.images.eternlWallet,
          name: context.l10n.eternlWallet,
          url: 'https://www.example.com', // TODO(LynxLynxx): add url
        ),
        SupportedWallet(
          image: VoicesAssets.images.laceWallet,
          name: context.l10n.laceWallet,
          url: 'https://www.example.com', // TODO(LynxLynxx): add url
        ),
        SupportedWallet(
          image: VoicesAssets.images.namiWallet,
          name: context.l10n.namiWallet,
          url: 'https://www.example.com', // TODO(LynxLynxx): add url
        ),
        const VoicesDivider.expanded(),
        const Spacer(),
        const _NoWalletAction(),
        const Spacer(),
        TipCard(
          headerText: context.l10n.goodToKnow,
          tips: [context.l10n.registrationTransactionFeeDescription],
        ),
      ],
    );
  }
}
