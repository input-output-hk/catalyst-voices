import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    hide PopupMenuItem;
import 'package:flutter/material.dart';

class VoicesDropdownCategory extends StatelessWidget {
  final List<DropdownMenuViewModel> items;
  final Color? highlightColor;
  final Clip clipBehavior;
  final GlobalKey<PopupMenuButtonState<dynamic>> popupMenuButtonKey;
  final ValueChanged<String?>? onSelected;
  final VoidCallback? onCanceled;
  final VoidCallback? onOpened;
  final Offset offset;
  final BoxConstraints constraints;
  final Widget child;

  const VoicesDropdownCategory({
    super.key,
    required this.items,
    required this.popupMenuButtonKey,
    this.clipBehavior = Clip.hardEdge,
    this.highlightColor,
    this.onSelected,
    this.offset = const Offset(0, 40),
    this.constraints = const BoxConstraints(maxWidth: 320),
    this.onCanceled,
    this.onOpened,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        clipBehavior: clipBehavior,
        key: popupMenuButtonKey,
        offset: offset,
        constraints: constraints,
        color: PopupMenuTheme.of(context).color,
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          visualDensity: VisualDensity.compact,
        ),
        itemBuilder: (BuildContext context) {
          return items
              .map(
                (e) => _PopupMenuItemHighlightColor(
                  value: e.value,
                  color: e.isSelected ? highlightColor : null,
                  child: Text(e.name),
                ),
              )
              .toList();
        },
        onSelected: onSelected,
        onCanceled: onCanceled,
        onOpened: onOpened,
        child: child,
      ),
    );
  }
}

class _PopupMenuItemHighlightColor<T> extends PopupMenuItem<T> {
  final Color? color;

  const _PopupMenuItemHighlightColor({
    super.key,
    super.value,
    super.enabled,
    super.child,
    this.color,
  });

  @override
  CustomPopupMenuItemState<T> createState() => CustomPopupMenuItemState<T>();
}

class CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, _PopupMenuItemHighlightColor<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: super.build(context),
    );
  }
}
