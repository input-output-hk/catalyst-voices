import 'package:catalyst_voices_view_models/src/menu/menu_item.dart';
import 'package:flutter/widgets.dart';

abstract interface class PopupMenuItem implements MenuItem {
  Widget? get icon;

  bool get showDivider;
}

base class BasicPopupMenuItem extends BasicMenuItem implements PopupMenuItem {
  @override
  final Widget? icon;

  @override
  final bool showDivider;

  const BasicPopupMenuItem({
    required super.id,
    required super.label,
    super.isEnabled,
    this.icon,
    this.showDivider = false,
  });

  @override
  List<Object?> get props =>
      super.props +
      [
        icon,
        showDivider,
      ];
}
