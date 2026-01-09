import 'dart:async';

import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'root_route.g.dart';

@TypedGoRoute<RootRoute>(path: '/')
final class RootRoute extends GoRouteData with $RootRoute {
  const RootRoute();

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final cubit = context.read<CampaignPhaseAwareCubit>();
    final phase = cubit.activeCampaignPhaseType();
    return switch (phase) {
      CampaignPhaseType.communityVoting => const VotingRoute().location,
      _ => const DiscoveryRoute().location,
    };
  }
}
