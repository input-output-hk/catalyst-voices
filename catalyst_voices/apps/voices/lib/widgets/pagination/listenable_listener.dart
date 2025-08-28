import 'package:flutter/widgets.dart';

/// A widget that calls [listener] when the given [Listenable] changes value.
class ListenableListener extends StatefulWidget {
  /// The [Listenable] to which this widget is listening.
  ///
  /// Commonly an [Animation] or a [ChangeNotifier].
  final Listenable listenable;

  /// Called every time the [listenable] changes value.
  final VoidCallback? listener;

  /// The widget below this widget in the tree.
  final Widget child;

  const ListenableListener({
    required this.listenable,
    required this.child,
    this.listener,
    super.key,
  });

  @override
  State<ListenableListener> createState() => _ListenableListenerState();
}

class _ListenableListenerState extends State<ListenableListener> {
  Listenable get _listenable => widget.listenable;

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void didUpdateWidget(ListenableListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handleChange);
      if (widget.listener != null) {
        _listenable.addListener(_handleChange);
      }
    }
  }

  @override
  void dispose() {
    _listenable.removeListener(_handleChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.listener != null) {
      _listenable.addListener(_handleChange);
      _handleChange();
    }
  }

  void _handleChange() {
    widget.listener?.call();
  }
}
