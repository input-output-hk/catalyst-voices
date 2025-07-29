import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class DefaultSpaceEndDrawerConfig extends SpaceEndDrawerConfig {
  const DefaultSpaceEndDrawerConfig() : super(phaseType: CampaignPhaseType.proposalSubmission);
}

sealed class SpaceEndDrawerConfig extends Equatable implements SpaceEndDrawerControl {
  @override
  final CampaignPhaseType phaseType;
  final Widget? _upcomingEndDrawer;
  final Widget? _activeEndDrawer;
  final Widget? _postEndDrawer;
  final Widget? _defaultEndDrawer;

  const SpaceEndDrawerConfig({
    required this.phaseType,
    Widget? upcomingEndDrawer,
    Widget? activeEndDrawer,
    Widget? postEndDrawer,
    Widget? defaultEndDrawer = const OpportunitiesDrawer(),
  })  : _upcomingEndDrawer = upcomingEndDrawer,
        _activeEndDrawer = activeEndDrawer,
        _postEndDrawer = postEndDrawer,
        _defaultEndDrawer = defaultEndDrawer;

  Widget? get activeEndDrawer => _activeEndDrawer ?? _defaultEndDrawer;

  Widget? get postEndDrawer => _postEndDrawer ?? _defaultEndDrawer;

  @override
  List<Object?> get props => [
        _upcomingEndDrawer,
        _activeEndDrawer,
        _postEndDrawer,
        _defaultEndDrawer,
      ];

  Widget? get upcomingEndDrawer => _upcomingEndDrawer ?? _defaultEndDrawer;
}

final class SpaceEndDrawerControl {
  final CampaignPhaseType phaseType;

  const SpaceEndDrawerControl(this.phaseType);
}

final class VotingSpaceEndDrawerConfig extends SpaceEndDrawerConfig {
  const VotingSpaceEndDrawerConfig()
      : super(
          phaseType: CampaignPhaseType.communityVoting,
          // TODO(LynxxLynx): add VotingListDrawer here when implemented
          defaultEndDrawer: const SizedBox.shrink(),
        );
}
