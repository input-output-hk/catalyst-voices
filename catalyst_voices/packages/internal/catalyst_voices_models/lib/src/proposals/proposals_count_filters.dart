import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCountFilters extends Equatable {
  final CatalystId? author;
  final bool? onlyAuthor;
  final SignedDocumentRef? category;
  final String? searchQuery;
  final Duration? maxAge;
  final CampaignFilters? campaign;

  const ProposalsCountFilters({
    this.author,
    this.onlyAuthor,
    this.category,
    this.searchQuery,
    this.maxAge,
    this.campaign,
  });

  @override
  List<Object?> get props => [
    author,
    onlyAuthor,
    category,
    searchQuery,
    maxAge,
    campaign,
  ];
}
