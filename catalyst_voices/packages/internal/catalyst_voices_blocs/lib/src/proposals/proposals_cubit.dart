import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState> {
  ProposalsCubit() : super(const LoadingProposalsState());

  /// Loads the proposals.
  Future<void> load() async {
    // simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // TODO(dtscalac): replace by proposals stored
    // in local storage when available
    emit(
      LoadedProposalsState(
        proposals: _proposals,
        favoriteProposals: const [],
      ),
    );
  }

  /// Marks the proposal with [proposalId] as favorite.
  Future<void> onFavoriteProposal(String proposalId) async {
    final loadedState = state;
    if (loadedState is! LoadedProposalsState) return;

    final proposals = loadedState.proposals;
    final favoriteProposal =
        proposals.firstWhereOrNull((e) => e.id == proposalId);
    if (favoriteProposal == null) return;

    emit(
      LoadedProposalsState(
        proposals: loadedState.proposals,
        favoriteProposals: [
          ...loadedState.favoriteProposals,
          favoriteProposal,
        ],
      ),
    );
  }

  /// Unmarks the proposal with [proposalId] as favorite.
  Future<void> onUnfavoriteProposal(String proposalId) async {
    final loadedState = state;
    if (loadedState is! LoadedProposalsState) return;

    emit(
      LoadedProposalsState(
        proposals: loadedState.proposals,
        favoriteProposals: loadedState.favoriteProposals
            .whereNot((e) => e.id == proposalId)
            .toList(),
      ),
    );
  }
}

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

final _proposals = [
  PendingProposal(
    id: 'f14/0',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 0,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/1',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 7,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/2',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 13,
    totalSegments: 13,
  ),
];
