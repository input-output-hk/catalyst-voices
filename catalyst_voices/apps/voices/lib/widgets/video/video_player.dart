import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VoicesVideoPlayer extends StatefulWidget {
  final VideoCacheKey asset;
  final BoxFit fit;
  final Clip clipBehavior;

  const VoicesVideoPlayer({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<VoicesVideoPlayer> createState() => _VoicesVideoPlayerState();
}

class _VoicesVideoPlayerState extends State<VoicesVideoPlayer> with AutomaticKeepAliveClientMixin {
  Future<VideoPlayerController>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<VideoPlayerController>(
      future: _future,
      builder: (context, snapshot) {
        final controller = snapshot.data;
        if (controller == null) {
          return const SizedBox.expand();
        }

        return FittedBox(
          fit: widget.fit,
          clipBehavior: widget.clipBehavior,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _future ??= Future.microtask(() async => _getController());
  }

  Future<VideoPlayerController> _getController() {
    return VideoManagerScope.of(context).getOrCreateController(widget.asset);
  }
}
