import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Parameters that can control what is displayed in the app bar.
interface class AppbarControl {
  final bool isAppUnlock;
  final bool isProposer;
  final CampaignPhaseType phaseType;

  const AppbarControl({
    required this.isAppUnlock,
    required this.isProposer,
    required this.phaseType,
  });
}

final class DefaultSpaceAppbarConfig extends SpaceAppbarConfig {
  const DefaultSpaceAppbarConfig({
    super.isAppUnlock = false,
    super.isProposer = false,
    super.phaseType = CampaignPhaseType.projectOnboarding,
  });
}

final class DiscoveryAppbarConfig extends SpaceAppbarConfig {
  DiscoveryAppbarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.proposalSubmission,
  }) : super(
          showAppbarUpcoming: false,
          showAppbarActive: true,
          showAppbarPost: false,
          activeAppbarActions: [
            if (isAppUnlock && isProposer) const CreateProposalButton(),
          ],
        );
}

sealed class SpaceAppbarConfig extends Equatable implements AppbarControl {
  @override
  final bool isAppUnlock;
  @override
  final bool isProposer;
  @override
  final CampaignPhaseType phaseType;

  final bool showAppbarUpcoming;
  final bool showAppbarActive;
  final bool showAppbarPost;

  final List<Widget> _upcomingAppbarActions;
  final List<Widget> _activeAppbarActions;
  final List<Widget> _postAppbarActions;
  final List<Widget> _defaultAppbarActions;

  final Widget? _upcomingAppbarLeading;
  final Widget? _activeAppbarLeading;
  final Widget? _postAppbarLeading;
  final Widget? _defaultAppbarLeading;

  const SpaceAppbarConfig({
    required this.isAppUnlock,
    required this.isProposer,
    required this.phaseType,
    this.showAppbarUpcoming = true,
    this.showAppbarActive = true,
    this.showAppbarPost = true,
    List<Widget> upcomingAppbarActions = const [],
    List<Widget> activeAppbarActions = const [],
    List<Widget> postAppbarActions = const [],
    List<Widget> defaultAppbarActions = const [
      SessionActionHeader(),
      SessionStateHeader(),
    ],
    Widget? upcomingAppbarLeading,
    Widget? activeAppbarLeading,
    Widget? postAppbarLeading,
    Widget? defaultAppbarLeading,
  })  : _upcomingAppbarActions = upcomingAppbarActions,
        _activeAppbarActions = activeAppbarActions,
        _postAppbarActions = postAppbarActions,
        _defaultAppbarActions = defaultAppbarActions,
        _upcomingAppbarLeading = upcomingAppbarLeading,
        _activeAppbarLeading = activeAppbarLeading,
        _postAppbarLeading = postAppbarLeading,
        _defaultAppbarLeading =
            defaultAppbarLeading ?? (isAppUnlock ? const DrawerToggleButton() : null);

  List<Widget> get activeAppbarActions => [..._activeAppbarActions, ..._defaultAppbarActions];

  Widget? get activeAppbarLeading => _activeAppbarLeading ?? _defaultAppbarLeading;

  List<Widget> get postAppbarActions => [..._postAppbarActions, ..._defaultAppbarActions];

  Widget? get postAppbarLeading => _postAppbarLeading ?? _defaultAppbarLeading;

  @override
  List<Object?> get props => [
        isAppUnlock,
        isProposer,
        phaseType,
        showAppbarUpcoming,
        showAppbarActive,
        showAppbarPost,
        _upcomingAppbarActions,
        _activeAppbarActions,
        _postAppbarActions,
        _defaultAppbarActions,
        _upcomingAppbarLeading,
        _activeAppbarLeading,
        _postAppbarLeading,
        _defaultAppbarLeading,
      ];

  List<Widget> get upcomingAppbarActions => [..._upcomingAppbarActions, ..._defaultAppbarActions];

  Widget? get upcomingAppbarLeading => _upcomingAppbarLeading ?? _defaultAppbarLeading;
}

final class VotingAppbarConfig extends SpaceAppbarConfig {
  const VotingAppbarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.communityVoting,
  }) : super(
          defaultAppbarActions: const [],
        );
}

final class WorkspaceAppbarConfig extends SpaceAppbarConfig {
  const WorkspaceAppbarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.proposalSubmission,
  });
}
