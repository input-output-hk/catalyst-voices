import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatefulWidget {
  final AlignmentGeometry alignment;
  final Widget child;
  final String asset;
  final String? assetPackageName;

  const HeroSection({
    super.key,
    this.alignment = Alignment.bottomLeft,
    required this.child,
    required this.asset,
    this.assetPackageName,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;

  VideoPlayerController get _effectiveController {
    return _controller ??
        (_controller ??= VideoPlayerController.asset(
          widget.asset,
          package: widget.assetPackageName,
        ));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      widget.asset,
      package: widget.assetPackageName,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _initalizedVideoPlayer();
      }
    });
  }

  @override
  void didUpdateWidget(covariant HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.asset != widget.asset ||
        oldWidget.assetPackageName != widget.assetPackageName) {
      unawaited(_disposeAndReinitializeVideoPlayer());
    }
  }

  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    super.dispose();
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
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
