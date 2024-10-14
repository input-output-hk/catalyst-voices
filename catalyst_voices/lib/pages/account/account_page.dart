import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/account/delete_keychain_dialog.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/list/bullet_list.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    onRemoveKeychain: () async {
                      final confirmed =
                          await DeleteKeychainDialog.show(context);
                      if (confirmed && context.mounted) {
                        context
                            .read<SessionBloc>()
                            .add(const RemoveKeychainSessionEvent());

                        await VoicesDialog.show<void>(
                          context: context,
                          builder: (context) {
                            return const KeychainDeletedDialog();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CatalystImage.asset(
            VoicesAssets.images.accountBg.path,
          ).image,
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 8,
              ),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                context.l10n.myAccountProfileKeychain,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                context.l10n.yourCatalystKeychainAndRoleRegistration,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
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
              VoicesTextButton.custom(
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
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: BulletList(
                items: roles
                    .map((e) => _formatRoleBullet(e, defaultRole, context))
                    .toList(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
    if (role == defaultRole) {
      return '${role.getName(context)} (${context.l10n.defaultRole})';
    } else {
      return role.getName(context);
    }
  }
}
