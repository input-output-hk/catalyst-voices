import 'package:catalyst_voices/pages/proposals/proposals_pagination.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalPaginationTabView extends StatelessWidget {
  final ProposalPaginViewModel paginationViewModel;
  final ProposalPublish? stage;
  final bool userProposals;
  final bool usersFavorite;

  const ProposalPaginationTabView({
    super.key,
    required this.paginationViewModel,
    this.stage,
    this.userProposals = false,
    this.usersFavorite = false,
  });

  List<ProposalViewModel> get proposals => paginationViewModel.items;

  int get pageKey => paginationViewModel.pageKey;

  int get maxResults => paginationViewModel.maxResults;

  bool get isLoading => paginationViewModel.isLoading;

  String? get categoryId => paginationViewModel.categoryId;

  String? get searchValue => paginationViewModel.searchValue;

  @override
  Widget build(BuildContext context) {
    return ProposalsPagination(
      key: key,
      proposals,
      pageKey,
      maxResults,
      isLoading: isLoading,
      stage: stage,
      userProposals: userProposals,
      usersFavorite: usersFavorite,
      categoryId: categoryId,
      searchValue: searchValue,
    );
  }
}
