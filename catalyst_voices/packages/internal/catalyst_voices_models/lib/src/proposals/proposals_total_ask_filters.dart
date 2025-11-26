import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A class that encapsulates the filters used to calculate the total
/// ask for a set of proposals.
final class ProposalsTotalAskFilters extends Equatable {
  /// The general campaign filters to apply.
  final CampaignFilters? campaign;

  /// The specific category ID to filter by.
  final String? categoryId;

  /// Creates an instance of [ProposalsTotalAskFilters].
  const ProposalsTotalAskFilters({
    this.campaign,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
    campaign,
    categoryId,
  ];
}
