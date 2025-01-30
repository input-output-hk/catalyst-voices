import 'package:catalyst_voices/pages/category/category_page.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/funded_projects/funded_projects_page.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder.dart';
import 'package:catalyst_voices/pages/proposals/proposals_page.dart';
import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
import 'package:catalyst_voices/pages/voting/voting_page.dart';
import 'package:catalyst_voices/pages/workspace/workspace.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'spaces_route.g.dart';

const _prefix = Routes.currentMilestone;

@TypedShellRoute<SpacesShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<DiscoveryRoute>(
      path: '/$_prefix/discovery',
      routes: [
        TypedGoRoute<ProposalsRoute>(
          path: 'proposals',
        ),
        TypedGoRoute<CategoryDetailRoute>(
          path: 'category/:categoryId',
        ),
      ],
    ),
    TypedGoRoute<WorkspaceRoute>(
      path: '/$_prefix/workspace',
      routes: [
        TypedGoRoute<ProposalBuilderDraftRoute>(
          path: 'proposal_builder/draft',
        ),
        TypedGoRoute<ProposalBuilderRoute>(
          path: 'proposal_builder/:proposalId',
        ),
      ],
    ),
    TypedGoRoute<VotingRoute>(path: '/$_prefix/voting'),
    TypedGoRoute<FundedProjectsRoute>(path: '/$_prefix/funded_projects'),
    TypedGoRoute<TreasuryRoute>(path: '/$_prefix/treasury'),
  ],
)
final class SpacesShellRouteData extends ShellRouteData {
  static const _spacePathMapping = <String, Space>{
    'discovery': Space.discovery,
    'workspace': Space.workspace,
    'voting': Space.voting,
    'funded_projects': Space.fundedProjects,
    'treasury': Space.treasury,
  };

  const SpacesShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    final spacePath = state.uri.pathSegments
        .skipWhile((value) => value == Routes.currentMilestone)
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

final class DiscoveryRoute extends GoRouteData with FadePageTransitionMixin {
  const DiscoveryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DiscoveryPage();
  }
}

final class WorkspaceRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const WorkspaceRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WorkspacePage();
  }
}

final class ProposalsRoute extends GoRouteData with FadePageTransitionMixin {
  final String? categoryId;

  const ProposalsRoute({this.categoryId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalsPage(
      categoryId: categoryId,
    );
  }
}

final class ProposalBuilderDraftRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String? templateId;

  const ProposalBuilderDraftRoute({
    this.templateId,
  });

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalBuilderPage(templateId: templateId);
  }
}

final class ProposalBuilderRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;

  const ProposalBuilderRoute({
    required this.proposalId,
  });

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalBuilderPage(proposalId: proposalId);
  }
}

final class VotingRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const VotingRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VotingPage();
  }
}

final class FundedProjectsRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const FundedProjectsRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FundedProjectsPage();
  }
}

final class TreasuryRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const TreasuryRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        AdminAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TreasuryPage();
  }
}

final class CategoryDetailRoute extends GoRouteData
    with FadePageTransitionMixin {
  final String categoryId;

  const CategoryDetailRoute(this.categoryId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage(categoryId: categoryId);
  }
}
