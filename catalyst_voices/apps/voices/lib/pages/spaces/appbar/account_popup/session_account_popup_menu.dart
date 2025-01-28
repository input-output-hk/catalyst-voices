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

final class _TimezoneChange extends _MenuItemEvent {
  const _TimezoneChange();
}

final class _ThemeModeChange extends _MenuItemEvent {
  final ThemeMode mode;

  const _ThemeModeChange(this.mode);
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
    return _ThemeOverride(
      child: PopupMenuButton<_MenuItemEvent>(
        key: _popupMenuButtonKey,
        initialValue: null,
        onSelected: _handleEvent,
        itemBuilder: (context) => const [_PopupMenuItem()],
        position: PopupMenuPosition.over,
        padding: EdgeInsets.zero,
        tooltip: 'Account menu',
        constraints: const BoxConstraints.tightFor(width: 320),
        child: SessionAccountAvatar(
          onTap: () {
            _popupMenuButtonKey.currentState?.showButtonMenu();
          },
        ),
      ),
    );
  }

  void _handleEvent(_MenuItemEvent event) {
    switch (event) {
      case _OpenAccountDetails():
      // TODO: Handle this case.
      case _TimezoneChange():
      // TODO: Handle this case.
      case _ThemeModeChange():
      // TODO: Handle this case.
      case _Lock():
      // TODO: Handle this case.
    }
  }
}

class _ThemeOverride extends StatelessWidget {
  final Widget child;

  const _ThemeOverride({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // PopupMenuButton always forces InkWell above child which
      // adds overlay colors but we don't want it.
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: child,
    );
  }
}

class _PopupMenuItem extends PopupMenuItem<_MenuItemEvent> {
  const _PopupMenuItem()
      : super(
          // disabled because PopupMenuItem always adds InkWell
          // and ripple which we don't want.
          enabled: false,
          child: const _PopupMenu(),
        );
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
