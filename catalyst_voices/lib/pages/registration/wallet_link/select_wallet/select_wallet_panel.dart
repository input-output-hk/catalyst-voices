import 'package:catalyst_voices/widgets/common/infrastructure/voices_future_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SelectWalletPanel extends StatelessWidget {
  const SelectWalletPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkSelectWalletTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.walletLinkSelectWalletContent,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 40),
        const Expanded(child: _Wallets()),
        const SizedBox(height: 24),
        VoicesBackButton(
          onTap: () {
            RegistrationBloc.of(context).add(const PreviousStepEvent());
          },
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: () {},
          child: Text(context.l10n.seeAllSupportedWallets),
        ),
      ],
    );
  }
}

class _Wallets extends StatelessWidget {
  const _Wallets();

  @override
  Widget build(BuildContext context) {
    return VoicesFutureBuilder(
      future: () async => RegistrationBloc.of(context).getCardanoWallets(),
      dataBuilder: (context, wallets) {
        return ListView.builder(
          itemCount: wallets.length,
          itemBuilder: (context, index) {
            final wallet = wallets[index];
            return VoicesWalletTile(
              iconSrc: wallet.icon,
              name: Text(wallet.name),
              onTap: () {
                RegistrationBloc.of(context).add(const NextStepEvent());
              },
            );
          },
        );
      },
    );
  }
}
