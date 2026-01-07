import 'package:catalyst_voices/pages/category/category_page.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/funded_projects/funded_projects_page.dart';
import 'package:catalyst_voices/pages/proposals/proposals_page.dart';
import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
import 'package:catalyst_voices/pages/voting/voting_page.dart';
import 'package:catalyst_voices/pages/workspace/workspace.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/guards/voting_feature_flag_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'spaces_route.g.dart';

final class CategoryDetailRoute extends GoRouteData
    with $CategoryDetailRoute, FadePageTransitionMixin {
  final String categoryId;

  const CategoryDetailRoute({required this.categoryId});

  factory CategoryDetailRoute.fromRef({
    required SignedDocumentRef categoryRef,
  }) {
    return CategoryDetailRoute(categoryId: categoryRef.id);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage(
      categoryRef: SignedDocumentRef(id: categoryId),
    );
  }
}

final class DiscoveryRoute extends GoRouteData with $DiscoveryRoute, FadePageTransitionMixin {
  static const name = 'discovery';

  final bool? $extra;

  const DiscoveryRoute({this.$extra});

  const DiscoveryRoute.keychainDeleted() : this($extra: true);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SentryDisplayWidget(child: DiscoveryPage(keychainDeleted: $extra ?? false));
  }
}

final class FundedProjectsRoute extends GoRouteData
    with $FundedProjectsRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
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

final class ProposalsRoute extends GoRouteData with $ProposalsRoute, FadePageTransitionMixin {
  final String? categoryId;
  final String? tab;

  const ProposalsRoute({
    this.categoryId,
    this.tab,
  });

  factory ProposalsRoute.fromRef({SignedDocumentRef? categoryRef}) {
    return ProposalsRoute(categoryId: categoryRef?.id);
  }

  factory ProposalsRoute.myProposals() {
    return ProposalsRoute(tab: ProposalsPageTab.my.name);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final categoryId = this.categoryId;
    final categoryRef = categoryId != null ? SignedDocumentRef(id: categoryId) : null;

    final tab = ProposalsPageTab.values.asNameMap()[this.tab];

    return ProposalsPage(
      categoryRef: categoryRef,
      tab: tab,
    );
  }
}

@TypedShellRoute<SpacesShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<DiscoveryRoute>(
      path: '/discovery',
      name: DiscoveryRoute.name,
      routes: [
        TypedGoRoute<ProposalsRoute>(
          path: 'proposals',
          name: 'proposals',
        ),
        TypedGoRoute<CategoryDetailRoute>(
          path: 'category/:categoryId',
          name: 'category_details',
        ),
      ],
    ),
    TypedGoRoute<WorkspaceRoute>(
      path: '/workspace',
      name: WorkspaceRoute.name,
    ),
    TypedGoRoute<VotingRoute>(
      path: '/voting',
      name: 'voting',
    ),
    TypedGoRoute<FundedProjectsRoute>(
      path: '/funded_projects',
      name: 'funded_projects',
    ),
    TypedGoRoute<TreasuryRoute>(
      path: '/treasury',
      name: 'treasury',
    ),
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
    with $TreasuryRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
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

final class VotingRoute extends GoRouteData
    with $VotingRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String? categoryId;
  final String? tab;
  final bool? $extra;

  const VotingRoute({
    this.categoryId,
    this.tab,
    this.$extra,
  });

  const VotingRoute.keychainDeleted({
    String? categoryId,
    String? tab,
  }) : this(
         categoryId: categoryId,
         tab: tab,
         $extra: true,
       );

  @override
  List<RouteGuard> get routeGuards => [const VotingFeatureFlagGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final categoryId = this.categoryId;
    final categoryRef = categoryId != null ? SignedDocumentRef(id: categoryId) : null;

    final tab = VotingPageTab.values.asNameMap()[this.tab];

    return VotingPage(
      categoryRef: categoryRef,
      tab: tab,
      keychainDeleted: $extra ?? false,
    );
  }
}

final class WorkspaceRoute extends GoRouteData
    with $WorkspaceRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
  static const name = 'workspace';

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
