import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines the pending proposal that is not funded yet.
final class PendingProposal extends Equatable {
  final String id;
  final String campaignName;
  final String category;
  final String title;
  final DateTime lastUpdateDate;
  final Coin _fundsRequested;
  final int commentsCount;
  final String description;
  final int completedSegments;
  final int totalSegments;

  const PendingProposal({
    required this.id,
    required this.campaignName,
    required this.category,
    required this.title,
    required this.lastUpdateDate,
    required Coin fundsRequested,
    required this.commentsCount,
    required this.description,
    required this.completedSegments,
    required this.totalSegments,
  }) : _fundsRequested = fundsRequested;

  PendingProposal.fromProposal(
    Proposal proposal, {
    required String campaignName,
  }) : this(
          id: proposal.id,
          campaignName: campaignName,
          category: proposal.category,
          title: proposal.title,
          lastUpdateDate: proposal.updateDate,
          fundsRequested: proposal.fundsRequested,
          commentsCount: proposal.commentsCount,
          description: proposal.description,
          completedSegments: proposal.completedSegments,
          totalSegments: proposal.totalSegments,
        );

  String get fundsRequested {
    return CryptocurrencyFormatter.formatAmount(_fundsRequested);
  }

  @override
  List<Object?> get props => [
        id,
        campaignName,
        category,
        title,
        lastUpdateDate,
        _fundsRequested.value,
        commentsCount,
        description,
        completedSegments,
        totalSegments,
      ];
}
