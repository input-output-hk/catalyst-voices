import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesMenu extends StatelessWidget {
  final List<MenuItem> items;
  final ValueChanged<String>? onSelected;

  const VoicesMenu({
    super.key,
    required this.items,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: _MenuButton(
          label: 'Menu',
          menuChildren: [...items.map(_mapItemToButton)],
        ),
      ),
    );
  }

  _MenuButton _mapItemToButton(MenuItem item) {
    return _MenuButton(
      label: item.label,
      icon: item.icon,
      showDivider: item.showDivider,
      menuChildren:
      (item is SubMenuItem) ? item.children.map(_mapItemToButton).toList() : null,
      onSelected: (item is SubMenuItem) ? null : onSelected,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Icon? icon;
  final bool showDivider;
  final List<Widget>? menuChildren;
  final ValueChanged<String>? onSelected;

  const _MenuButton({
    required this.label,
    this.icon,
    this.showDivider = false,
    this.menuChildren,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final children = menuChildren;
    if (children == null) {
      return MenuItemButton(
        leadingIcon: icon,
        child: Text(label),
        onPressed: () => onSelected?.call(label),
      );
    } else {
      return SubmenuButton(
        leadingIcon: icon,
        menuChildren: children,
        trailingIcon: const Icon(CatalystVoicesIcons.chevron_right, size: 20),
        child: Text(label),
      );
    }
  }
}

class MenuItem {
  final String label;
  final Icon? icon;
  final bool showDivider;

  MenuItem({
    required this.label,
    this.icon,
    this.showDivider = false,
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
