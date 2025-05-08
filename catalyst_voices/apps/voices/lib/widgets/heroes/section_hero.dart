import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatelessWidget {
  final AlignmentGeometry alignment;
  final String asset;
  final BoxConstraints constraints;
  final String? assetPackageName;

  final Widget child;

  const HeroSection({
    super.key,
    this.alignment = Alignment.bottomLeft,
    required this.asset,
    this.constraints = const BoxConstraints.tightFor(height: 650),
    this.assetPackageName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: alignment,
      children: [
        _Background(
          asset: asset,
          assetPackage: assetPackageName,
          constraints: constraints,
        ),
        Align(
          alignment: alignment,
          child: child,
        ),
      ],
    );
  }
}

class _Background extends StatefulWidget {
  final String? assetPackage;
  final String asset;
  final BoxConstraints constraints;

  const _Background({
    this.assetPackage,
    required this.asset,
    required this.constraints,
  });

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background>
    with AutomaticKeepAliveClientMixin {
  Future<VideoPlayerController>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ConstrainedBox(
      constraints: widget.constraints,
      child: FutureBuilder<VideoPlayerController>(
        future: _future,
        builder: (context, snapshot) {
          final controller = snapshot.data;

          if (controller == null) {
            return const SizedBox.expand();
          }

          return FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              key: const Key('HeroBackgroundVideo'),
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          );
        },
      ),
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
