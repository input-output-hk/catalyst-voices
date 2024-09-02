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

final class VoicesNodeMenuController extends ChangeNotifier {
  int? get selected => _selected;
  int? _selected;

  set selected(int? newValue) {
    if (_selected == newValue) {
      return;
    }
    _selected = newValue;
    notifyListeners();
  }

  bool get isExpanded => _isExpanded;
  bool _isExpanded;

  set isExpanded(bool newValue) {
    if (_isExpanded == newValue) {
      return;
    }
    _isExpanded = newValue;
    notifyListeners();
  }

  VoicesNodeMenuController({
    int? selected,
    bool expanded = true,
  })  : _selected = selected,
        _isExpanded = expanded;
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
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return SimpleTreeView(
          isExpanded: controller.isExpanded,
          root: SimpleTreeViewRootRow(
            onTap: _canToggleExpand ? _onRootTap : null,
            leading: [
              _NodeIcon(isOpen: controller.isExpanded),
              VoicesAssets.images.viewGrid.buildIcon(),
            ],
            child: Text(name),
          ),
          children: items.mapIndexed(
            (index, item) {
              return SimpleTreeViewChildRow(
                key: ValueKey('NodeMenu${item.id}RowKey'),
                hasNext: index < items.length - 1,
                isSelected: item.id == controller.selected,
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
    onExpandChanged?.call(!controller.isExpanded);
  }

  void _onMenuItemTap(VoicesNodeMenuItem item) {
    final id = item.id != controller.selected ? item.id : null;
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
