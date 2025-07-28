import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Parameters that can control what is displayed in the app bar.
interface class AppBarControl {
  final bool isAppUnlock;
  final bool isProposer;
  final CampaignPhaseType phaseType;

  const AppBarControl({
    required this.isAppUnlock,
    required this.isProposer,
    required this.phaseType,
  });
}

final class DefaultSpaceAppBarConfig extends SpaceAppBarConfig {
  const DefaultSpaceAppBarConfig({
    super.isAppUnlock = false,
    super.isProposer = false,
    super.phaseType = CampaignPhaseType.projectOnboarding,
  });
}

final class DiscoveryAppBarConfig extends SpaceAppBarConfig {
  DiscoveryAppBarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.proposalSubmission,
  }) : super(
          showAppBarUpcoming: false,
          showAppBarActive: true,
          showAppBarPost: false,
          activeAppBarActions: [
            if (isAppUnlock && isProposer) const CreateProposalButton(),
          ],
        );
}

sealed class SpaceAppBarConfig extends Equatable implements AppBarControl {
  @override
  final bool isAppUnlock;
  @override
  final bool isProposer;
  @override
  final CampaignPhaseType phaseType;

  final bool showAppBarUpcoming;
  final bool showAppBarActive;
  final bool showAppBarPost;

  final List<Widget> _upcomingAppBarActions;
  final List<Widget> _activeAppBarActions;
  final List<Widget> _postAppBarActions;
  final List<Widget> _defaultAppBarActions;

  final Widget? _upcomingAppBarLeading;
  final Widget? _activeAppBarLeading;
  final Widget? _postAppBarLeading;
  final Widget? _defaultAppBarLeading;

  const SpaceAppBarConfig({
    required this.isAppUnlock,
    required this.isProposer,
    required this.phaseType,
    this.showAppBarUpcoming = true,
    this.showAppBarActive = true,
    this.showAppBarPost = true,
    List<Widget> upcomingAppBarActions = const [],
    List<Widget> activeAppBarActions = const [],
    List<Widget> postAppBarActions = const [],
    List<Widget> defaultAppBarActions = const [
      SessionActionHeader(),
      SessionStateHeader(),
    ],
    Widget? upcomingAppBarLeading,
    Widget? activeAppBarLeading,
    Widget? postAppBarLeading,
    Widget? defaultAppBarLeading,
  })  : _upcomingAppBarActions = upcomingAppBarActions,
        _activeAppBarActions = activeAppBarActions,
        _postAppBarActions = postAppBarActions,
        _defaultAppBarActions = defaultAppBarActions,
        _upcomingAppBarLeading = upcomingAppBarLeading,
        _activeAppBarLeading = activeAppBarLeading,
        _postAppBarLeading = postAppBarLeading,
        _defaultAppBarLeading =
            defaultAppBarLeading ?? (isAppUnlock ? const DrawerToggleButton() : null);

  List<Widget> get activeAppBarActions => [..._activeAppBarActions, ..._defaultAppBarActions];

  Widget? get activeAppBarLeading => _activeAppBarLeading ?? _defaultAppBarLeading;

  List<Widget> get postAppBarActions => [..._postAppBarActions, ..._defaultAppBarActions];

  Widget? get postAppBarLeading => _postAppBarLeading ?? _defaultAppBarLeading;
  @override
  List<Object?> get props => [
        isAppUnlock,
        isProposer,
        phaseType,
        showAppBarUpcoming,
        showAppBarActive,
        showAppBarPost,
        _upcomingAppBarActions,
        _activeAppBarActions,
        _postAppBarActions,
        _defaultAppBarActions,
        _upcomingAppBarLeading,
        _activeAppBarLeading,
        _postAppBarLeading,
        _defaultAppBarLeading,
      ];

  List<Widget> get upcomingAppBarActions => [..._upcomingAppBarActions, ..._defaultAppBarActions];

  Widget? get upcomingAppBarLeading => _upcomingAppBarLeading ?? _defaultAppBarLeading;
}

final class VotingAppBarConfig extends SpaceAppBarConfig {
  const VotingAppBarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.communityVoting,
  }) : super(
          defaultAppBarActions: const [],
        );
}

final class WorkspaceAppBarConfig extends SpaceAppBarConfig {
  const WorkspaceAppBarConfig({
    required super.isAppUnlock,
    required super.isProposer,
    super.phaseType = CampaignPhaseType.proposalSubmission,
  });
}
