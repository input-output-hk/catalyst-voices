import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class ProposalPaginViewModel extends Equatable {
  final int pageKey;
  final int maxResults;
  final List<ProposalViewModel> items;
  final String? categoryId;
  final String? searchValue;
  final bool isLoading;

  const ProposalPaginViewModel({
    required this.pageKey,
    required this.maxResults,
    required this.items,
    this.categoryId,
    this.searchValue,
    this.isLoading = false,
  });

  factory ProposalPaginViewModel.fromPaginationItems({
    required ProposalPaginationItems<ProposalViewModel> paginItems,
    String? categoryId,
    String? searchValue,
    required bool isLoading,
  }) {
    return ProposalPaginViewModel(
      pageKey: paginItems.pageKey,
      maxResults: paginItems.maxResults,
      items: paginItems.items,
      categoryId: categoryId,
      searchValue: searchValue,
      isLoading: isLoading,
    );
  }

  ProposalPaginViewModel copyWith({
    int? pageKey,
    int? maxResults,
    List<ProposalViewModel>? items,
    String? categoryId,
    String? searchValue,
    bool? canReload,
    bool? isLoading,
  }) {
    return ProposalPaginViewModel(
      pageKey: pageKey ?? this.pageKey,
      maxResults: maxResults ?? this.maxResults,
      items: items ?? this.items,
      categoryId: categoryId ?? this.categoryId,
      searchValue: searchValue ?? this.searchValue,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        pageKey,
        maxResults,
        items,
        categoryId,
        searchValue,
        isLoading,
      ];
}
