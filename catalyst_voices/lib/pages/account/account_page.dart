import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const _Header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const _Tab(),
                    const SizedBox(height: 48),
                    _KeychainCard(
                      connectedWallet: 'Lace',
                      roles: const [
                        AccountRole.voter,
                        AccountRole.proposer,
                        AccountRole.drep,
                      ],
                      defaultRole: AccountRole.voter,
                      onRemoveKeychain: () => debugPrint('Keychain removed'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CatalystImage.asset(
                  VoicesAssets.images.accountBg.path,
                ).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 8,
            child: VoicesIconButton.filled(
              onTap: () {
                GoRouter.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
                ),
                foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).colors.iconsForeground,
                ),
              ),
              child: VoicesAssets.icons.arrowNarrowLeft.buildIcon(),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 32,
            child: Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  context.l10n.myAccountProfileKeychain,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.yourCatalystKeychainAndRoleRegistration,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: TabBar(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        isScrollable: true,
        tabs: [
          Tab(text: context.l10n.profileAndKeychain),
        ],
      ),
    );
  }
}

class _KeychainCard extends StatelessWidget {
  final String? connectedWallet;
  final List<AccountRole> roles;
  final AccountRole? defaultRole;
  final VoidCallback? onRemoveKeychain;

  const _KeychainCard({
    this.connectedWallet,
    this.roles = const <AccountRole>[],
    this.defaultRole,
    this.onRemoveKeychain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant!,
          width: 1,
        ),
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.catalystKeychain,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              VoicesTextButton.customColor(
                leading: VoicesAssets.icons.x.buildIcon(),
                color: Theme.of(context).colors.iconsError,
                onTap: onRemoveKeychain,
                child: Text(
                  context.l10n.removeKeychain,
                ),
              ),
            ],
          ),
          if (connectedWallet != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                context.l10n.walletConnected,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (connectedWallet != null)
            Row(
              children: [
                VoicesIconButton.filled(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).colors.successContainer,
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colors.success,
                    ),
                  ),
                  child: VoicesAssets.icons.check.buildIcon(),
                ),
                const SizedBox(width: 12),
                Text(
                  connectedWallet!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          if (roles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 24,
              ),
              child: Text(
                context.l10n.currentRoleRegistrations,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (roles.isNotEmpty)
            Text(
              roles
                  .map((e) => _formatRoleBullet(e, defaultRole, context))
                  .join('\n'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }

  String _formatRoleBullet(
    AccountRole role,
    AccountRole? defaultRole,
    BuildContext context,
  ) {
    String label;
    if (role.name == defaultRole?.name) {
      label = '${role.name} (${context.l10n.defaultRole})';
    } else {
      label = role.name(context);
    }
    return ' • $label';
  }
}

enum AccountRole {
  voter,
  proposer,
  drep,
}

extension on AccountRole {
  String name(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.voter;
      case AccountRole.proposer:
        return context.l10n.proposer;
      case AccountRole.drep:
        return context.l10n.drep;
    }
  }
}
