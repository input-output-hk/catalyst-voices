import 'package:catalyst_voices/routes/routing/coming_soon_route.dart'
    as coming_soon;
import 'package:catalyst_voices/routes/routing/login_route.dart' as login;
import 'package:catalyst_voices/routes/routing/spaces_route.dart' as spaces;
import 'package:go_router/go_router.dart';

/// Semantic anchor for generated routes so only this class
/// knows how to work with them.
abstract final class Routes {
  static const currentMilestone = 'm4';

  static String get initialLocation {
    return const coming_soon.ComingSoonRoute().location;
  }

  static List<RouteBase> get routes => [
        ...coming_soon.$appRoutes,
        ...login.$appRoutes,
        ...spaces.$appRoutes,
      ];
}
