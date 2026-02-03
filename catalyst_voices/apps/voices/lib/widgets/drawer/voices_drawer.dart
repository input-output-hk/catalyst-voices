import 'package:catalyst_voices/widgets/containers/bottom_sheet_container.dart';
import 'package:flutter/material.dart';

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
  final _bottomSheetController = BottomSheetContainerController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          child: BottomSheetContainer(
            bottomSheet: widget.bottomSheet,
            controller: _bottomSheetController,
            child: Drawer(
              key: const Key('Drawer'),
              width: widget.width,
              child: Column(
                children: [
                  Expanded(child: widget.child),
                  if (widget.footer != null) widget.footer!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  void hideBottomSheet() {
    _bottomSheetController.hide();
  }

  void showBottomSheet() {
    _bottomSheetController.show();
  }
}
