// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coming_soon_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $comingSoonRoute,
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
