import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/spaces/spaces.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
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
    TypedGoRoute<DiscoveryRoute>(path: '/$currentMilestone/discovery'),
    TypedGoRoute<TreasuryRoute>(path: '/$currentMilestone/treasury'),
  ],
)
final class SpacesShellRouteData extends ShellRouteData {
  const SpacesShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    final spaceName = state.uri.pathSegments
        .where((element) => element != currentMilestone)
        .first;
    final space = Space.values.byName(spaceName);

    return SpacesShellPage(
      space: space,
      child: navigator,
    );
  }
}

final class DiscoveryRoute extends GoRouteData {
  const DiscoveryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DiscoveryPage();
  }
}

final class TreasuryRoute extends GoRouteData {
  const TreasuryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TreasuryPage();
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
