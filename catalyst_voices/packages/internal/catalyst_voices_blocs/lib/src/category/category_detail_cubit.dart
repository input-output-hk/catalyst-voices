import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  final CampaignService _campaignService;
  CategoryDetailCubit(
    this._campaignService,
  ) : super(const CategoryDetailState(isLoading: true));

  Future<void> getCategories() async {
    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    final categories = await _campaignService.getCampaignCategories();

    final categoriesModels =
        categories.map(DetailedCampaignCategoryViewModel.fromModel).toList();

    emit(
      state.copyWith(
        isLoading: false,
        categories: categoriesModels,
        error: const Optional.empty(),
      ),
    );
  }

  void getCategoryDetail(String categoryId) {
    emit(state.copyWith(isLoading: true));

    try {
      final category = _campaignService.getCategory(categoryId);
      emit(
        state.copyWith(
          isLoading: false,
          category: DetailedCampaignCategoryViewModel.fromModel(category),
          error: const Optional.empty(),
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          category: DetailedCampaignCategoryViewModel.dummy(),
          isLoading: false,
          error: const Optional.of(LocalizedNotFound()),
        ),
      );
    }
  }
}
