import 'package:flutter/material.dart';

class AppActiveStateListener extends StatefulWidget {
  final Widget child;

  const AppActiveStateListener({
    super.key,
    required this.child,
  });

  @override
  State<AppActiveStateListener> createState() => _AppActiveStateListenerState();
}

class _AppActiveStateListenerState extends State<AppActiveStateListener> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: _handleResumed,
      onInactive: _handleInactive,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> _handleResumed() async {
    //
  }

  Future<void> _handleInactive() async {
    //
  }
}
