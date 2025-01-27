import 'package:catalyst_voices/widgets/widgets.dart';
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
  final _popupMenuButtonKey = GlobalKey<PopupMenuButtonState<String>>();

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
        child: VoicesAvatar(
          icon: Text('A'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Header'),
        Text('Account'),
        Text('Settings'),
        Text('Links'),
        VoicesSwitch(
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (value) {
            final mode = value ? Brightness.dark : Brightness.light;
            Navigator.pop(context, mode.name);
          },
        ),
        Text('Lock'),
      ],
    );
  }
}
