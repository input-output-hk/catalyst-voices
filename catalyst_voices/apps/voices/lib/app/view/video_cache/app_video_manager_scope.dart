import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:flutter/widgets.dart';

/// Inserts [VideoManagerScope] into widget tree with
/// manager singleton instance from [Dependencies].
class AppVideoManagerScope extends StatefulWidget {
  final Widget child;

  const AppVideoManagerScope({
    super.key,
    required this.child,
  });

  @override
  State<AppVideoManagerScope> createState() => _AppVideoManagerScopeState();
}

class _AppVideoManagerScopeState extends State<AppVideoManagerScope> {
  late final VideoManager _manager;

  @override
  Widget build(BuildContext context) {
    return VideoManagerScope(
      manager: _manager,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _manager = Dependencies.instance.get<VideoManager>();
  }
}
