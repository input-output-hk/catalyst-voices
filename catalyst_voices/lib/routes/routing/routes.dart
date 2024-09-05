import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:go_router/go_router.dart';

/// Semantic anchor for generated routes so only this class
/// knows how to work with them.
abstract final class Routes {
  static String get initialLocation => const ComingSoonRoute().location;

  static List<RouteBase> get routes => $appRoutes;
}
