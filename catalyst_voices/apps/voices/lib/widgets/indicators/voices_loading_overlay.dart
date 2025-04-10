import 'dart:async';
import 'dart:ui';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A full screen overlay that blurs the background
/// and shows a loading animation at the center.
///
/// The overlay once shown is displayed for at least a minimum duration,
/// this mechanism ensures that animations are smooth.
class VoicesLoadingOverlay extends StatefulWidget {
  final bool show;

  const VoicesLoadingOverlay({
    super.key,
    required this.show,
  });

  @override
  State<VoicesLoadingOverlay> createState() => _VoicesLoadingOverlayState();
}

class _Overlay extends StatelessWidget {
  const _Overlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colors.onSurfaceNeutral016.withAlpha(50),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: VoicesAssets.lottie.voicesLoader.buildLottie(
            width: 92,
            height: 92,
            repeat: true,
          ),
        ),
      ),
    );
  }
}

class _VoicesLoadingOverlayState extends State<VoicesLoadingOverlay>
    with SingleTickerProviderStateMixin {
  static const Duration _minimumShowDuration = Duration(milliseconds: 600);

  late final AnimationController _fadeInAnimController;

  Timer? _timer;
  DateTime? _showingSince;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeInAnimController,
      builder: (context, child) {
        final isShown = !_fadeInAnimController.isDismissed;
        return Offstage(
          offstage: !isShown,
          child: AbsorbPointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Opacity(
                opacity: _fadeInAnimController.value,
                child: TickerMode(
                  enabled: isShown,
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
      child: const _Overlay(),
    );
  }

  @override
  void didUpdateWidget(VoicesLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _showNow();
      } else {
        _scheduleHide();
      }
    }
  }

  @override
  void dispose() {
    _fadeInAnimController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fadeInAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _showingSince = widget.show ? DateTimeExt.now() : null;

    if (widget.show) {
      _fadeInAnimController.value = _fadeInAnimController.upperBound;
    }
  }

  void _hideNow() {
    setState(() {
      _timer?.cancel();
      _showingSince = null;
      _fadeInAnimController.reverse();
    });
  }

  void _scheduleHide() {
    final showingSince = _showingSince;
    if (showingSince == null) {
      _hideNow();
      return;
    }

    final hasBeenShownFor = DateTimeExt.now().difference(showingSince);
    if (hasBeenShownFor >= _minimumShowDuration) {
      _hideNow();
    } else {
      final remainingDuration = _minimumShowDuration - hasBeenShownFor;
      _timer?.cancel();
      _timer = Timer(remainingDuration, _hideNow);
    }
  }

  void _showNow() {
    setState(() {
      _timer?.cancel();
      _showingSince = DateTimeExt.now();
      _fadeInAnimController.forward();
    });
  }
}
