import 'package:catalyst_voices/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'login_route.g.dart';

@TypedGoRoute<LoginRoute>(path: '/login')
final class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
