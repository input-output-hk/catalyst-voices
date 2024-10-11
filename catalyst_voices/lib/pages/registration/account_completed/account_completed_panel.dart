import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/next_step.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class AccountCompletedPanel extends StatelessWidget {
  const AccountCompletedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TitleText(),
                const SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    _SummaryItem(
                      image: VoicesAssets.images.registrationSummaryKeychain,
                      title: 'Catalyst Keychain created',
                      info:
                          'You created a Catalyst Keychain, backed up its seed phrase and set an unlock password.',
                    ),
                    _SummaryItem(
                      image: VoicesAssets.images.registrationSummaryWallet,
                      title: 'Cardano Lace wallet selected',
                      info:
                          'You selected your Lace wallet as primary wallet for your voting power.',
                    ),
                    _SummaryItem(
                      image: VoicesAssets.images.registrationSummaryRoles,
                      title: 'Catalyst roles selected',
                      info:
                          'You linked your Cardano wallet and selected  Catalyst roles via a signed transaction.',
                      footer: const _RolesFooter([
                        AccountRole.voter,
                        AccountRole.proposer,
                      ]),
                    ),
                  ].separatedBy(const SizedBox(height: 10)).toList(),
                )
              ],
            ),
          ),
        ),
        const _NextStep(),
        const SizedBox(height: 10),
        _OpenDiscoveryButton(onTap: () {}),
        const SizedBox(height: 10),
        _ReviewMyAccountButton(onTap: () {}),
      ],
    );
  }
}

class _RolesFooter extends StatelessWidget {
  final List<AccountRole> roles;

  const _RolesFooter(this.roles);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...roles.map(
          (role) => Row(
            children: [
              Text(
                '1x',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: VoicesChip(
                  padding: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 6,
                  ),
                  content: Text(
                    role.getName(context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colors.successContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  backgroundColor: Theme.of(context).colors.success,
                ),
              ),
              Text(
                'role registration',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        )
      ]
          .separatedBy(
            SizedBox(height: 6),
          )
          .toList(),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final AssetGenImage image;
  final String title;
  final String info;
  final Widget? footer;

  const _SummaryItem({
    required this.image,
    required this.title,
    required this.info,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CatalystImage.asset(
              image.path,
              width: 52,
              height: 52,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    info,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            VoicesAvatar(
              icon: VoicesAssets.icons.check.buildIcon(),
              radius: 18,
              padding: EdgeInsets.zero,
              foregroundColor: Theme.of(context).colors.iconsPrimary,
              backgroundColor:
                  Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
            )
          ],
        ),
        if (footer != null)
          const VoicesDivider(
            indent: 70,
            endIndent: 0,
          ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: footer!,
          ),
      ]),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel1;

    return Text(
      'Summary',
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep();

  @override
  Widget build(BuildContext context) {
    return const NextStep(null);
  }
}

class _OpenDiscoveryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OpenDiscoveryButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Text('Open Discovery Dashboard'),
    );
  }
}

class _ReviewMyAccountButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ReviewMyAccountButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      onTap: onTap,
      child: Text('Review my account'),
    );
  }
}
