// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overall_spaces_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $overallSpacesRoute,
    ];

RouteBase get $overallSpacesRoute => GoRouteData.$route(
      path: '/m4/spaces',
      factory: $OverallSpacesRouteExtension._fromState,
    );

extension $OverallSpacesRouteExtension on OverallSpacesRoute {
  static OverallSpacesRoute _fromState(GoRouterState state) =>
      const OverallSpacesRoute();

  String get location => GoRouteData.$location(
        '/m4/spaces',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
