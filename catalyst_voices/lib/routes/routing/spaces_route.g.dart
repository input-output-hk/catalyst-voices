// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $spacesShellRouteData,
    ];

RouteBase get $spacesShellRouteData => ShellRouteData.$route(
      factory: $SpacesShellRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/m4/discovery',
          factory: $DiscoveryRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/m4/workspace',
          factory: $WorkspaceRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/m4/voting',
          factory: $VotingRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/m4/funded_projects',
          factory: $FundedProjectsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/m4/treasury',
          factory: $TreasuryRouteExtension._fromState,
        ),
      ],
    );

extension $SpacesShellRouteDataExtension on SpacesShellRouteData {
  static SpacesShellRouteData _fromState(GoRouterState state) =>
      const SpacesShellRouteData();
}

extension $DiscoveryRouteExtension on DiscoveryRoute {
  static DiscoveryRoute _fromState(GoRouterState state) =>
      const DiscoveryRoute();

  String get location => GoRouteData.$location(
        '/m4/discovery',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WorkspaceRouteExtension on WorkspaceRoute {
  static WorkspaceRoute _fromState(GoRouterState state) =>
      const WorkspaceRoute();

  String get location => GoRouteData.$location(
        '/m4/workspace',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $VotingRouteExtension on VotingRoute {
  static VotingRoute _fromState(GoRouterState state) => const VotingRoute();

  String get location => GoRouteData.$location(
        '/m4/voting',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FundedProjectsRouteExtension on FundedProjectsRoute {
  static FundedProjectsRoute _fromState(GoRouterState state) =>
      const FundedProjectsRoute();

  String get location => GoRouteData.$location(
        '/m4/funded_projects',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TreasuryRouteExtension on TreasuryRoute {
  static TreasuryRoute _fromState(GoRouterState state) => const TreasuryRoute();

  String get location => GoRouteData.$location(
        '/m4/treasury',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
