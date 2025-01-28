import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_avatar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_account_display_name.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_theme_menu_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/account_popup/session_timezone_menu_tile.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

sealed class _MenuItemEvent {
  const _MenuItemEvent();
}

final class _OpenAccountDetails extends _MenuItemEvent {
  const _OpenAccountDetails();
}

final class _Lock extends _MenuItemEvent {
  const _Lock();
}

class SessionAccountPopupMenu extends StatefulWidget {
  const SessionAccountPopupMenu({
    super.key,
  });

  @override
  State<SessionAccountPopupMenu> createState() {
    return _SessionAccountPopupMenuState();
  }
}

class _SessionAccountPopupMenuState extends State<SessionAccountPopupMenu> {
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<_MenuItemEvent>>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuItemEvent>(
      key: _popupMenuButtonKey,
      initialValue: null,
      onSelected: _handleEvent,
      itemBuilder: (context) => const [_PopupMenuItem()],
      tooltip: 'Account menu',
      constraints: const BoxConstraints(maxWidth: 320),
      routeSettings: const RouteSettings(name: '/account_menu'),
      color: PopupMenuTheme.of(context).color,
      // disable because PopupMenuButton internally always wraps child in
      // InkWell which adds unwanted background over color.
      enabled: false,
      child: SessionAccountAvatar(
        onTap: () {
          _popupMenuButtonKey.currentState?.showButtonMenu();
        },
      ),
    );
  }

  void _handleEvent(_MenuItemEvent event) {
    switch (event) {
      case _OpenAccountDetails():
      // TODO: Handle this case.
      case _Lock():
      // TODO: Handle this case.
    }
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
                //TODO(damian-molinski): Use CatalystId widget
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Account extends StatelessWidget {
  const _Account();

  @override
  Widget build(BuildContext context) {
    return _Section(
      name: 'Account',
      children: [
        MenuItemTile(
          leading: VoicesAssets.icons.userCircle.buildIcon(),
          title: Text('Profile & Keychain'),
          trailing: VoicesAssets.icons.chevronRight.buildIcon(),
          onTap: () => const AccountRoute().go(context),
        ),
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings();

  @override
  Widget build(BuildContext context) {
    return _Section(
      name: 'Settings',
      children: [
        SessionTimezoneMenuTile(),
        SessionThemeMenuTile(),
      ],
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
        MenuItemTile(
          leading: VoicesAssets.icons.userGroup.buildIcon(),
          title: Text('Setup Catalyst roles'),
          onTap: () {},
        ),
        MenuItemTile(
          leading: VoicesAssets.icons.support.buildIcon(),
          title: Text('Submit support request'),
          onTap: () {},
        ),
        MenuItemTile(
          leading: VoicesAssets.icons.academicCap.buildIcon(),
          title: Text('Catalyst knowledge base'),
          onTap: () {},
        ),
      ],
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
          leading: VoicesAssets.icons.lockClosed.buildIcon(),
          title: Text('Lock account'),
          onTap: () {},
        ),
      ],
    );
  }
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
