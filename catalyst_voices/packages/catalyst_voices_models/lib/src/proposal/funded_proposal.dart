import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// Defines the already funded proposal.
final class FundedProposal extends Equatable {
  final String id;
  final String fund;
  final String category;
  final String title;
  final DateTime fundedDate;
  final Coin fundsRequested;
  final int commentsCount;
  final String description;

  const FundedProposal({
    required this.id,
    required this.fund,
    required this.category,
    required this.title,
    required this.fundedDate,
    required this.fundsRequested,
    required this.commentsCount,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        fund,
        category,
        title,
        fundedDate,
        fundsRequested,
        commentsCount,
        description,
      ];
}
