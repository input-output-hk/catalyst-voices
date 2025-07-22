import 'dart:async';

import 'package:catalyst_voices/pages/campaign_phase_aware/error_campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/loading_campaign_phase_aware.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

typedef CampaignPhaseAwareBuilder = Widget Function(BuildContext context, CampaignPhase phase);

class CampaignPhaseAware extends StatelessWidget {
  final CampaignPhaseType phase;
  final CampaignPhaseAwareBuilder? upcoming;
  final CampaignPhaseAwareBuilder? active;
  final CampaignPhaseAwareBuilder? post;
  final CampaignPhaseAwareBuilder? orElse;

  factory CampaignPhaseAware.orElse({
    Key? key,
    required CampaignPhaseType phase,
    required CampaignPhaseAwareBuilder orElse,
    CampaignPhaseAwareBuilder? upcoming,
    CampaignPhaseAwareBuilder? active,
    CampaignPhaseAwareBuilder? post,
  }) {
    return CampaignPhaseAware._(
      key: key,
      phase: phase,
      orElse: orElse,
      upcoming: upcoming,
      active: active,
      post: post,
    );
  }

  factory CampaignPhaseAware.when({
    Key? key,
    required CampaignPhaseType phase,
    required CampaignPhaseAwareBuilder upcoming,
    required CampaignPhaseAwareBuilder active,
    required CampaignPhaseAwareBuilder post,
  }) {
    return CampaignPhaseAware._(
      key: key,
      phase: phase,
      upcoming: upcoming,
      active: active,
      post: post,
    );
  }

  const CampaignPhaseAware._({
    super.key,
    required this.phase,
    this.upcoming,
    this.active,
    this.post,
    this.orElse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignPhaseAwareCubit, CampaignPhaseAwareState>(
      builder: (context, state) {
        return switch (state) {
          ErrorCampaignPhaseAwareState(:final error) => ErrorCampaignPhaseAware(error: error),
          LoadingCampaignPhaseAwareState() => const LoadingCampaignPhaseAware(),
          DataCampaignPhaseAwareState(:final campaign) => _CampaignPhaseAwareBuilder(
              key: const Key('CampaignPhaseAwareBuilder'),
              campaign: campaign,
              phase: phase,
              upcoming: upcoming,
              active: active,
              post: post,
              orElse: orElse,
            ),
        };
      },
    );
  }
}

class _CampaignPhaseAwareBuilder extends StatefulWidget {
  final Campaign campaign;
  final CampaignPhaseType phase;
  final CampaignPhaseAwareBuilder? upcoming;
  final CampaignPhaseAwareBuilder? active;
  final CampaignPhaseAwareBuilder? post;
  final CampaignPhaseAwareBuilder? orElse;

  const _CampaignPhaseAwareBuilder({
    super.key,
    required this.campaign,
    required this.phase,
    required this.upcoming,
    required this.active,
    required this.post,
    required this.orElse,
  });

  @override
  State<_CampaignPhaseAwareBuilder> createState() => _CampaignPhaseAwareBuilderState();
}

class _CampaignPhaseAwareBuilderState extends State<_CampaignPhaseAwareBuilder> {
  Timer? _phaseTimer;

  Duration? get _phaseDuration {
    final now = DateTimeExt.now();
    final phaseDate = switch (_phaseState.status) {
      CampaignPhaseStatus.upcoming => _phaseState.phase.timeline.from,
      CampaignPhaseStatus.active => _phaseState.phase.timeline.to,
      _ => null
    };

    if (phaseDate == null) return null;
    final duration = phaseDate.difference(now);
    return duration.isNegative ? null : duration;
  }

  CampaignPhaseState get _phaseState => widget.campaign.phaseStateTo(widget.phase);

  @override
  Widget build(BuildContext context) {
    return switch (_phaseState.status) {
      CampaignPhaseStatus.upcoming when widget.upcoming != null =>
        widget.upcoming!(context, _phaseState.phase),
      CampaignPhaseStatus.active when widget.active != null =>
        widget.active!(context, _phaseState.phase),
      CampaignPhaseStatus.post when widget.post != null => widget.post!(context, _phaseState.phase),
      _ when widget.orElse != null => widget.orElse!(context, _phaseState.phase),
      _ => throw ArgumentError(
          'No builder provided for phase status ${_phaseState.status}',
        ),
    };
  }

  @override
  void didUpdateWidget(_CampaignPhaseAwareBuilder oldWidget) {
    if (oldWidget.phase != widget.phase || oldWidget.campaign != widget.campaign) {
      _setupTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  void _setupTimer() {
    _phaseTimer?.cancel();
    _phaseTimer = null;

    final duration = _phaseDuration;
    if (duration != null) {
      _phaseTimer = Timer(duration, () {
        if (mounted) {
          setState(() {});
          _setupTimer();
        }
      });
    }
  }
}
