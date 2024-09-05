import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/treasury/treasury.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routing.g.dart';

const milestonePathPrefix = '/m4';

@TypedGoRoute<ComingSoonRoute>(path: '/')
final class ComingSoonRoute extends GoRouteData {
  const ComingSoonRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ComingSoonPage(
      key: state.pageKey,
    );
  }
}

@TypedGoRoute<DiscoveryRoute>(path: '$milestonePathPrefix/discovery')
final class DiscoveryRoute extends GoRouteData {
  const DiscoveryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DiscoveryPage(
      key: state.pageKey,
    );
  }
}

@TypedGoRoute<TreasuryRoute>(path: '$milestonePathPrefix/treasury')
final class TreasuryRoute extends GoRouteData {
  const TreasuryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TreasuryPage(
      key: state.pageKey,
    );
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
final class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginPage(
      key: state.pageKey,
    );
  }
}
