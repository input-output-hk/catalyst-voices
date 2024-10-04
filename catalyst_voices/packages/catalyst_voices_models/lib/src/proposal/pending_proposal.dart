import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// Defines the pending proposal that is not funded yet.
final class PendingProposal extends Equatable {
  final String id;
  final String fund;
  final String category;
  final String title;
  final DateTime lastUpdateDate;
  final Coin fundsRequested;
  final int commentsCount;
  final String description;
  final int completedSegments;
  final int totalSegments;

  const PendingProposal({
    required this.id,
    required this.fund,
    required this.category,
    required this.title,
    required this.lastUpdateDate,
    required this.fundsRequested,
    required this.commentsCount,
    required this.description,
    required this.completedSegments,
    required this.totalSegments,
  });

  @override
  List<Object?> get props => [
        id,
        fund,
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
