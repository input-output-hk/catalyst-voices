import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class UserAccessGuard implements RouteGuard {
  const UserAccessGuard();
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final account = context.read<SessionCubit>().state.account;

    if (account == null) {
      return const DiscoveryRoute().location;
    }
    if (account.isAdmin) {
      return null;
    }
    if (state.path == const VotingRoute().location ||
        state.path == const FundedProjectsRoute().location) {
      return const DiscoveryRoute().location;
    }
    if (account.roles.any(
      (role) => [AccountRole.proposer, AccountRole.drep].contains(role),
    )) return null;
    return const DiscoveryRoute().location;
  }
}

final class AdminAccessGuard implements RouteGuard {
  const AdminAccessGuard();
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final account = context.read<SessionCubit>().state.account;
    if (account?.isAdmin ?? false) {
      return null;
    } else {
      return const DiscoveryRoute().location;
    }
  }
}
