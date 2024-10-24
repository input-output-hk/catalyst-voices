import 'dart:async';

import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A guard mixin which redirects to the discovery page
/// if the keychain is locked.
mixin UnlockedKeychainGuardMixin on GoRouteData {
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final sessionCubit = context.read<SessionCubit>();
    if (sessionCubit.state is ActiveAccountSessionState) {
      // if already unlocked skip redirection
      return null;
    } else {
      return const DiscoveryRoute().location;
    }
  }
}
