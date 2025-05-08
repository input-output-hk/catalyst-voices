import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoManager extends ValueNotifier<VideoManagerState> {
  bool _isInitialized = false;

  VideoManager() : super(const VideoManagerState(controllers: {}));

  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    unawaited(_resetControllers());
    super.dispose();
  }

  Future<VideoPlayerController> getOrCreateController(
    String asset, {
    String? package,
  }) async {
    if (value.controllers.containsKey(asset)) {
      return value.controllers[asset]!;
    }
    final controller = await _initializeController(asset, package: package);

    final newControllers =
        Map<String, VideoPlayerController>.from(value.controllers)
          ..[asset] = controller;

    value = value.copyWith(controllers: newControllers);

    return controller;
  }

  Future<void> precacheVideos(
    BuildContext context, {
    required List<String> assets,
    String? package,
  }) async {
    if (_isInitialized) return;

    final newControllers =
        Map<String, VideoPlayerController>.from(value.controllers);

    await Future.wait(
      assets.map((asset) async {
        if (value.controllers.containsKey(asset)) return;

        final controller = await _initializeController(asset, package: package);
        newControllers[asset] = controller;
      }),
    );

    value = value.copyWith(controllers: newControllers);
    _isInitialized = true;
  }

  Future<void> resetCacheIfNeeded(ThemeData theme) async {
    if (value.brightness != theme.brightness) {
      _isInitialized = false;
      await _resetControllers();
      value = value.copyWith(brightness: Optional(theme.brightness));
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
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.play();

    return controller;
  }

  Future<void> _resetControllers() async {
    for (final controller in value.controllers.values) {
      await controller.dispose();
    }
    value = value.copyWith(controllers: {});
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
