import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines the already funded proposal.
final class FundedProposal extends Equatable {
  final String id;
  final String campaignName;
  final String category;
  final String title;
  final DateTime fundedDate;
  final Coin _fundsRequested;
  final int commentsCount;
  final String description;

  const FundedProposal({
    required this.id,
    required this.campaignName,
    required this.category,
    required this.title,
    required this.fundedDate,
    required Coin fundsRequested,
    required this.commentsCount,
    required this.description,
  }) : _fundsRequested = fundsRequested;

  String get fundsRequested {
    return CryptocurrencyFormatter.formatAmount(_fundsRequested);
  }

  @override
  List<Object?> get props => [
        id,
        campaignName,
        category,
        title,
        fundedDate,
        _fundsRequested,
        commentsCount,
        description,
      ];
}