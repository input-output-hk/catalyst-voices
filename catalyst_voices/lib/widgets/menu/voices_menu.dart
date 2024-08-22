import 'package:flutter/material.dart';

class VoicesMenu extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Widget child;
  final ValueChanged<String>? onSelected;

  const VoicesMenu({
    super.key,
    required this.menuItems,
    required this.child,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SubmenuButton(
        menuChildren: [...menuItems.map(_mapItemToButton)],
        menuStyle: const MenuStyle(alignment: Alignment.centerRight),
        child: child,
      ),
    );
  }

  _MenuButton _mapItemToButton(MenuItem item) {
    return _MenuButton(
      label: item.label,
      icon: item.icon,
      showDivider: item.showDivider,
      enabled: item.enabled,
      menuChildren: (item is SubMenuItem)
          ? item.children.map(_mapItemToButton).toList()
          : null,
      onSelected: (item is SubMenuItem) ? null : onSelected,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Icon? icon;
  final bool showDivider;
  final bool enabled;
  final List<Widget>? menuChildren;
  final ValueChanged<String>? onSelected;

  const _MenuButton({
    required this.label,
    this.icon,
    this.showDivider = false,
    this.enabled = true,
    this.menuChildren,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final children = menuChildren;
    if (children == null) {
      return Wrap(
        children: [
          MenuItemButton(
            leadingIcon: icon,
            onPressed: enabled ? (() => onSelected?.call(label)) : null,
            child: Text(label),
          ),
          if (showDivider) const Divider(),
        ],
      );
    } else {
      return Wrap(
        children: [
          SubmenuButton(
            leadingIcon: icon,
            menuChildren: children,
            child: Text(label),
          ),
          if (showDivider) const Divider(),
        ],
      );
    }
  }
}

class MenuItem {
  final String label;
  final Icon? icon;
  final bool showDivider;
  final bool enabled;

  MenuItem({
    required this.label,
    this.icon,
    this.showDivider = false,
    this.enabled = true,
  });
}

class SubMenuItem extends MenuItem {
  List<MenuItem> children;

  SubMenuItem({
    required super.label,
    required this.children,
    super.icon,
    super.showDivider,
  });
}
