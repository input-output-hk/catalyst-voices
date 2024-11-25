import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// A menu of the app that
/// can be also us as a cascade.
class VoicesMenu extends StatelessWidget {
  /// Menu items passed as models, can be nested.
  final List<MenuItem> menuItems;

  /// The widget that is clicked to open menu.
  final Widget child;

  /// The callback called when the menu item is tapped.
  final ValueChanged<MenuItem>? onTap;

  /// The default constructor for the [VoicesMenu].
  const VoicesMenu({
    super.key,
    required this.menuItems,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MenuBar(
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
    );
  }

  _MenuButton _mapItemToButton(MenuItem item) {
    return _MenuButton(
      menuItem: item,
      menuChildren: (item is SubMenuItem)
          ? item.children.map(_mapItemToButton).toList()
          : null,
      onSelected: (item is SubMenuItem) ? null : onTap,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MenuItem menuItem;
  final List<Widget>? menuChildren;
  final ValueChanged<MenuItem>? onSelected;

  const _MenuButton({
    required this.menuItem,
    this.menuChildren,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final icon = menuItem.icon;

    final textStyle = textTheme.bodyMedium?.copyWith(
      color:
          menuItem.isEnabled ? textTheme.bodySmall?.color : theme.disabledColor,
    );

    final children = menuChildren;
    return Column(
      children: [
        Stack(
          children: [
            if (icon != null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconTheme(
                      data: IconThemeData(
                        size: 24,
                        color: menuItem.isEnabled
                            ? textTheme.bodySmall?.color
                            : theme.disabledColor,
                      ),
                      child: icon,
                    ),
                  ),
                ),
              ),
            if (children != null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: VoicesAssets.icons.chevronRight.buildIcon(size: 20),
                  ),
                ),
              ),
            if (children == null)
              MenuItemButton(
                leadingIcon: icon,
                onPressed: () => onSelected?.call(menuItem),
                style: MenuItemButton.styleFrom(iconColor: Colors.transparent),
                child: Text(
                  menuItem.label,
                  style: textStyle,
                ),
              )
            else
              SubmenuButton(
                leadingIcon: icon,
                menuChildren: children,
                style: MenuItemButton.styleFrom(iconColor: Colors.transparent),
                child: Text(
                  menuItem.label,
                  style: textStyle,
                ),
              ),
          ],
        ),
        if (menuItem.showDivider)
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
final class MenuItem extends BasicPopupMenuItem {
  const MenuItem({
    required super.id,
    required super.label,
    super.isEnabled = true,
    super.icon,
    super.showDivider = false,
  });
}

/// Model representing Submenu Item
/// and extending from MenuItem
final class SubMenuItem extends MenuItem {
  final List<MenuItem> children;

  const SubMenuItem({
    required super.id,
    required super.label,
    required this.children,
    super.icon,
    super.showDivider,
  });

  @override
  List<Object?> get props => super.props + [children];
}
