import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Manages the category detail.
/// Allows to get the category detail and list of categories.
class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  final CampaignService _campaignService;
  Campaign? _cachedCampaign;

  CategoryDetailCubit(
    this._campaignService,
  ) : super(const CategoryDetailState(isLoading: true));

  Future<void> getCategories() async {
    if (_cachedCampaign != null) return;

    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      _cachedCampaign = campaign;
      return emit(
        state.copyWith(
          isLoading: false,
          error: const Optional.of(LocalizedUnknownException()),
        ),
      );
    }

    final categoriesModels = campaign.categories
        .map(CampaignCategoryDetailsViewModel.fromModel)
        .toList();

    emit(
      state.copyWith(
        categories: categoriesModels,
        error: const Optional.empty(),
      ),
    );
  }

  Future<void> getCategoryDetail(SignedDocumentRef categoryRef) async {
    if (categoryRef.id == state.category?.ref.id) return;

    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final category = await _campaignService.getCategory(DocumentParameters({categoryRef}));
      emit(
        state.copyWith(
          isLoading: false,
          category: CampaignCategoryDetailsViewModel.fromModel(category),
          error: const Optional.empty(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          category: CampaignCategoryDetailsViewModel.dummy(),
          isLoading: false,
          error: Optional.of(LocalizedException.create(error)),
        ),
      );
    }
  }
}
