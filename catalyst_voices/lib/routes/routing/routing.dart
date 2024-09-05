import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/funded_projects/funded_projects_page.dart';
import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
import 'package:catalyst_voices/pages/voting/voting_page.dart';
import 'package:catalyst_voices/pages/workspace/workspace_page.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routing.g.dart';

const currentMilestone = 'm4';

@TypedGoRoute<ComingSoonRoute>(path: '/')
final class ComingSoonRoute extends GoRouteData {
  const ComingSoonRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ComingSoonPage();
  }
}

@TypedShellRoute<SpacesShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TreasuryRoute>(path: '/$currentMilestone/treasury'),
    TypedGoRoute<DiscoveryRoute>(path: '/$currentMilestone/discovery'),
    TypedGoRoute<WorkspaceRoute>(path: '/$currentMilestone/workspace'),
    TypedGoRoute<VotingRoute>(path: '/$currentMilestone/voting'),
    TypedGoRoute<FundedProjectsRoute>(
      path: '/$currentMilestone/funded_projects',
    ),
  ],
)
final class SpacesShellRouteData extends ShellRouteData {
  static const _spacePathMapping = <String, Space>{
    'treasury': Space.treasury,
    'discovery': Space.discovery,
    'workspace': Space.workspace,
    'voting': Space.voting,
    'funded_projects': Space.fundedProjects,
  };

  const SpacesShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    final spacePath = state.uri.pathSegments
        .skipWhile((value) => value == currentMilestone)
        .first;

    final space = _spacePathMapping[spacePath];

    assert(
      space != null,
      'Space path[$spacePath] is not defined. '
      'Make sure to match all routes to spaces',
    );

    return SpacesShellPage(
      space: space!,
      child: navigator,
    );
  }
}

final class TreasuryRoute extends GoRouteData with FadePageTransitionMixin {
  const TreasuryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TreasuryPage();
  }
}

final class DiscoveryRoute extends GoRouteData with FadePageTransitionMixin {
  const DiscoveryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DiscoveryPage();
  }
}

final class WorkspaceRoute extends GoRouteData with FadePageTransitionMixin {
  const WorkspaceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WorkspacePage();
  }
}

final class VotingRoute extends GoRouteData with FadePageTransitionMixin {
  const VotingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VotingPage();
  }
}

final class FundedProjectsRoute extends GoRouteData
    with FadePageTransitionMixin {
  const FundedProjectsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FundedProjectsPage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
final class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
