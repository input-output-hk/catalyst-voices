import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A menu of the app that
/// can be also us as a cascade.
class VoicesMenu extends StatelessWidget {
  /// Menu items passed as models, can be nested.
  final List<MenuItem> menuItems;

  /// The widget that is clicked to open menu.
  final Widget child;

  /// The callback called when the menu item is tapped.
  final ValueChanged<String>? onTap;

  /// The default constructor for the [VoicesMenu].
  const VoicesMenu({
    super.key,
    required this.menuItems,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MenuBar(
        style: const MenuStyle(
          elevation: WidgetStatePropertyAll<double>(0),
        ),
        children: [
          SubmenuButton(
            menuChildren: [...menuItems.map(_mapItemToButton)],
            menuStyle: const MenuStyle(alignment: Alignment.centerRight),
            style: MenuItemButton.styleFrom(shadowColor: Colors.transparent),
            child: child,
          ),
        ],
      ),
    );
  }

  _MenuButton _mapItemToButton(MenuItem item) {
    return _MenuButton(
      label: item.label,
      iconData: item.icon,
      showDivider: item.showDivider,
      enabled: item.enabled,
      menuChildren: (item is SubMenuItem)
          ? item.children.map(_mapItemToButton).toList()
          : null,
      onSelected: (item is SubMenuItem) ? null : onTap,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final bool showDivider;
  final bool enabled;
  final List<Widget>? menuChildren;
  final ValueChanged<String>? onSelected;

  const _MenuButton({
    required this.label,
    this.iconData,
    this.showDivider = false,
    this.enabled = true,
    this.menuChildren,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final icon = (iconData != null) ? Icon(iconData, size: 24) : null;

    final textStyle = textTheme.bodyMedium?.copyWith(
      color: enabled ? textTheme.bodySmall?.color : theme.disabledColor,
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
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      icon.icon,
                      size: icon.size,
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
                    padding: EdgeInsets.only(right: 6),
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
                  style: textStyle,
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

/// Model representing Menu Item
class MenuItem {
  final String label;
  final IconData? icon;
  final bool showDivider;
  final bool enabled;

  MenuItem({
    required this.label,
    this.icon,
    this.showDivider = false,
    this.enabled = true,
  });
}

/// Model representing Submenu Item
/// and extending from MenuItem
class SubMenuItem extends MenuItem {
  List<MenuItem> children;

  SubMenuItem({
    required super.label,
    required this.children,
    super.icon,
    super.showDivider,
  });
}
