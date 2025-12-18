import 'package:catalyst_voices/pages/actions/actions_page.dart';
import 'package:catalyst_voices/routes/routing/transitions/slide_from_end_drawer_page_transition_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'actions_route.g.dart';

@TypedGoRoute<ActionsRoute>(
  path: '/myactions',
  name: 'myactions',
)
final class ActionsRoute extends GoRouteData with SlideFromEndDrawerPageTransitionMixin {
  const ActionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActionsPage();
  }
}
