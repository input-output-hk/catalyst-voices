import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Opinionated widget to be used in [VoicesRawPopupMenuButton.menuBuilder].
class VoicesRawPopupMenu extends StatelessWidget {
  final ShapeBorder? shape;
  final Widget child;

  const VoicesRawPopupMenu({
    super.key,
    this.shape,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final popupTheme = PopupMenuTheme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: popupTheme.color,
        shape: shape ?? popupTheme.shape ?? const RoundedRectangleBorder(),
        shadows: const [
          BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26),
          BoxShadow(offset: Offset(0, 2), blurRadius: 6, spreadRadius: 2, color: Colors.black12),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
