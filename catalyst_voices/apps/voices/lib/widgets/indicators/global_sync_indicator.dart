import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

/// A global sync indicator that displays an indefinite horizontal progress bar
/// at the top of the screen.
class GlobalSyncIndicator extends StatefulWidget {
  final Widget child;

  const GlobalSyncIndicator({
    super.key,
    required this.child,
  });

  @override
  State<GlobalSyncIndicator> createState() => _GlobalSyncIndicatorState();
}

class _GlobalSyncIndicatorState extends State<GlobalSyncIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        BlocSelector<SyncIndicatorCubit, SyncIndicatorState, bool>(
          selector: (state) => state.isSyncing,
          builder: (context, isSyncing) => _Indicator(isSyncing: isSyncing),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SyncIndicatorCubit>().init();
  }
}

class _Indicator extends StatelessWidget {
  final bool isSyncing;

  const _Indicator({required this.isSyncing});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: isSyncing
          ? const VoicesLinearProgressIndicator(showTrack: false)
          : const SizedBox.shrink(),
    );
  }
}
