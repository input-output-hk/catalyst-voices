import 'dart:async';

import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Always redirects to [ComingSoonPage] except for milestone sub pages.
final class MilestoneGuard implements RouteGuard {
  const MilestoneGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.toString();

    // redirects /m4 page to /m4/discovery
    if (location == '/${Routes.currentMilestone}') {
      return const DiscoveryRoute().location;
    }

    // allow milestone sub pages
    if (location.startsWith('/${Routes.currentMilestone}')) {
      return null;
    }

    // if already at destination skip redirect
    if (location == const ComingSoonRoute().location) {
      return null;
    }

    return const ComingSoonRoute().location;
  }
}
