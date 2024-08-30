import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class VoicesNodeMenuItem extends Equatable {
  const VoicesNodeMenuItem({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

class VoicesNodeMenu extends StatelessWidget {
  final String name;
  final bool isExpanded;
  final int? selected;
  final List<VoicesNodeMenuItem> items;
  final ValueChanged<int?>? onSelectionChanged;
  final ValueChanged<bool>? onExpandChanged;

  bool get _canTapItem => onSelectionChanged != null;

  bool get _canToggleExpand => onExpandChanged != null;

  const VoicesNodeMenu({
    super.key,
    required this.name,
    this.isExpanded = true,
    this.selected,
    required this.items,
    required this.onSelectionChanged,
    required this.onExpandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleTreeView(
      isExpanded: isExpanded,
      root: SimpleTreeViewRootRow(
        onTap: _canToggleExpand ? _onRootTap : null,
        leading: [
          _NodeIcon(isOpen: isExpanded),
          VoicesAssets.images.viewGrid.buildIcon(),
        ],
        child: Text(name),
      ),
      children: items.mapIndexed(
        (index, item) {
          return SimpleTreeViewChildRow(
            key: ValueKey('NodeMenu${item.id}RowKey'),
            hasNext: index < items.length - 1,
            isSelected: item.id == selected,
            onTap: _canTapItem ? () => _onMenuItemTap(item) : null,
            child: Text(item.label),
          );
        },
      ).toList(),
    );
  }

  void _onRootTap() {
    onExpandChanged?.call(!isExpanded);
  }

  void _onMenuItemTap(VoicesNodeMenuItem item) {
    final id = item.id != selected ? item.id : null;
    onSelectionChanged?.call(id);
  }
}

class _NodeIcon extends StatelessWidget {
  final bool isOpen;

  const _NodeIcon({
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colors.iconsForeground),
      child: isOpen
          ? VoicesAssets.images.nodeOpen.buildIcon()
          : VoicesAssets.images.nodeClosed.buildIcon(),
    );
  }
}
