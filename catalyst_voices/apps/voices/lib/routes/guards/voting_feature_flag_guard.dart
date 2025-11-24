import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final class VotingFeatureFlagGuard implements RouteGuard {
  const VotingFeatureFlagGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final isVotingEnabled = context.read<FeatureFlagsCubit>().state.isEnabled(Features.voting);
    if (isVotingEnabled) {
      return null;
    } else {
      return const DiscoveryRoute().location;
    }
  }
}
