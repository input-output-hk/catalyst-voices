import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class ProposalPaginationViewModel extends Equatable {
  final int pageKey;
  final int maxResults;
  final List<ProposalViewModel> items;
  final bool isLoading;

  const ProposalPaginationViewModel({
    required this.pageKey,
    required this.maxResults,
    required this.items,
    this.isLoading = false,
  });

  factory ProposalPaginationViewModel.fromPaginationItems({
    required ProposalPaginationItems<ProposalViewModel> paginItems,
    required bool isLoading,
  }) {
    return ProposalPaginationViewModel(
      pageKey: paginItems.pageKey,
      maxResults: paginItems.maxResults,
      items: paginItems.items,
      isLoading: isLoading,
    );
  }

  @override
  List<Object?> get props => [
        pageKey,
        maxResults,
        items,
        isLoading,
      ];

  ProposalPaginationViewModel copyWith({
    int? pageKey,
    int? maxResults,
    List<ProposalViewModel>? items,
    bool? isLoading,
  }) {
    return ProposalPaginationViewModel(
      pageKey: pageKey ?? this.pageKey,
      maxResults: maxResults ?? this.maxResults,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
