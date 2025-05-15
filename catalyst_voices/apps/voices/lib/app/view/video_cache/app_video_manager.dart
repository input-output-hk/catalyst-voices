import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoManager extends ValueNotifier<VideoManagerState> {
  bool _isInitialized = false;

  VideoManager() : super(const VideoManagerState(controllers: {}));

  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    unawaited(_disposeControllers());
    super.dispose();
  }

  Future<VideoPlayerController> getOrCreateController(
    VideoCacheKey asset,
  ) async {
    final key = _createKey(asset.name, asset.package);
    if (value.controllers.containsKey(key)) {
      return value.controllers[key]!;
    }
    final controller =
        await _initializeController(asset.name, package: asset.package);

    final newControllers = Map.of(value.controllers)..[key] = controller;

    value = value.copyWith(controllers: newControllers);

    return controller;
  }

  Future<void> precacheVideos(
    BuildContext context, {
    required VideoPrecacheAssets videoAssets,
  }) async {
    if (_isInitialized) return;

    final newControllers = Map.of(value.controllers);

    await Future.wait(
      videoAssets.assets.map((asset) async {
        final key = _createKey(asset, videoAssets.package);
        if (value.controllers.containsKey(key)) return;

        final controller =
            await _initializeController(asset, package: videoAssets.package);
        newControllers[key] = controller;
      }),
    );

    value = value.copyWith(controllers: newControllers);
    _isInitialized = true;
  }

  Future<void> resetCacheIfNeeded(ThemeData theme) async {
    if (value.brightness != theme.brightness) {
      _isInitialized = false;
      await _disposeControllers();
      value = value.copyWith(brightness: Optional(theme.brightness));
    }
  }

  String _createKey(String asset, String? package) {
    return '$asset${package != null ? "_$package" : "_unknown"}';
  }

  Future<void> _disposeControllers() async {
    for (final controller in value.controllers.values) {
      await controller.dispose();
    }
    value = value.copyWith(controllers: {});
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
    return context
        .dependOnInheritedWidgetOfExactType<VideoManagerScope>()!
        .manager;
  }
}

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
