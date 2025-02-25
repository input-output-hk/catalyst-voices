import 'package:catalyst_voices/pages/proposals/proposals_pagination.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalPaginationTabView extends StatelessWidget {
  final ProposalPaginationViewModel paginationViewModel;
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

  @override
  Widget build(BuildContext context) {
    return ProposalsPagination(
      key: key,
      paginationViewModel.items,
      paginationViewModel.pageKey,
      paginationViewModel.maxResults,
      isLoading: paginationViewModel.isLoading,
      stage: stage,
      userProposals: userProposals,
      usersFavorite: usersFavorite,
      categoryId: paginationViewModel.categoryId,
      searchValue: paginationViewModel.searchValue,
    );
  }
}
