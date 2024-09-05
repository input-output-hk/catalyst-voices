import 'dart:async';

import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/src/state.dart';

/// Always redirects to [ComingSoonPage] expect for milestone sub pages.
final class MilestoneGuard implements RouteGuard {
  const MilestoneGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    // allow milestone sub pages
    if (state.uri.toString().startsWith(milestonePathPrefix)) {
      return null;
    }

    // if already at destination skip redirect
    if (state.uri.toString() == const ComingSoonRoute().location) {
      return null;
    }

    return const ComingSoonRoute().location;
  }
}
