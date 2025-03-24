import 'dart:async';
import 'dart:ui';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A full screen overlay that blurs the background
/// and shows a loading animation at the center.
///
/// The overlay is always shown for a minimum duration even when
/// [show] is false, this mechanism ensures that animations are smooth.
class VoicesLoadingOverlay extends StatefulWidget {
  final bool show;

  const VoicesLoadingOverlay({
    super.key,
    required this.show,
  });

  @override
  State<VoicesLoadingOverlay> createState() => _VoicesLoadingOverlayState();
}

class _VoicesLoadingOverlayState extends State<VoicesLoadingOverlay> {
  static const Duration _minimumShowDuration = Duration(seconds: 1);

  Timer? _timer;
  late bool _show;
  DateTime? _showingSince;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !_show,
      child: TickerMode(
        enabled: _show,
        child: AbsorbPointer(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colors.onSurfaceNeutral016.withAlpha(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
            ),
          ),
        ),
      ),
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
  void initState() {
    super.initState();
    _show = widget.show;
  }

  void _hideNow() {
    setState(() {
      _timer?.cancel();
      _show = false;
      _showingSince = null;
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
      _timer = Timer(remainingDuration, _hideNow);
    }
  }

  void _showNow() {
    setState(() {
      _timer?.cancel();
      _show = true;
      _showingSince = DateTimeExt.now();
    });
  }
}
