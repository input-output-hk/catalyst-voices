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
  late final VideoPlayerController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      widget.asset,
      package: widget.assetPackageName,
    );
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
}

class _Background extends StatefulWidget {
  final VideoPlayerController controller;
  const _Background({
    required this.controller,
  });

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
  @override
  void initState() {
    super.initState();
    unawaited(_initalizedVideoPlayer());
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 650),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller.value.size.width,
                height: widget.controller.value.size.height,
                child: VideoPlayer(widget.controller),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _initalizedVideoPlayer() async {
    await widget.controller.initialize().then((_) async {
      await widget.controller.setVolume(0);
      await widget.controller.play();
      await widget.controller.setLooping(true);
    });

    setState(() {});
  }
}
