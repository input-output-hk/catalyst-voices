import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/common/ext/ext.dart';
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
                Column(
                  children: const <Widget>[
                    _CatalystKeychainCreatedCard(),
                    _WalletConnectedCardSelector(),
                    _RolesSelectedCardSelector(),
                  ].separatedBy(const SizedBox(height: 10)).toList(),
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

class _CatalystKeychainCreatedCard extends StatelessWidget {
  const _CatalystKeychainCreatedCard();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: VoicesAssets.icons.key.buildIcon(),
      title: Text(context.l10n.registrationCompletedKeychainTitle),
      desc: Text(context.l10n.registrationCompletedKeychainInfo),
      statusIcon: VoicesAssets.icons.check.buildIcon(),
    );
  }
}

class _WalletConnectedCardSelector extends StatelessWidget {
  const _WalletConnectedCardSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState, String>(
      selector: (state) {
        final wallet = state.walletLinkStateData.selectedWallet;
        final name = wallet?.metadata.name ?? '';
        return name.capitalize();
      },
      builder: (context, walletName) {
        return _WalletConnectedCard(walletName: walletName);
      },
    );
  }
}

class _WalletConnectedCard extends StatelessWidget {
  final String walletName;

  const _WalletConnectedCard({
    required this.walletName,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: VoicesAssets.icons.wallet.buildIcon(),
      title: Text(
        context.l10n.registrationCompletedWalletTitle(walletName),
      ),
      desc: Text(
        context.l10n.registrationCompletedWalletInfo(walletName),
      ),
      statusIcon: VoicesAssets.icons.check.buildIcon(),
    );
  }
}

class _RolesSelectedCardSelector extends StatelessWidget {
  const _RolesSelectedCardSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState,
        List<AccountRole>>(
      selector: (state) {
        return state.walletLinkStateData.selectedRoles?.toList() ??
            state.walletLinkStateData.defaultRoles.toList();
      },
      builder: (context, roles) {
        return _RolesSelectedCard(roles: roles);
      },
    );
  }
}

class _RolesSelectedCard extends StatelessWidget {
  final List<AccountRole> roles;

  const _RolesSelectedCard({
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: VoicesAssets.icons.summary.buildIcon(),
      title: Text(context.l10n.registrationCompletedRolesTitle),
      desc: Text(context.l10n.registrationCompletedRolesInfo),
      statusIcon: VoicesAssets.icons.check.buildIcon(),
      isExpanded: true,
      body: _RolesFooter(roles),
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
      mainAxisSize: MainAxisSize.min,
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
