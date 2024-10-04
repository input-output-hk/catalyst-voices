// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $accountRoute,
    ];

RouteBase get $accountRoute => GoRouteData.$route(
      path: '/m4/account',
      factory: $AccountRouteExtension._fromState,
    );

extension $AccountRouteExtension on AccountRoute {
  static AccountRoute _fromState(GoRouterState state) => const AccountRoute();

  String get location => GoRouteData.$location(
        '/m4/account',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
