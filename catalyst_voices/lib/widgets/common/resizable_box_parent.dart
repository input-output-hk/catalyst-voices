import 'dart:math';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/widgets.dart';

/// A parent component that adds ability to resize its child
class ResizableBoxParent extends StatelessWidget {
  final bool resizableVertically;
  final bool resizableHorizontally;
  final Widget child;
  final double minWidth;
  final double minHeight;

  const ResizableBoxParent({
    super.key,
    required this.resizableVertically,
    required this.resizableHorizontally,
    required this.child,
    this.minWidth = 40,
    this.minHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (!resizableVertically && !resizableHorizontally) {
      return child;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _ResizableBox(
          constraints: constraints,
          minWidth: minWidth,
          minHeight: minHeight,
          resizableHorizontally: resizableHorizontally,
          resizableVertically: resizableVertically,
          child: child,
        );
      },
    );
  }
}

class _ResizableBox extends StatefulWidget {
  final BoxConstraints constraints;
  final Widget child;
  final double minWidth;
  final double minHeight;
  final bool resizableVertically;
  final bool resizableHorizontally;

  const _ResizableBox({
    required this.constraints,
    required this.child,
    required this.minWidth,
    required this.minHeight,
    required this.resizableVertically,
    required this.resizableHorizontally,
  });

  @override
  State<_ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<_ResizableBox> {
  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();

    if (widget.resizableHorizontally) {
      _width = widget.constraints.maxWidth != double.infinity
          ? widget.constraints.maxWidth
          : widget.constraints.constrainWidth(widget.minWidth);
    } else {
      _width = double.infinity;
    }

    _height = max(widget.constraints.minHeight, widget.minHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: _width,
          height: _height,
          child: widget.child,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownRight,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  if (widget.resizableHorizontally) {
                    _width = (_width + details.delta.dx).clamp(
                      widget.minWidth,
                      widget.constraints.maxWidth,
                    );
                  }

                  if (widget.resizableVertically) {
                    _height = (_height + details.delta.dy).clamp(
                      widget.minHeight,
                      widget.constraints.maxHeight,
                    );
                  }
                });
              },
              child: VoicesAssets.images.dragger.buildIcon(size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
