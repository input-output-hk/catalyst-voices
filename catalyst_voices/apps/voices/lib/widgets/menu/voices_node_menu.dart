import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VoicesNodeMenu extends StatelessWidget {
  final Widget name;
  final Widget? icon;
  final VoidCallback? onHeaderTap;
  final String? selectedItemId;
  final ValueChanged<String> onItemTap;
  final List<VoicesNodeMenuItem> items;
  final bool isExpandable;
  final bool isExpanded;

  const VoicesNodeMenu({
    super.key,
    required this.name,
    this.icon,
    this.onHeaderTap,
    this.selectedItemId,
    required this.onItemTap,
    required this.items,
    this.isExpandable = true,
    this.isExpanded = false,
  }) : assert(
          !isExpanded || isExpandable,
          'Can not be expanded and not expandable at same time',
        );

  @override
  Widget build(BuildContext context) {
    return SimpleTreeView(
      isExpanded: isExpanded,
      root: SimpleTreeViewRootRow(
        onTap: isExpandable ? onHeaderTap : null,
        leading: [
          VoicesNodeMenuIcon(isOpen: isExpanded),
          icon ?? VoicesAssets.icons.viewGrid.buildIcon(),
        ],
        child: name,
      ),
      children: items.mapIndexed(
        (index, item) {
          return SimpleTreeViewChildRow(
            key: ValueKey('NodeMenu${item.id}RowKey'),
            hasNext: index < items.length - 1,
            isSelected: item.id == selectedItemId,
            hasError: item.hasError,
            onTap: item.isEnabled ? () => onItemTap(item.id) : null,
            child: Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
    );
  }
}

class VoicesNodeMenuIcon extends StatelessWidget {
  final bool isOpen;

  const VoicesNodeMenuIcon({
    super.key,
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colors.iconsForeground),
      child: isOpen
          ? VoicesAssets.icons.nodeOpen.buildIcon()
          : VoicesAssets.icons.nodeClosed.buildIcon(),
    );
  }
}

final class VoicesNodeMenuItem extends Equatable {
  final String id;
  final String label;
  final bool isEnabled;
  final bool hasError;

  const VoicesNodeMenuItem({
    required this.id,
    required this.label,
    this.isEnabled = true,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        isEnabled,
        hasError,
      ];
}
