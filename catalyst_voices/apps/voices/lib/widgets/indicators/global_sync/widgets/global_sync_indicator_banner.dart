import 'package:catalyst_voices/widgets/indicators/voices_linear_progress_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class GlobalSyncIndicatorBanner extends StatefulWidget {
  const GlobalSyncIndicatorBanner({super.key});

  @override
  State<GlobalSyncIndicatorBanner> createState() => _GlobalSyncIndicatorBannerState();
}

class _Banner extends StatelessWidget {
  final bool show;

  const _Banner({required this.show});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return AnimatedAlign(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
      heightFactor: show ? 1.0 : 0.0,
      child: TickerMode(
        enabled: show,
        child: Material(
          color: colors.elevationsOnSurfaceNeutralLv1White,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Text(
                  context.l10n.globalSyncIndicatorTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textOnPrimaryLevel0,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(child: VoicesLinearProgressIndicator(showTrack: false)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlobalSyncIndicatorBannerState extends State<GlobalSyncIndicatorBanner> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<SyncIndicatorCubit, SyncIndicatorState, bool>(
      selector: (state) => state.isSyncing,
      builder: (context, isSyncing) => _Banner(show: isSyncing),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SyncIndicatorCubit>().init();
  }
}
