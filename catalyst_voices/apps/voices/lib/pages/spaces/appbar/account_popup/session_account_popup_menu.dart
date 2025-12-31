import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_avatar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_display_name.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_popup_catalyst_id.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_theme_menu_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_timezone_menu_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/widgets/my_actions_menu_item_tile.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/widgets/menu/voices_raw_popup_menu.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionAccountPopupMenu extends StatefulWidget {
  const SessionAccountPopupMenu({super.key});

  @override
  State<SessionAccountPopupMenu> createState() => _SessionAccountPopupMenuState();
}

class _Account extends StatelessWidget {
  const _Account();

  @override
  Widget build(BuildContext context) {
    return _Section(
      name: context.l10n.account,
      children: [
        MenuItemTile(
          leading: VoicesAssets.icons.userCircle.buildIcon(),
          key: const Key('ProfileAndKeychain'),
          title: Text(context.l10n.profileAndKeychain),
          trailing: VoicesAssets.icons.chevronRight.buildIcon(),
          onTap: () => Navigator.pop(context, const _OpenAccountDetails()),
        ),
      ],
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          SessionAccountAvatar(),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SessionAccountDisplayName(),
                SessionAccountPopupCatalystId(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Links extends StatelessWidget {
  const _Links();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Note. This is not supported atm.
        Offstage(
          child: MenuItemTile(
            key: const Key('SetupRolesMenuItem'),
            leading: VoicesAssets.icons.userGroup.buildIcon(),
            title: Text(context.l10n.setupCatalystRoles),
            onTap: () => Navigator.pop(context, const _SetupRoles()),
          ),
        ),
        MenuItemTile(
          key: const Key('SubmitSupportRequest'),
          leading: VoicesAssets.icons.support.buildIcon(),
          title: Text(context.l10n.submitSupportRequest),
          onTap: () => Navigator.pop(context, const _RedirectToSupport()),
        ),
        MenuItemTile(
          key: const Key('CatalystKnowledgeBase'),
          leading: VoicesAssets.icons.academicCap.buildIcon(),
          title: Text(context.l10n.catalystKnowledgeBase),
          onTap: () => Navigator.pop(context, const _RedirectToDocs()),
        ),
      ],
    );
  }
}

final class _Lock extends _MenuItemEvent {
  const _Lock();
}

sealed class _MenuItemEvent {
  const _MenuItemEvent();
}

final class _MyActionsEvent extends _MenuItemEvent {
  const _MyActionsEvent();
}

class _MyActionsTile extends StatelessWidget {
  const _MyActionsTile();

  @override
  Widget build(BuildContext context) {
    return MyActionsMenuItemTile(
      onTap: () => Navigator.pop(context, const _MyActionsEvent()),
    );
  }
}

final class _OpenAccountDetails extends _MenuItemEvent {
  const _OpenAccountDetails();
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenu(
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 320),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AccountHeader(),
            VoicesDivider.expanded(),
            _MyActionsTile(),
            VoicesDivider.expanded(),
            _Account(),
            _Settings(),
            VoicesDivider.expanded(height: 17),
            _Links(),
            VoicesDivider.expanded(height: 17),
            _Session(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

final class _RedirectToDocs extends _MenuItemEvent {
  const _RedirectToDocs();
}

final class _RedirectToSupport extends _MenuItemEvent {
  const _RedirectToSupport();
}

class _Section extends StatelessWidget {
  final String name;
  final List<Widget> children;

  const _Section({
    required this.name,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SectionName(name),
        ...children,
      ],
    );
  }
}

class _SectionName extends StatelessWidget {
  final String data;

  const _SectionName(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 40),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        data,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
    );
  }
}

class _Session extends StatelessWidget {
  const _Session();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuItemTile(
          key: const Key('LockAccountButton'),
          leading: VoicesAssets.icons.lockClosed.buildIcon(),
          title: Text(context.l10n.lockAccount),
          onTap: () => Navigator.pop(context, const _Lock()),
        ),
      ],
    );
  }
}

class _SessionAccountPopupMenuState extends State<SessionAccountPopupMenu> with LaunchUrlMixin {
  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenuButton<_MenuItemEvent>(
      buttonBuilder:
          (
            context,
            onTapCallback, {
            required isMenuOpen,
          }) {
            return SessionAccountAvatar(
              key: const Key('SessionAccountPopupMenuAvatar'),
              onTap: onTapCallback,
            );
          },
      menuBuilder: (context) => const _PopupMenu(),
      onSelected: _handleEvent,
      routeSettings: const RouteSettings(name: '/account_menu'),
      position: VoicesRawPopupMenuPosition.over,
      menuOffset: Offset.zero,
    );
  }

  void _handleEvent(_MenuItemEvent event) {
    switch (event) {
      case _OpenAccountDetails():
        final router = GoRouter.of(context);
        final matchedLocation = router.routerDelegate.state.matchedLocation;
        final isAccount = matchedLocation == const AccountRoute().location;
        if (!isAccount) {
          unawaited(const AccountRoute().push(context));
        }
      case _SetupRoles():
        // TODO(damian-molinski): don't know what it should do
        break;
      case _RedirectToSupport():
        final uri = Uri.parse(VoicesConstants.supportUrl);
        unawaited(launchUri(uri));
      case _RedirectToDocs():
        final uri = Uri.parse(VoicesConstants.catalystKnowledgeBaseUrl);
        unawaited(launchUri(uri));
      case _Lock():
        unawaited(context.read<SessionCubit>().lock());
      case _MyActionsEvent():
        unawaited(const ActionsRoute().push(context));
    }
  }
}

class _Settings extends StatelessWidget {
  const _Settings();

  @override
  Widget build(BuildContext context) {
    return _Section(
      name: context.l10n.settings,
      children: const [
        SessionTimezoneMenuTile(),
        SessionThemeMenuTile(),
      ],
    );
  }
}

final class _SetupRoles extends _MenuItemEvent {
  const _SetupRoles();
}
