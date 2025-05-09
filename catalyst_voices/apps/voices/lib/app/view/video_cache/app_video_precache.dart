import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class AppVideoPrecache extends StatefulWidget {
  final Widget child;

  const AppVideoPrecache({
    super.key,
    required this.child,
  });

  @override
  State<AppVideoPrecache> createState() => _AppVideoPrecacheState();
}

class _AppVideoPrecacheState extends State<AppVideoPrecache> {
  late final VideoManager _manager;
  Future<void>? _precacheFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _precacheFuture,
      builder: (context, snapshot) {
        final offstage = snapshot.connectionState == ConnectionState.waiting &&
            !_manager.isInitialized;

        if (offstage) {
          return const Offstage();
        }

        return VideoManagerScope(
          manager: _manager,
          child: widget.child,
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);

    _precacheFuture ??= Future.microtask(() async {
      await _manager.resetCacheIfNeeded(theme);
      await _precacheVideos();
    });
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _manager = VideoManager();
  }

  Future<void> _precacheVideos() {
    return _manager.precacheVideos(
      context,
      assets: [
        VoicesAssets.videos.heroDesktop,
      ],
      package: 'catalyst_voices_assets',
    );
  }
}
