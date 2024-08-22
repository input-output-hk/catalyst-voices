import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final textStyle = textTheme.bodyMedium?.copyWith(
      color: enabled
          ? textTheme.bodySmall?.color
          : theme.disabledColor,
    );

    final children = menuChildren;
    return Wrap(
      children: [
        Stack(
          children: [
            if (icon != null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      icon!.icon,
                      color: enabled
                          ? textTheme.bodySmall?.color
                          : theme.disabledColor,
                    ),
                  ),
                ),
              ),
            if (children != null)
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(CatalystVoicesIcons.chevron_right, size: 20),
                  ),
                ),
              ),
            if (children == null)
              MenuItemButton(
                leadingIcon: icon,
                onPressed: enabled ? (() => onSelected?.call(label)) : null,
                style: MenuItemButton.styleFrom(iconColor: Colors.transparent),
                child: Text(
                  label,
                  style: textStyle,
                ),
              )
            else
              SubmenuButton(
                leadingIcon: icon,
                menuChildren: children,
                style: MenuItemButton.styleFrom(iconColor: Colors.transparent),
                child: Text(
                  label,
                  style: textStyle
                ),
              ),
          ],
        ),
        if (showDivider)
          const Divider(
            height: 0,
            indent: 0,
            thickness: 1,
          ),
      ],
    );
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
