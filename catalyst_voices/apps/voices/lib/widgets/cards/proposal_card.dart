import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// A proposal card spanning proposals in different stages.
class ProposalCard extends StatelessWidget {
  final AssetGenImage image;
  final ProposalViewModel proposal;
  final bool showStatus;
  final bool showLastUpdate;
  final bool showComments;
  final bool showSegments;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const ProposalCard({
    super.key,
    required this.image,
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
    return switch (proposal) {
      PendingProposalViewModel(:final data) => PendingProposalCard(
          image: image,
          proposal: data,
          showStatus: showStatus,
          showLastUpdate: showLastUpdate,
          showComments: showComments,
          showSegments: showSegments,
          isFavorite: isFavorite,
          onFavoriteChanged: onFavoriteChanged,
        ),
      FundedProposalViewModel(:final data) => FundedProposalCard(
          image: image,
          proposal: data,
          isFavorite: isFavorite,
          onFavoriteChanged: onFavoriteChanged,
        ),
    };
  }
}
