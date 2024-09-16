import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class VoicesNodeMenuItem extends Equatable {
  final int id;
  final String label;
  final bool isEnabled;

  const VoicesNodeMenuItem({
    required this.id,
    required this.label,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        isEnabled,
      ];
}

class VoicesNodeMenuStateData extends Equatable {
  final int? selectedItemId;
  final bool isExpanded;

  const VoicesNodeMenuStateData({
    this.selectedItemId,
    this.isExpanded = false,
  });

  VoicesNodeMenuStateData copyWith({
    int? selectedItemId,
    bool? isExpanded,
  }) {
    return VoicesNodeMenuStateData(
      selectedItemId: selectedItemId ?? this.selectedItemId,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  VoicesNodeMenuStateData clearSelection() {
    return VoicesNodeMenuStateData(
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

class VoicesNodeMenuController extends ValueNotifier<VoicesNodeMenuStateData> {
  VoicesNodeMenuController([
    super._value = const VoicesNodeMenuStateData(),
  ]);

  int? get selected => value.selectedItemId;

  set selected(int? newValue) {
    value = newValue != null
        ? value.copyWith(selectedItemId: newValue)
        : value.clearSelection();
  }

  bool get isExpanded => value.isExpanded;

  set isExpanded(bool newValue) {
    value = value.copyWith(isExpanded: newValue);
  }
}

class VoicesNodeMenu extends StatefulWidget {
  final String name;
  final VoicesNodeMenuController? controller;
  final List<VoicesNodeMenuItem> items;
  final bool isExpandable;

  const VoicesNodeMenu({
    super.key,
    required this.name,
    this.controller,
    required this.items,
    this.isExpandable = true,
  });

  @override
  State<VoicesNodeMenu> createState() => _VoicesNodeMenuState();
}

class _VoicesNodeMenuState extends State<VoicesNodeMenu> {
  VoicesNodeMenuController? _controller;

  VoicesNodeMenuController get _effectiveController =>
      widget.controller ?? (_controller ??= VoicesNodeMenuController());

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _effectiveController,
      builder: (context, value, _) {
        return SimpleTreeView(
          isExpanded: value.isExpanded,
          root: SimpleTreeViewRootRow(
            onTap: widget.isExpandable ? _onRootTap : null,
            leading: [
              _NodeIcon(isOpen: value.isExpanded),
              VoicesAssets.icons.viewGrid.buildIcon(),
            ],
            child: Text(widget.name),
          ),
          children: widget.items.mapIndexed(
            (index, item) {
              return SimpleTreeViewChildRow(
                key: ValueKey('NodeMenu${item.id}RowKey'),
                hasNext: index < widget.items.length - 1,
                isSelected: item.id == value.selectedItemId,
                onTap: item.isEnabled ? () => _onMenuItemTap(item) : null,
                child: Text(item.label),
              );
            },
          ).toList(),
        );
      },
    );
  }

  void _onRootTap() {
    _effectiveController.isExpanded = !_effectiveController.isExpanded;
  }

  void _onMenuItemTap(VoicesNodeMenuItem item) {
    final id = item.id != _effectiveController.selected ? item.id : null;

    _effectiveController.selected = id;
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
          ? VoicesAssets.icons.nodeOpen.buildIcon()
          : VoicesAssets.icons.nodeClosed.buildIcon(),
    );
  }
}
