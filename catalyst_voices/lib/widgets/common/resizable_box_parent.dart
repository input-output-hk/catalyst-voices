import 'dart:math';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/widgets.dart';

class ResizableBoxParent extends StatelessWidget {
  final bool resizable;
  final Widget child;

  const ResizableBoxParent({
    required this.resizable,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!resizable) {
      return child;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _ResizableBox(
          constraints: constraints,
          child: child,
        );
      },
    );
  }
}

class _ResizableBox extends StatefulWidget {
  final BoxConstraints constraints;
  final Widget child;

  const _ResizableBox({
    required this.constraints,
    required this.child,
  });

  @override
  State<_ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<_ResizableBox> {
  static const double _minWidth = 40;
  static const double _minHeight = 40;

  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();

    _width = widget.constraints.maxWidth != double.infinity
        ? widget.constraints.maxWidth
        : widget.constraints.constrainWidth(_minWidth);

    _height = max(widget.constraints.minHeight, _minHeight);
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
                  _width = (_width + details.delta.dx).clamp(
                    _minWidth,
                    widget.constraints.maxWidth,
                  );

                  _height = (_height + details.delta.dy).clamp(
                    _minHeight,
                    widget.constraints.maxHeight,
                  );
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
