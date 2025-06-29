import 'package:catalyst_voices/pages/category/category_page.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/funded_projects/funded_projects_page.dart';
import 'package:catalyst_voices/pages/proposals/proposals_page.dart';
import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
import 'package:catalyst_voices/pages/voting/voting_page.dart';
import 'package:catalyst_voices/pages/workspace/workspace.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/proposal_submission_guard.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'spaces_route.g.dart';

final class CategoryDetailRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String categoryId;

  const CategoryDetailRoute({required this.categoryId});

  factory CategoryDetailRoute.fromRef({
    required SignedDocumentRef categoryRef,
  }) {
    return CategoryDetailRoute(categoryId: categoryRef.id);
  }

  @override
  List<RouteGuard> get routeGuards => const [ProposalSubmissionGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage(
      categoryId: SignedDocumentRef(id: categoryId),
    );
  }
}

final class DiscoveryRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final bool? $extra;

  const DiscoveryRoute({this.$extra});

  @override
  List<RouteGuard> get routeGuards => [const ProposalSubmissionGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DiscoveryPage(keychainDeleted: $extra ?? false);
  }
}

final class FundedProjectsRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const FundedProjectsRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
        ProposalSubmissionGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FundedProjectsPage();
  }
}

final class ProposalsRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String? categoryId;
  final String? type;

  const ProposalsRoute({
    this.categoryId,
    this.type,
  });

  factory ProposalsRoute.fromRef({SignedDocumentRef? categoryRef}) {
    return ProposalsRoute(categoryId: categoryRef?.id);
  }

  factory ProposalsRoute.myProposals() {
    return ProposalsRoute(type: ProposalsFilterType.my.name);
  }

  @override
  List<RouteGuard> get routeGuards => const [ProposalSubmissionGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final categoryId = this.categoryId;
    final categoryRef = categoryId != null ? SignedDocumentRef(id: categoryId) : null;

    final type = ProposalsFilterType.values.asNameMap()[this.type];

    return ProposalsPage(
      categoryId: categoryRef,
      type: type,
    );
  }
}

@TypedShellRoute<SpacesShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<DiscoveryRoute>(
      path: '/discovery',
      routes: [
        TypedGoRoute<ProposalsRoute>(
          path: 'proposals',
        ),
        TypedGoRoute<CategoryDetailRoute>(
          path: 'category/:categoryId',
        ),
      ],
    ),
    TypedGoRoute<WorkspaceRoute>(path: '/workspace'),
    TypedGoRoute<VotingRoute>(path: '/voting'),
    TypedGoRoute<FundedProjectsRoute>(path: '/funded_projects'),
    TypedGoRoute<TreasuryRoute>(path: '/treasury'),
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
    final spacePath = state.uri.pathSegments.first;

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

final class TreasuryRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const TreasuryRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        AdminAccessGuard(),
        ProposalSubmissionGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TreasuryPage();
  }
}

final class VotingRoute extends GoRouteData with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const VotingRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
        ProposalSubmissionGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VotingPage();
  }
}

final class WorkspaceRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const WorkspaceRoute();

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
        ProposalSubmissionGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WorkspacePage();
  }
}
