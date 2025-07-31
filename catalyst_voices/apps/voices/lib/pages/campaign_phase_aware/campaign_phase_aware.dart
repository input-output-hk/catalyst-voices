import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/error_campaign_phase_aware.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/loading_campaign_phase_aware.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

typedef CampaignPhaseAwareBuilder = Widget Function(
  BuildContext context,
  CampaignPhase phase,
  int fundNumber,
);

class CampaignPhaseAware extends StatelessWidget {
  final CampaignPhaseType phase;
  final CampaignPhaseAwareBuilder? upcoming;
  final CampaignPhaseAwareBuilder? active;
  final CampaignPhaseAwareBuilder? post;
  final CampaignPhaseAwareBuilder? orElse;

  /// Won't show Error and Loading states if true
  final bool showOnlyDataState;

  factory CampaignPhaseAware.orElse({
    Key? key,
    required CampaignPhaseType phase,
    required CampaignPhaseAwareBuilder orElse,
    CampaignPhaseAwareBuilder? upcoming,
    CampaignPhaseAwareBuilder? active,
    CampaignPhaseAwareBuilder? post,
    bool showOnlyDataState = false,
  }) {
    return CampaignPhaseAware._(
      key: key,
      phase: phase,
      orElse: orElse,
      upcoming: upcoming,
      active: active,
      post: post,
      showOnlyDataState: showOnlyDataState,
    );
  }

  factory CampaignPhaseAware.when({
    Key? key,
    required CampaignPhaseType phase,
    required CampaignPhaseAwareBuilder upcoming,
    required CampaignPhaseAwareBuilder active,
    required CampaignPhaseAwareBuilder post,
    bool showOnlyDataState = false,
  }) {
    return CampaignPhaseAware._(
      key: key,
      phase: phase,
      upcoming: upcoming,
      active: active,
      post: post,
      showOnlyDataState: showOnlyDataState,
    );
  }

  const CampaignPhaseAware._({
    super.key,
    required this.phase,
    this.upcoming,
    this.active,
    this.post,
    this.orElse,
    this.showOnlyDataState = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!showOnlyDataState) const _ErrorCampaignPhaseAwareSelector(),
        if (!showOnlyDataState) const _LoadingCampaignPhaseAwareSelector(),
        _DataCampaignPhaseAwareSelector(
          phase: phase,
          upcoming: upcoming,
          active: active,
          post: post,
          orElse: orElse,
        ),
      ],
    );
  }
}

class _CampaignPhaseAwareBuilder extends StatelessWidget {
  final CampaignPhaseStatus status;
  final CampaignPhase phase;
  final int fundNumber;
  final CampaignPhaseAwareBuilder? upcoming;
  final CampaignPhaseAwareBuilder? active;
  final CampaignPhaseAwareBuilder? post;
  final CampaignPhaseAwareBuilder? orElse;

  const _CampaignPhaseAwareBuilder({
    required this.status,
    required this.phase,
    required this.fundNumber,
    required this.upcoming,
    required this.active,
    required this.post,
    required this.orElse,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      CampaignPhaseStatus.upcoming when upcoming != null => upcoming!(context, phase, fundNumber),
      CampaignPhaseStatus.active when active != null => active!(context, phase, fundNumber),
      CampaignPhaseStatus.post when post != null => post!(context, phase, fundNumber),
      _ when orElse != null => orElse!(context, phase, fundNumber),
      _ => throw ArgumentError(
          'No builder provided for phase type $phase',
        ),
    };
  }
}

class _DataCampaignPhaseAwareSelector extends StatelessWidget {
  final CampaignPhaseType phase;
  final CampaignPhaseAwareBuilder? upcoming;
  final CampaignPhaseAwareBuilder? active;
  final CampaignPhaseAwareBuilder? post;
  final CampaignPhaseAwareBuilder? orElse;

  const _DataCampaignPhaseAwareSelector({
    required this.phase,
    this.upcoming,
    this.active,
    this.post,
    this.orElse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignPhaseAwareCubit, CampaignPhaseAwareState,
        (bool, CampaignPhaseState?, int)>(
      selector: (state) {
        if (state is DataCampaignPhaseAwareState) {
          return (true, state.getPhaseStatus(phase), state.fundNumber);
        }
        return (false, null, 0);
      },
      builder: (context, state) {
        if (!state.$1 || state.$2 == null) return const SizedBox.shrink();
        return _CampaignPhaseAwareBuilder(
          status: state.$2!.status,
          phase: state.$2!.phase,
          fundNumber: state.$3,
          upcoming: upcoming,
          active: active,
          post: post,
          orElse: orElse,
        );
      },
    );
  }
}

class _ErrorCampaignPhaseAwareSelector extends StatelessWidget {
  const _ErrorCampaignPhaseAwareSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignPhaseAwareCubit, CampaignPhaseAwareState,
        (bool, LocalizedException?)>(
      selector: (state) => switch (state) {
        ErrorCampaignPhaseAwareState(:final error) => (true, error),
        _ => (false, null)
      },
      builder: (context, state) {
        return Offstage(
          offstage: !state.$1,
          child: ErrorCampaignPhaseAware(error: state.$2),
        );
      },
    );
  }
}

class _LoadingCampaignPhaseAwareSelector extends StatelessWidget {
  const _LoadingCampaignPhaseAwareSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignPhaseAwareCubit, CampaignPhaseAwareState, bool>(
      selector: (state) => switch (state) {
        LoadingCampaignPhaseAwareState() => true,
        _ => false,
      },
      builder: (context, isLoading) {
        return Offstage(
          offstage: !isLoading,
          child: TickerMode(
            enabled: isLoading,
            child: const LoadingCampaignPhaseAware(),
          ),
        );
      },
    );
  }
}
