import 'package:catalyst_voices/pages/overall_spaces/overall_spaces.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'overall_spaces_route.g.dart';

@TypedGoRoute<OverallSpacesRoute>(
  path: '/${Routes.currentMilestone}/spaces',
)
final class OverallSpacesRoute extends GoRouteData
    with FadePageTransitionMixin {
  const OverallSpacesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OverallSpacesPage();
  }
}
