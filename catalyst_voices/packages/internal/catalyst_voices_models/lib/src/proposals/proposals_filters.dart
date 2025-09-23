import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsFilters extends Equatable {
  final ProposalsFilterType type;
  final CampaignFilters? _campaign;
  final CatalystId? author;
  final bool? onlyAuthor;
  final SignedDocumentRef? category;
  final String? searchQuery;
  final Duration? maxAge;

  const ProposalsFilters({
    this.type = ProposalsFilterType.total,
    CampaignFilters? campaign,
    this.author,
    this.onlyAuthor,
    this.category,
    this.searchQuery,
    this.maxAge,
  }) : _campaign = campaign;

  CampaignFilters get campaign {
    return _campaign ?? CampaignFilters.active();
  }

  @override
  List<Object?> get props => [
    type,
    _campaign,
    author,
    onlyAuthor,
    category,
    searchQuery,
    maxAge,
  ];

  ProposalsFilters copyWith({
    Optional<CampaignFilters>? campaign,
    ProposalsFilterType? type,
    Optional<CatalystId>? author,
    Optional<bool>? onlyAuthor,
    Optional<SignedDocumentRef>? category,
    Optional<String>? searchQuery,
    Optional<Duration>? maxAge,
  }) {
    return ProposalsFilters(
      type: type ?? this.type,
      campaign: campaign.dataOr(_campaign),
      author: author.dataOr(this.author),
      onlyAuthor: onlyAuthor.dataOr(this.onlyAuthor),
      category: category.dataOr(this.category),
      searchQuery: searchQuery.dataOr(this.searchQuery),
      maxAge: maxAge.dataOr(this.maxAge),
    );
  }

  ProposalsCountFilters toCountFilters() {
    return ProposalsCountFilters(
      author: author,
      onlyAuthor: onlyAuthor,
      category: category,
      searchQuery: searchQuery,
      maxAge: maxAge,
      campaign: campaign,
    );
  }

  @override
  String toString() =>
      'ProposalsFilters('
      'type[${type.name}], '
      'campaign[$campaign], '
      'author[$author], '
      'onlyAuthor[$onlyAuthor], '
      'category[$category], '
      'searchQuery[$searchQuery], '
      'maxAge[$maxAge]'
      ')';
}

enum ProposalsFilterType {
  total,
  drafts,
  finals,
  favorites,
  favoritesFinals,
  my,
  myFinals,
  voted;

  bool get isFavorite =>
      this == ProposalsFilterType.favorites || this == ProposalsFilterType.favoritesFinals;

  bool get isMy => this == ProposalsFilterType.my || this == ProposalsFilterType.myFinals;
}
