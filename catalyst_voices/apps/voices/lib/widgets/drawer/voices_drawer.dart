import 'package:flutter/material.dart';

const Duration _animDuration = Duration(milliseconds: 200);

/// A custom [Drawer] component that implements the Voices style
/// navigation drawer.
///
/// To add a sticky bottom menu item provide [footer] widget.
///
/// The [VoicesDrawer] is indented to be used as the [Scaffold.drawer].
class VoicesDrawer extends StatelessWidget {
  final double width;

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
        padding: const EdgeInsets.all(16),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Drawer(
                key: const Key('Drawer'),
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
              Positioned.fill(
                key: const Key('BottomSheetOverlay'),
                child: AnimatedSwitcher(
                  duration: _animDuration,
                  child: bottomSheet != null ? const _BottomSheetOverlay() : null,
                ),
              ),
              Positioned(
                key: const Key('BottomSheet'),
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: bottomSheet,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetOverlay extends StatelessWidget {
  const _BottomSheetOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
    );
  }
}
