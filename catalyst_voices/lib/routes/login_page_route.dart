import 'package:catalyst_voices/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'login_page_route.g.dart';

const loginPath = '/login';

@TypedGoRoute<LoginRoute>(path: loginPath)
final class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
