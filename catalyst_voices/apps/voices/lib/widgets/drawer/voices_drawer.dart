import 'package:flutter/material.dart';

/// A custom [Drawer] component that implements the Voices style
/// navigation drawer.
///
/// To add a sticky bottom menu item provide [footer] widget.
///
/// The [VoicesDrawer] is indented to be used as the [Scaffold.drawer].
class VoicesDrawer extends StatelessWidget {
  final double width;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  /// This widget is main "body" of [VoicesDrawer].
  final Widget child;

  /// The sticky item at the bottom.
  final Widget? footer;

  /// The widget which overlays the [VoicesDrawer]
  /// and appears as a bottom sheet bundled into the drawer.
  final Widget? bottomSheet;

  /// The default constructor for the [VoicesDrawer].
  const VoicesDrawer({
    super.key,
    this.width = 360,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    required this.child,
    this.footer,
    this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomSheet = this.bottomSheet;

    return Theme(
      data: theme.copyWith(
        dividerTheme: theme.dividerTheme.copyWith(
          indent: 24,
          endIndent: 24,
          space: 16,
        ),
        iconTheme: theme.iconTheme.copyWith(
          size: 22,
        ),
      ),
      child: Padding(
        padding: padding,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          child: Stack(
            children: [
              Drawer(
                width: width,
                child: Column(
                  children: [
                    Expanded(child: child),
                    if (footer != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 12,
                          right: 12,
                          bottom: 18,
                        ),
                        child: footer,
                      ),
                  ],
                ),
              ),
              if (bottomSheet != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                  ),
                ),
              if (bottomSheet != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: bottomSheet,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
