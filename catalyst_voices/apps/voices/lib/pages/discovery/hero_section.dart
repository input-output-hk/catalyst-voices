import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isProposer;
  const HeroSection({
    super.key,
    required this.controller,
    required this.isProposer,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      fit: StackFit.passthrough,
      children: [
        _Background(
          controller: controller,
        ),
        _Foreground(
          isProposer: isProposer,
        ),
      ],
    );
  }
}

class _Foreground extends StatelessWidget {
  final bool isProposer;

  const _Foreground({
    required this.isProposer,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 120,
      bottom: 64,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 450,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.heroSectionTitle,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.projectCatalystDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                VoicesFilledButton(
                  onTap: () {
                    // TODO(LynxxLynx): implement redirect to current campaign
                  },
                  child: Text(context.l10n.viewCurrentCampaign),
                ),
                const SizedBox(width: 8),
                Offstage(
                  offstage: !isProposer,
                  child: VoicesOutlinedButton(
                    onTap: () {
                      // TODO(LynxxLynx): implement redirect to my proposals
                    },
                    child: Text(context.l10n.myProposals),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
