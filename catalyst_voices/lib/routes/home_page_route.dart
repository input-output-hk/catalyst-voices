import 'package:catalyst_voices/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'home_page_route.g.dart';

const homePath = '/home';

@TypedGoRoute<HomeRoute>(path: homePath)
final class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
