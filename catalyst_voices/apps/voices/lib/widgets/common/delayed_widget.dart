import 'package:flutter/material.dart';

/// Makes [child] not visible for first [delay]. This is useful when
/// loading content and you don't want jumping progress indicator.
class DelayedWidget extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const DelayedWidget({
    super.key,
    this.delay = const Duration(milliseconds: 300),
    required this.child,
  });

  @override
  State<DelayedWidget> createState() => _DelayedWidgetState();
}

class _DelayedWidgetState extends State<DelayedWidget> {
  Future<void>? _future;

  @override
  void initState() {
    super.initState();

    _future = Future.delayed(widget.delay);
  }

  @override
  void didUpdateWidget(DelayedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delay != oldWidget.delay) {
      _future = Future.delayed(widget.delay);
    }
  }

  @override
  void dispose() {
    _future = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Offstage(
          offstage: snapshot.connectionState != ConnectionState.done,
          child: widget.child,
        );
      },
    );
  }
}
