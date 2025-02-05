import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// A proposal card spanning proposals in different stages.
///
/// Designed to work with as many cases as [ProposalViewModel] will support.
class ProposalCard extends StatelessWidget {
  final AssetGenImage? image;
  final ProposalViewModel proposal;
  final bool showStatus;
  final bool showLastUpdate;
  final bool showComments;
  final bool showSegments;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const ProposalCard({
    super.key,
    this.image,
    required this.proposal,
    this.showStatus = true,
    this.showLastUpdate = true,
    this.showComments = true,
    this.showSegments = true,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final proposal = this.proposal;

    return switch (proposal) {
      PendingProposal() => PendingProposalCard(
          proposal: proposal,
          showStatus: showStatus,
          showLastUpdate: showLastUpdate,
          isFavorite: isFavorite,
          onFavoriteChanged: onFavoriteChanged,
        ),
      FundedProposal() => FundedProposalCard(
          image: image ?? VoicesAssets.images.proposalBackground1,
          proposal: proposal,
          isFavorite: isFavorite,
          onFavoriteChanged: onFavoriteChanged,
        ),
      (_) => const Offstage(),
    };
  }
}
