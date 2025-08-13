import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:video_player/video_player.dart';

/// Caches [VideoPlayerController] so it can be initialized and reused in different parts
/// of app.
class VideoManager extends ValueNotifier<VideoManagerState> {
  var _isInitialized = Completer<bool>();

  final _lock = Lock();

  VideoManager() : super(const VideoManagerState(controllers: {}));

  Future<bool> get isInitialized => _isInitialized.future;

  Future<VideoPlayerController> createOrReinitializeController(
    VideoCacheKey asset,
  ) async {
    final key = _createKey(asset.name, asset.package);
    if (value.controllers.containsKey(key)) {
      final controller = value.controllers[key]!;

      // Re-initialize is needed to properly connect the cached controller
      // to a new VideoPlayer widget instance, even though controller state remains unchanged
      // it has to do with internal logic of VideoPlayer widget that is not exposed to us
      await controller.initialize();
      await controller.play();
      return controller;
    }
    final controller = await _initializeController(asset.name, package: asset.package);

    final newControllers = Map.of(value.controllers)..[key] = controller;

    value = value.copyWith(controllers: newControllers);

    return controller;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Future<void> precacheVideos(
    BuildContext context, {
    required VideoPrecacheAssets videoAssets,
  }) {
    return _lock.synchronized<void>(() async {
      if (_isInitialized.isCompleted) return;

      final newControllers = Map.of(value.controllers);

      await Future.wait(
        videoAssets.assets.map((asset) async {
          final key = _createKey(asset, videoAssets.package);
          if (value.controllers.containsKey(key)) return;

          final controller = await _initializeController(asset, package: videoAssets.package);
          newControllers[key] = controller;
        }),
      );

      value = value.copyWith(controllers: newControllers);

      if (!_isInitialized.isCompleted) _isInitialized.complete(true);
    });
  }

  Future<void> resetCacheIfNeeded(ThemeData theme) async {
    if (value.brightness != theme.brightness) {
      // Handle case when caching is in progress and someone awaits completion.
      // For such case we're completing _isInitialized early.
      if (!_isInitialized.isCompleted && _lock.inLock) _isInitialized.complete(false);

      _isInitialized = Completer();

      _disposeControllers();

      value = value.copyWith(
        controllers: {},
        brightness: Optional(theme.brightness),
      );
    }
  }

  String _createKey(String asset, String? package) {
    return '$asset${package != null ? "_$package" : "_unknown"}';
  }

  void _disposeControllers() {
    final controllers = List.of(value.controllers.values);
    for (final controller in controllers) {
      unawaited(controller.dispose());
    }
  }

  Future<VideoPlayerController> _initializeController(
    String asset, {
    String? package,
  }) async {
    final controller = VideoPlayerController.asset(
      asset,
      package: package,
    );

    await controller.initialize();
    // TODO(LynxLynxx): extract this to public method so interested widget can
    // control video playback
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.play();

    return controller;
  }
}

/// Makes [VideoManager] accessible via [BuildContext].
class VideoManagerScope extends InheritedWidget {
  final VideoManager manager;

  const VideoManagerScope({
    required super.child,
    required this.manager,
    super.key,
  });

  @override
  bool updateShouldNotify(VideoManagerScope oldWidget) {
    return manager != oldWidget.manager;
  }

  static VideoManager of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoManagerScope>()!.manager;
  }
}

/// State of [VideoManager].
class VideoManagerState extends Equatable {
  final Map<String, VideoPlayerController> controllers;
  final Brightness? brightness;

  const VideoManagerState({
    required this.controllers,
    this.brightness,
  });

  @override
  List<Object?> get props => [controllers, brightness];

  VideoManagerState copyWith({
    Map<String, VideoPlayerController>? controllers,
    Optional<Brightness>? brightness,
  }) {
    return VideoManagerState(
      controllers: controllers ?? this.controllers,
      brightness: brightness.dataOr(this.brightness),
    );
  }
}
