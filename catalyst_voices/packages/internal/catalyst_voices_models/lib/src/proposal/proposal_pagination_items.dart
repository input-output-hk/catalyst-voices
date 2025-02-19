import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class ProposalPaginationItems<ProposalType> extends Equatable {
  final int pageKey;
  final int maxResults;
  final List<ProposalType> items;
  final bool isLoading;

  const ProposalPaginationItems({
    this.pageKey = 0,
    this.maxResults = 0,
    this.items = const [],
    this.isLoading = false,
  });

  bool get noItems => items.isEmpty;

  @override
  List<Object?> get props => [
        maxResults,
        pageKey,
        items,
        isLoading,
      ];

  ProposalPaginationItems<ProposalType> copyWith({
    int? pageKey,
    int? maxResults,
    List<ProposalType>? items,
    bool isLoading = false,
  }) {
    return ProposalPaginationItems<ProposalType>(
      pageKey: pageKey ?? this.pageKey,
      maxResults: maxResults ?? this.maxResults,
      items: items ?? this.items,
      isLoading: isLoading,
    );
  }
}

class ProposalsSearchResult extends Equatable {
  final int maxResults;
  final List<ProposalBase> proposals;

  const ProposalsSearchResult({
    required this.maxResults,
    required this.proposals,
  });

  @override
  List<Object?> get props => [
        maxResults,
        proposals,
      ];
}
