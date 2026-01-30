import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

const Duration _animDuration = Duration(milliseconds: 200);

/// A custom [Drawer] component that implements the Voices style
/// navigation drawer.
///
/// To add a sticky bottom menu item provide [footer] widget.
///
/// The [VoicesDrawer] is indented to be used as the [Scaffold.drawer].
class VoicesDrawer extends StatefulWidget {
  final double width;

  /// This widget is main "body" of [VoicesDrawer].
  final Widget child;

  final EdgeInsets padding;

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
    this.footer,
    this.bottomSheet,
    required this.child,
  });

  @override
  State<VoicesDrawer> createState() => VoicesDrawerState();

  /// Returns the [VoicesDrawerState] for the nearest [VoicesDrawer] ancestor,
  /// or null if none is found.
  static VoicesDrawerState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<VoicesDrawerState>();
  }

  /// Returns the [VoicesDrawerState] for the nearest [VoicesDrawer] ancestor.
  ///
  /// Throws a [FlutterError] if no [VoicesDrawer] is found in the widget tree.
  static VoicesDrawerState of(BuildContext context) {
    final state = maybeOf(context);
    if (state != null) {
      return state;
    }
    throw FlutterError(
      'VoicesDrawer.of() called with a context that does not contain a VoicesDrawer.\n'
      'No VoicesDrawer ancestor could be found starting from the context that was passed to VoicesDrawer.of().',
    );
  }
}

class VoicesDrawerState extends State<VoicesDrawer> {
  bool _isBottomSheetOpen = false;

  bool get isBottomSheetOpen => _isBottomSheetOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomSheet = widget.bottomSheet;

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
        padding: widget.padding,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Drawer(
                key: const Key('Drawer'),
                width: widget.width,
                child: Column(
                  children: [
                    Expanded(child: widget.child),
                    if (widget.footer != null) widget.footer!,
                  ],
                ),
              ),
              Positioned.fill(
                key: const Key('BottomSheetOverlay'),
                child: AnimatedSwitcher(
                  duration: _animDuration,
                  child: (bottomSheet != null && _isBottomSheetOpen)
                      ? const _BottomSheetOverlay()
                      : null,
                ),
              ),
              Positioned(
                key: const Key('BottomSheet'),
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: _animDuration,
                  child: Offstage(
                    offstage: !_isBottomSheetOpen,
                    child: bottomSheet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hideBottomSheet() {
    setState(() {
      _isBottomSheetOpen = false;
    });
  }

  void showBottomSheet() {
    setState(() {
      _isBottomSheetOpen = true;
    });
  }
}

class _BottomSheetOverlay extends StatelessWidget {
  const _BottomSheetOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colors.onSurfaceNeutral016.withAlpha(50),
    );
  }
}
