import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsFilters extends Equatable {
  final ProposalsFilterType type;
  final CatalystId? author;
  final bool? onlyAuthor;
  final SignedDocumentRef? category;
  final String? searchQuery;
  final Duration? maxAge;

  const ProposalsFilters({
    this.type = ProposalsFilterType.total,
    this.author,
    this.onlyAuthor,
    this.category,
    this.searchQuery,
    this.maxAge,
  });

  @override
  List<Object?> get props => [
        type,
        author,
        onlyAuthor,
        category,
        searchQuery,
        maxAge,
      ];

  ProposalsFilters copyWith({
    ProposalsFilterType? type,
    Optional<CatalystId>? author,
    Optional<bool>? onlyAuthor,
    Optional<SignedDocumentRef>? category,
    Optional<String>? searchQuery,
    Optional<Duration>? maxAge,
  }) {
    return ProposalsFilters(
      type: type ?? this.type,
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
    );
  }

  @override
  String toString() => 'ProposalsFilters('
      'type[${type.name}], '
      'author[$author], '
      'onlyAuthor[$onlyAuthor], '
      'category[$category], '
      'searchQuery[$searchQuery], '
      'maxAge[$maxAge]'
      ')';
}

enum ProposalsFilterType { total, drafts, finals, favorites, my }
