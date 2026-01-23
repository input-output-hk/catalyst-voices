import 'package:catalyst_voices/widgets/indicators/global_sync/widgets/global_sync_indicator_banner.dart';
import 'package:flutter/material.dart';

/// A global sync indicator that displays an indefinite horizontal progress bar
/// at the top of the screen.
class GlobalSyncIndicator extends StatelessWidget {
  final Widget child;

  const GlobalSyncIndicator({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GlobalSyncIndicatorBanner(),
        Expanded(child: child),
      ],
    );
  }
}
