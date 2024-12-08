import 'dart:async';

import 'package:catalyst_voices/pages/campaign/admin_tools/campaign_admin_tools_dialog.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "events" tab of the [CampaignAdminToolsDialog].
class CampaignAdminToolsEventsTab extends StatefulWidget {
  const CampaignAdminToolsEventsTab({super.key});

  @override
  State<CampaignAdminToolsEventsTab> createState() =>
      _CampaignAdminToolsEventsTabState();
}

class _CampaignAdminToolsEventsTabState
    extends State<CampaignAdminToolsEventsTab> {
  static const _defaultStageTransitionDelay = Duration(seconds: 5);

  Timer? _stageTimer;
  DateTime? _stageTransitionAt;
  Duration _stageTransitionDelay = _defaultStageTransitionDelay;

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AdminToolsCubit, AdminToolsState, CampaignStage>(
      selector: (state) => state.campaignStage,
      builder: (context, stage) {
        return Column(
          children: [
            Expanded(
              child: _CampaignStatusChooser(
                selectedStage: stage,
                onStageSelected: _onStageSelected,
              ),
            ),
            _EventTimelapseControls(
              nextStageTransitionAt: _stageTransitionAt,
              stageTransitionDelay: _stageTransitionDelay,
              onPreviousStage: _canSelectPreviousStage(stage)
                  ? () => _onPreviousStage(stage)
                  : null,
              onNextStage:
                  _canSelectNextStage(stage) ? () => _onNextStage(stage) : null,
              onTransitionDelayChanged: _onTransitionDelayChanged,
            ),
          ],
        );
      },
    );
  }

  void _onStageSelected(CampaignStage stage) {
    setState(() {
      _stageTimer?.cancel();
      _stageTimer = Timer(
        _stageTransitionDelay,
        () => _updateStage(stage),
      );
      _stageTransitionAt = DateTimeExt.now().add(_stageTransitionDelay);
    });
  }

  bool _canSelectPreviousStage(CampaignStage stage) {
    // draft stage is not supported

    final previousIndex = stage.index - 1;
    return previousIndex > CampaignStage.draft.index;
  }

  bool _canSelectNextStage(CampaignStage stage) {
    final nextIndex = stage.index + 1;
    return nextIndex < CampaignStage.values.length;
  }

  void _onPreviousStage(CampaignStage currentStage) {
    if (!_canSelectPreviousStage(currentStage)) return;

    _onStageSelected(CampaignStage.values[currentStage.index - 1]);
  }

  void _onNextStage(CampaignStage currentStage) {
    if (!_canSelectNextStage(currentStage)) return;

    _onStageSelected(CampaignStage.values[currentStage.index + 1]);
  }

  void _updateStage(CampaignStage stage) {
    context.read<AdminToolsCubit>().updateCampaignStage(stage);

    setState(() {
      _stageTransitionAt = null;
    });
  }

  void _onTransitionDelayChanged(Duration delay) {
    setState(() {
      _stageTransitionDelay = delay;
    });
  }
}

class _CampaignStatusChooser extends StatelessWidget {
  final CampaignStage selectedStage;
  final ValueChanged<CampaignStage> onStageSelected;

  const _CampaignStatusChooser({
    required this.selectedStage,
    required this.onStageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          for (final stage in CampaignStage.values)
            if (stage != CampaignStage.draft)
              _EventItem(
                stage: stage,
                isActive: stage == selectedStage,
                onTap: () => onStageSelected(stage),
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final CampaignStage stage;
  final bool isActive;
  final VoidCallback onTap;

  const _EventItem({
    required this.stage,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colors.textOnPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
        child: Row(
          children: [
            _icon.buildIcon(
              size: 24,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _text(context.l10n),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: color,
                    ),
              ),
            ),
            if (isActive)
              Text(
                context.l10n.active.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: color,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  SvgGenImage get _icon => switch (stage) {
        CampaignStage.draft => VoicesAssets.icons.clock,
        CampaignStage.scheduled => VoicesAssets.icons.clock,
        CampaignStage.live => VoicesAssets.icons.flag,
        CampaignStage.completed => VoicesAssets.icons.calendar,
      };

  String _text(VoicesLocalizations l10n) => switch (stage) {
        CampaignStage.draft => l10n.campaignPreviewEventBefore,
        CampaignStage.scheduled => l10n.campaignPreviewEventBefore,
        CampaignStage.live => l10n.campaignPreviewEventDuring,
        CampaignStage.completed => l10n.campaignPreviewEventAfter,
      };
}

class _EventTimelapseControls extends StatefulWidget {
  final DateTime? nextStageTransitionAt;
  final Duration stageTransitionDelay;
  final VoidCallback? onPreviousStage;
  final VoidCallback? onNextStage;
  final ValueChanged<Duration> onTransitionDelayChanged;

  const _EventTimelapseControls({
    required this.nextStageTransitionAt,
    required this.stageTransitionDelay,
    required this.onPreviousStage,
    required this.onNextStage,
    required this.onTransitionDelayChanged,
  });

  @override
  State<_EventTimelapseControls> createState() =>
      _EventTimelapseControlsState();
}

class _EventTimelapseControlsState extends State<_EventTimelapseControls> {
  final _timerController = TextEditingController();
  Timer? _refreshTimer;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();

    _refresh();
    _restartRefreshTimer();
  }

  @override
  void didUpdateWidget(_EventTimelapseControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refresh();
    _restartRefreshTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.rewind.buildIcon(),
              onTap: widget.onPreviousStage,
              child: Text(context.l10n.previous),
            ),
          ),
          Container(
            width: 60,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _timerController,
              onChanged: (_) => _onTransitionDelayChanged(),
              enabled: _enabled,
              decoration: null,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: VoicesTextButton(
              leading: VoicesAssets.icons.fastForward.buildIcon(),
              onTap: widget.onNextStage,
              child: Text(context.l10n.next),
            ),
          ),
        ],
      ),
    );
  }

  void _restartRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _refresh(),
    );
  }

  void _refresh() {
    final now = DateTimeExt.now();
    final nextStageTransitionAt = widget.nextStageTransitionAt;

    if (nextStageTransitionAt != null && nextStageTransitionAt.isAfter(now)) {
      final remainingDelay = nextStageTransitionAt.difference(now);
      _updateTimerController(remainingDelay, enabled: false);
    } else {
      _updateTimerController(widget.stageTransitionDelay, enabled: true);
    }
  }

  void _updateTimerController(Duration duration, {required bool enabled}) {
    // only update if the duration is different,
    // otherwise we might be overwriting local user edits
    if (_stageTransitionDelay != duration) {
      final seconds =
          (duration.inMilliseconds / Duration.millisecondsPerSecond).ceil();
      final text = '${seconds}s';
      _timerController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (enabled != _enabled) {
      setState(() {
        _enabled = enabled;
      });
    }
  }

  void _onTransitionDelayChanged() {
    final duration = _stageTransitionDelay;
    if (duration != null && duration != widget.stageTransitionDelay) {
      widget.onTransitionDelayChanged(duration);
    }
  }

  Duration? get _stageTransitionDelay {
    final cleanedString =
        _timerController.text.replaceAll('s', '').replaceAll(' ', '');
    final seconds = int.tryParse(cleanedString);
    return seconds != null ? Duration(seconds: seconds) : null;
  }
}
