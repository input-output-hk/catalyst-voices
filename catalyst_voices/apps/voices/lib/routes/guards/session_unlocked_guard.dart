import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A guard which redirects to the discovery page
/// if the keychain is locked.
final class SessionUnlockedGuard implements RouteGuard {
  const SessionUnlockedGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final sessionCubit = context.read<SessionCubit>();
    if (sessionCubit.state.isActive) {
      // if already unlocked skip redirection
      return null;
    } else {
      return const DiscoveryRoute().location;
    }
  }
}
