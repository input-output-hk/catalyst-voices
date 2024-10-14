import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/next_step.dart';
import 'package:catalyst_voices/routes/routing/account_route.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    final roles =
                        state.walletLinkStateData.selectedRoles?.toList() ?? [];
                    final walletName =
                        state.walletLinkStateData.selectedWallet?.wallet.name ??
                            '';

                    return Column(
                      children: <Widget>[
                        _SummaryItem(
                          image:
                              VoicesAssets.images.registrationSummaryKeychain,
                          title:
                              context.l10n.registrationCompletedKeychainTitle,
                          info: context.l10n.registrationCompletedKeychainInfo,
                        ),
                        _SummaryItem(
                          image: VoicesAssets.images.registrationSummaryWallet,
                          title: context.l10n
                              .registrationCompletedWalletTitle(walletName),
                          info: context.l10n
                              .registrationCompletedWalletInfo(walletName),
                        ),
                        _SummaryItem(
                          image: VoicesAssets.images.registrationSummaryRoles,
                          title: context.l10n.registrationCompletedRolesTitle,
                          info: context.l10n.registrationCompletedRolesInfo,
                          footer: _RolesFooter(roles),
                        ),
                      ].separatedBy(const SizedBox(height: 10)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const _NextStep(),
        const SizedBox(height: 10),
        _OpenDiscoveryButton(
          onTap: () {
            Navigator.pop(context);
            const DiscoveryRoute().go(context);
          },
        ),
        const SizedBox(height: 10),
        _ReviewMyAccountButton(
          onTap: () {
            Navigator.pop(context);
            const AccountRoute().go(context);
          },
        ),
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
                context.l10n.registrationCompletedRole1x,
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
                context.l10n.registrationCompletedRoleRegistration,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ]
          .separatedBy(
            const SizedBox(height: 6),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalystImage.asset(
                image.path,
                width: 52,
                height: 52,
              ),
              const SizedBox(width: 10),
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
                radius: 14,
                padding: EdgeInsets.zero,
                foregroundColor: Theme.of(context).colors.iconsPrimary,
                backgroundColor:
                    Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
              ),
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
              child: footer,
            ),
        ],
      ),
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
      context.l10n.registrationCompletedSummaryHeader,
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
      child: Text(context.l10n.registrationCompletedDiscoveryButton),
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
      child: Text(context.l10n.registrationCompletedAccountButton),
    );
  }
}
