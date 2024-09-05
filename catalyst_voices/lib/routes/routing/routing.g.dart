// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routing.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $comingSoonRoute,
      $discoveryRoute,
      $treasuryRoute,
      $loginRoute,
    ];

RouteBase get $comingSoonRoute => GoRouteData.$route(
      path: '/',
      factory: $ComingSoonRouteExtension._fromState,
    );

extension $ComingSoonRouteExtension on ComingSoonRoute {
  static ComingSoonRoute _fromState(GoRouterState state) =>
      const ComingSoonRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $discoveryRoute => GoRouteData.$route(
      path: '/m4/discovery',
      factory: $DiscoveryRouteExtension._fromState,
    );

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

RouteBase get $treasuryRoute => GoRouteData.$route(
      path: '/m4/treasury',
      factory: $TreasuryRouteExtension._fromState,
    );

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

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
