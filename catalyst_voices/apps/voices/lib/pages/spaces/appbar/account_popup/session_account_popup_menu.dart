import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_avatar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_display_name.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_popup_catalyst_id.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_theme_menu_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_timezone_menu_tile.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class SessionAccountPopupMenu extends StatefulWidget {
  const SessionAccountPopupMenu({
    super.key,
  });

  @override
  State<SessionAccountPopupMenu> createState() {
    return _SessionAccountPopupMenuState();
  }
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

final class _MyOpportunities extends _MenuItemEvent {
  const _MyOpportunities();
}

final class _OpenAccountDetails extends _MenuItemEvent {
  const _OpenAccountDetails();
}

class _Opportunities extends StatelessWidget {
  const _Opportunities();

  @override
  Widget build(BuildContext context) {
    return MenuItemTile(
      key: const Key('MyOpportunitiesMenuItem'),
      title: Text(context.l10n.myOpportunities),
      leading: VoicesAssets.icons.lightBulb.buildIcon(),
      onTap: () => Navigator.pop(context, const _MyOpportunities()),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  @override
  Widget build(BuildContext context) {
    final theme = PopupMenuTheme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.color,
        shape: theme.shape ?? const RoundedRectangleBorder(),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AccountHeader(),
          VoicesDivider.expanded(),
          _Opportunities(),
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
    );
  }
}

class _PopupMenuItem extends PopupMenuItem<_MenuItemEvent> {
  const _PopupMenuItem()
      : super(
          // disabled because PopupMenuItem always adds InkWell
          // and ripple which we don't want.
          enabled: false,
          padding: EdgeInsets.zero,
          value: null,
          child: const _PopupMenu(),
        );
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
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<_MenuItemEvent>>();

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): replace `PopupMenuButton` by `showMenu`.
    // Consider to replace all usages of PopupMenuButton
    // by creating a custom replacement.
    //
    // Reason (when navigating away from a page that opened a PopupMenuButton):
    // To safely refer to a widget's ancestor in its dispose() method, save
    // a reference to the ancestor by calling
    // dependOnInheritedWidgetOfExactType() in the widget's
    // didChangeDependencies() method.
    return PopupMenuButton<_MenuItemEvent>(
      key: _popupMenuButtonKey,
      onSelected: _handleEvent,
      itemBuilder: (context) => const [_PopupMenuItem()],
      tooltip: context.l10n.accountMenuPopupTooltip,
      constraints: const BoxConstraints(maxWidth: 320),
      routeSettings: const RouteSettings(name: '/account_menu'),
      color: PopupMenuTheme.of(context).color,
      // disable because PopupMenuButton internally always wraps child in
      // InkWell which adds unwanted background over color.
      enabled: false,
      child: SessionAccountAvatar(
        key: const Key('SessionAccountPopupMenuAvatar'),
        onTap: () {
          _popupMenuButtonKey.currentState?.showButtonMenu();
        },
      ),
    );
  }

  void _handleEvent(_MenuItemEvent event) {
    switch (event) {
      case _OpenAccountDetails():
        unawaited(const AccountRoute().push(context));
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
      case _MyOpportunities():
        Scaffold.maybeOf(context)?.openEndDrawer();
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
