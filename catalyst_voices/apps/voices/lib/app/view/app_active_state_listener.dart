import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';

/// Observes application lifecycle and updates any dependencies that are
/// interested in app state.
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
  UserService? _userService;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _userService = null;
    _listener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _userService = Dependencies.instance.isRegistered<UserService>()
        ? Dependencies.instance.get<UserService>()
        : null;
    _listener = AppLifecycleListener(
      onResume: _handleResumed,
      onInactive: _handleInactive,
    );
  }

  Future<void> _handleInactive() async {
    _userService?.isActive = false;
  }

  Future<void> _handleResumed() async {
    _userService?.isActive = true;
  }
}
