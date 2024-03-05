// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_page_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $remoteWidgetsRoute,
    ];

RouteBase get $remoteWidgetsRoute => GoRouteData.$route(
      path: '/remote',
      factory: $RemoteWidgetsRouteExtension._fromState,
    );

extension $RemoteWidgetsRouteExtension on RemoteWidgetsRoute {
  static RemoteWidgetsRoute _fromState(GoRouterState state) =>
      RemoteWidgetsRoute();

  String get location => GoRouteData.$location(
        '/remote',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
