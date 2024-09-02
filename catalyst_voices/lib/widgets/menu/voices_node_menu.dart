import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

base class VoicesNodeMenuItem extends Equatable {
  const VoicesNodeMenuItem({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

final class VoicesNodeMenuData extends Equatable {
  final int? selectedItemId;
  final bool isExpanded;

  const VoicesNodeMenuData({
    this.selectedItemId,
    this.isExpanded = false,
  });

  VoicesNodeMenuData copyWith({
    int? selectedItemId,
    bool? isExpanded,
  }) {
    return VoicesNodeMenuData(
      selectedItemId: selectedItemId ?? this.selectedItemId,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  VoicesNodeMenuData clearSelection() {
    return VoicesNodeMenuData(
      selectedItemId: null,
      isExpanded: isExpanded,
    );
  }

  @override
  List<Object?> get props => [
        selectedItemId,
        isExpanded,
      ];
}

final class VoicesNodeMenuController extends ValueNotifier<VoicesNodeMenuData> {
  set selected(int? newValue) {
    value = newValue != null
        ? value.copyWith(selectedItemId: newValue)
        : value.clearSelection();
  }

  set isExpanded(bool newValue) {
    value = value.copyWith(isExpanded: newValue);
  }

  VoicesNodeMenuController([
    super._value = const VoicesNodeMenuData(),
  ]);
}

class VoicesNodeMenu extends StatelessWidget {
  final String name;
  final VoicesNodeMenuController controller;
  final List<VoicesNodeMenuItem> items;
  final ValueChanged<int?>? onSelectionChanged;
  final ValueChanged<bool>? onExpandChanged;

  bool get _canTapItem => onSelectionChanged != null;

  bool get _canToggleExpand => onExpandChanged != null;

  const VoicesNodeMenu({
    super.key,
    required this.name,
    required this.controller,
    required this.items,
    this.onSelectionChanged,
    this.onExpandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return SimpleTreeView(
          isExpanded: value.isExpanded,
          root: SimpleTreeViewRootRow(
            onTap: _canToggleExpand ? _onRootTap : null,
            leading: [
              _NodeIcon(isOpen: value.isExpanded),
              VoicesAssets.images.viewGrid.buildIcon(),
            ],
            child: Text(name),
          ),
          children: items.mapIndexed(
            (index, item) {
              return SimpleTreeViewChildRow(
                key: ValueKey('NodeMenu${item.id}RowKey'),
                hasNext: index < items.length - 1,
                isSelected: item.id == value.selectedItemId,
                onTap: _canTapItem ? () => _onMenuItemTap(item) : null,
                child: Text(item.label),
              );
            },
          ).toList(),
        );
      },
    );
  }

  void _onRootTap() {
    onExpandChanged?.call(!controller.value.isExpanded);
  }

  void _onMenuItemTap(VoicesNodeMenuItem item) {
    final id = item.id != controller.value.selectedItemId ? item.id : null;
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
