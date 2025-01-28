import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'campaign_categories_state.dart';

class CampaignCategoriesCubit extends Cubit<CampaignCategoriesState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  CampaignCategoriesCubit(this._campaignService)
      : super(const CampaignCategoriesState());

  Future<void> loadCampaignCategories() async {
    emit(state.loading());

    // TODO(LynxxLynx): implement fetching campaign categories

    final isSuccess = await Future.delayed(
      const Duration(seconds: 1),
      () => Random().nextBool(),
    );

    final proposals = isSuccess
        ? List.filled(6, CampaignCategoryCardViewModel.dummy())
        : const <CampaignCategoryCardViewModel>[];

    final LocalizedException? error =
        isSuccess ? null : const LocalizedUnknownException();

    final newState = state.copyWith(
      isLoading: false,
      categories: proposals,
      error: Optional(error),
    );

    emit(newState);
  }
}
