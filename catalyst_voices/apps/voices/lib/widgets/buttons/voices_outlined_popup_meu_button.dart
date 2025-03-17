import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class VoicesOutlinedPopupMeuButton<T> extends StatelessWidget {
  final List<T> items;
  final IndexedWidgetBuilder builder;
  final ValueChanged<T>? onSelected;
  final bool showBorder;
  final Widget? leading;
  final Widget child;

  const VoicesOutlinedPopupMeuButton({
    super.key,
    required this.items,
    required this.builder,
    this.onSelected,
    this.showBorder = true,
    this.leading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: (context) {
        return items.mapIndexed((index, element) {
          return PopupMenuItem(
            value: element,
            child: builder(context, index),
          );
        }).toList();
      },
      clipBehavior: Clip.antiAlias,
      onSelected: onSelected,
      constraints: const BoxConstraints(minWidth: 212),
      borderRadius: BorderRadius.circular(8),
      splashRadius: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AbsorbPointer(
        child: VoicesOutlinedButton(
          leading: leading,
          trailing: onSelected != null
              ? VoicesAssets.icons.chevronDown.buildIcon()
              : null,
          onTap: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: showBorder
                ? BorderSide(color: context.colors.outlineBorderVariant)
                : BorderSide.none,
            foregroundColor: context.colors.textOnPrimaryLevel1,
            iconColor: context.colors.textOnPrimaryLevel1,
          ),
          child: child,
        ),
      ),
    );
  }
}
