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
  late VideoPlayerController _controller;

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
      await _initalizedVideoPlayer();
    });
  }

  @override
  Future<void> didUpdateWidget(covariant HeroSection oldWidget) async {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.asset != widget.asset ||
        oldWidget.assetPackageName != widget.assetPackageName) {
      await _controller.dispose();
      _controller = VideoPlayerController.asset(
        widget.asset,
        package: widget.assetPackageName,
      );
      await _initalizedVideoPlayer();
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
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
          controller: _controller,
        ),
        Align(
          alignment: widget.alignment,
          child: widget.child,
        ),
      ],
    );
  }

  Future<void> _initalizedVideoPlayer() async {
    if (mounted) {
      await _controller.initialize().then((_) async {
        await _controller.setVolume(0);
        await _controller.play();
        await _controller.setLooping(true);
      });

      setState(() {});
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
