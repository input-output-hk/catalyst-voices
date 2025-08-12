import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A builder that builds menu items for the [VoicesDrawerChooser].
///
/// The builder might provide a completely different widget
/// based on [isSelected] field, which will be true if the [item]
/// is currently selected in the [VoicesDrawerChooser].
typedef VoicesDrawerChooserBuilder<T> = Widget Function({
  required BuildContext context,
  required T item,
  required bool isSelected,
});

/// Displays a horizontal list of [items] built by [itemBuilder]
/// with left and right chevrons that select previous/next items.
///
/// The [VoicesDrawerChooser] is intended to be primarily
/// used as [VoicesDrawer.footer].
class VoicesDrawerChooser<T> extends StatelessWidget {
  /// The list of selectable items.
  /// In most cases it should be an enum that would
  /// help to distinguish between different items.
  final List<T> items;

  /// The currently selected item.
  final T selectedItem;

  /// A callback called when an item gets selected.
  final ValueChanged<T> onSelected;

  /// Builds the widget for the abstract item of type [T].
  final VoicesDrawerChooserBuilder<T> itemBuilder;

  /// The leading widget instead as the first element in a horizontal list.
  ///
  /// Intended to be an extra action that is located next to [items].
  final Widget? leading;

  /// The default constructor for the [VoicesDrawerChooser].
  const VoicesDrawerChooser({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.itemBuilder,
    this.leading,
  });

  int get _selectedIndex => items.indexOf(selectedItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 12,
        right: 12,
        bottom: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (leading != null) leading!,
          IconButton(
            key: const ValueKey('DrawerChooserPreviousButton'),
            onPressed: _selectedIndex > 0 ? _onSelectPrevious : null,
            icon: VoicesAssets.icons.chevronLeft.buildIcon(size: 20),
          ),
          for (final item in items)
            VoicesGestureDetector(
              key: ValueKey('DrawerChooser$item'),
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(item),
              child: itemBuilder(
                context: context,
                item: item,
                isSelected: selectedItem == item,
              ),
            ),
          IconButton(
            key: const ValueKey('DrawerChooserNextButton'),
            onPressed: _selectedIndex < (items.length - 1) ? _onSelectNext : null,
            icon: VoicesAssets.icons.chevronRight.buildIcon(size: 20),
          ),
        ],
      ),
    );
  }

  void _onSelectNext() {
    final next = _selectedIndex + 1;
    onSelected(items[next]);
  }

  void _onSelectPrevious() {
    final previous = _selectedIndex - 1;
    onSelected(items[previous]);
  }
}

/// A menu item widget for the [VoicesDrawerChooser].
///
/// Displays an [icon] of [foregroundColor]
/// with a circular background of [backgroundColor].
class VoicesDrawerChooserItem extends StatelessWidget {
  /// The icon for the widget.
  final IconData icon;

  /// The tint color for the [icon].
  final Color foregroundColor;

  /// The color for the circular background.
  final Color backgroundColor;

  /// The default constructor for the [VoicesDrawerChooserItem].
  const VoicesDrawerChooserItem({
    super.key,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Icon(icon, size: 23),
    );
  }
}

/// A placeholder to be used instead of [VoicesDrawerChooserItem].
///
/// Most common use case would be to return [VoicesDrawerChooserItemPlaceholder]
/// instead of [VoicesDrawerChooserItem] inside the [VoicesDrawerChooserBuilder]
/// if the isSelected param is false.
class VoicesDrawerChooserItemPlaceholder extends StatelessWidget {
  const VoicesDrawerChooserItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: 12,
        height: 12,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colors.iconsDisabled,
        ),
      ),
    );
  }
}
