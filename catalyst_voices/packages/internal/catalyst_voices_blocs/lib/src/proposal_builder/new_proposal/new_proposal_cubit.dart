import 'dart:async';

import 'package:catalyst_voices_blocs/src/proposal_builder/new_proposal/new_proposal_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewProposalCubit extends Cubit<NewProposalState> {
  final CampaignService _campaignService;

  NewProposalCubit(this._campaignService)
      : super(
          const NewProposalState(
            title: ProposalTitle.pure(),
          ),
        ) {
    unawaited(getCampaignCategories());
  }

  Future<void> getCampaignCategories() async {
    final categories = await _campaignService.getCampaignCategories();
    final categoriesModel =
        categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();
    emit(
      state.copyWith(
        categories: categoriesModel,
        categoryId: Optional(categoriesModel.first.id),
      ),
    );
  }

  void updateSelectedCategory(String? categoryId) {
    emit(state.copyWith(categoryId: Optional(categoryId)));
  }

  void updateTitle(ProposalTitle title) {
    emit(state.copyWith(title: title));
  }
}
