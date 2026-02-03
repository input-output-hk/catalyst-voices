import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

const _animDuration = Duration(milliseconds: 200);

class BottomSheetContainer extends StatefulWidget {
  final Widget? bottomSheet;
  final BottomSheetContainerController? controller;
  final Widget child;

  const BottomSheetContainer({
    super.key,
    this.bottomSheet,
    this.controller,
    required this.child,
  });

  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

final class BottomSheetContainerController extends ValueNotifier<bool> {
  BottomSheetContainerController({bool isOpen = false}) : super(isOpen);

  void hide() {
    value = false;
  }

  void show() {
    value = true;
  }
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  BottomSheetContainerController? _controller;

  BottomSheetContainerController get effectiveController =>
      widget.controller ?? (_controller ??= BottomSheetContainerController());

  @override
  Widget build(BuildContext context) {
    final bottomSheet = widget.bottomSheet;

    return ValueListenableBuilder(
      valueListenable: effectiveController,
      builder: (context, value, child) {
        return Stack(
          children: [
            ?child,
            Positioned.fill(
              key: const Key('BottomSheetOverlay'),
              child: AnimatedSwitcher(
                duration: _animDuration,
                child: (bottomSheet != null && value) ? const _BottomSheetOverlay() : null,
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
                  offstage: !value,
                  child: bottomSheet,
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
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
