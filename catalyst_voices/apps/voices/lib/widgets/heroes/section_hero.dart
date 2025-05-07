import 'dart:async';

import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatefulWidget {
  final AlignmentGeometry alignment;
  final String asset;
  final String? assetPackageName;
  final Widget child;

  const HeroSection({
    super.key,
    this.alignment = Alignment.bottomLeft,
    required this.asset,
    this.assetPackageName,
    required this.child,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _Background extends StatelessWidget {
  final VideoPlayerController controller;
  const _Background({
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 650),
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                key: const Key('HeroBackgroundVideo'),
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _HeroSectionState extends State<HeroSection>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;

  @override
  bool get wantKeepAlive => true;

  VideoPlayerController get _effectiveController {
    return _controller ??
        AssetsPrecacheService.instance.getVideoController(widget.asset) ??
        VideoPlayerController.asset(
          widget.asset,
          package: widget.assetPackageName,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      fit: StackFit.passthrough,
      alignment: widget.alignment,
      children: [
        _Background(
          controller: _effectiveController,
        ),
        Align(
          alignment: widget.alignment,
          child: widget.child,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.asset != widget.asset ||
        oldWidget.assetPackageName != widget.assetPackageName) {
      unawaited(_disposeAndReinitializeVideoPlayer());
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    _controller = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AssetsPrecacheService.instance.getVideoController(widget.asset) ??
            VideoPlayerController.asset(
              widget.asset,
              package: widget.assetPackageName,
            );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _initalizedVideoPlayer();
      }
    });
  }

  Future<void> _disposeAndReinitializeVideoPlayer() async {
    if (mounted) {
      await _controller?.dispose();
    }
    if (mounted) {
      _controller = VideoPlayerController.asset(
        widget.asset,
        package: widget.assetPackageName,
      );
      await _initalizedVideoPlayer();
    }
  }

  Future<void> _initalizedVideoPlayer() async {
    await _controller?.initialize().then((_) async {
      await _controller?.setVolume(0);
      await _controller?.play();
      await _controller?.setLooping(true);
    });
    if (mounted) {
      setState(() {});
    }
  }
}
