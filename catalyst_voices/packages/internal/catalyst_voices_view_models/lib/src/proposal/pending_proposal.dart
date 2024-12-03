import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines the pending proposal that is not funded yet.
final class PendingProposal extends Equatable {
  final String id;
  final String campaignName;
  final String category;
  final String title;
  final DateTime lastUpdateDate;
  final String fundsRequested;
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
    required this.fundsRequested,
    required this.commentsCount,
    required this.description,
    required this.completedSegments,
    required this.totalSegments,
  });

  PendingProposal.fromProposal(
    Proposal proposal, {
    required String campaignName,
    required String formattedFundsRequested,
  }) : this(
          id: proposal.id,
          campaignName: campaignName,
          category: proposal.category,
          title: proposal.title,
          lastUpdateDate: proposal.updateDate,
          fundsRequested: formattedFundsRequested,
          commentsCount: proposal.commentsCount,
          description: proposal.description,
          completedSegments: proposal.completedSegments,
          totalSegments: proposal.totalSegments,
        );

  @override
  List<Object?> get props => [
        id,
        campaignName,
        category,
        title,
        lastUpdateDate,
        fundsRequested,
        commentsCount,
        description,
        completedSegments,
        totalSegments,
      ];
}
