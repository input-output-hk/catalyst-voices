import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/category/category_detail_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('CategoryDetailCubit');

/// Manages the category detail.
/// Allows to get the category detail and list of categories.
class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  final CampaignService _campaignService;

  CategoryDetailCubitCache _cache = const CategoryDetailCubitCache();

  StreamSubscription<List<CampaignCategory>?>? _categoriesSub;
  StreamSubscription<CampaignCategoryTotalAsk>? _selectedCategoryTotalAskSub;

  CategoryDetailCubit(
    this._campaignService,
  ) : super(const CategoryDetailState(isLoading: true));

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    _categoriesSub = null;

    await _selectedCategoryTotalAskSub?.cancel();
    _selectedCategoryTotalAskSub = null;

    await super.close();
  }

  Future<void> getCategoryDetail(SignedDocumentRef categoryRef) async {
    if (categoryRef.id == _cache.selectedCategoryRef?.id) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    await _selectedCategoryTotalAskSub?.cancel();
    _selectedCategoryTotalAskSub = null;

    _cache = _cache.copyWith(
      selectedCategoryRef: Optional(categoryRef),
      selectedCategory: const Optional.empty(),
      selectedCategoryTotalAsk: const Optional.empty(),
    );

    emit(state.copyWith(selectedCategoryRef: Optional(categoryRef)));
    _updateCategoriesState();

    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final category = await _campaignService.getCategory(DocumentParameters({categoryRef}));
      _cache = _cache.copyWith(selectedCategory: Optional(category));

      _watchCategoryTotalAsk(categoryRef);
      _updateSelectedCategoryState();
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          error: Optional.of(LocalizedException.create(error)),
        ),
      );
    }
  }

  void watchActiveCampaignCategories() {
    unawaited(_categoriesSub?.cancel());
    _categoriesSub = _campaignService.watchActiveCampaign
        .map((event) => event?.categories)
        .distinct(listEquals)
        .listen(_handleCategoriesChange);
  }

  void _handleCategoriesChange(List<CampaignCategory>? categories) {
    _cache = _cache.copyWith(categories: Optional(categories));
    _updateCategoriesState();
  }

  void _handleCategoryTotalAskChange(CampaignCategoryTotalAsk data) {
    _logger.finest('Category total ask changed: $data');
    _cache = _cache.copyWith(selectedCategoryTotalAsk: Optional(data));
    _updateSelectedCategoryState();
  }

  void _updateCategoriesState() {
    final selectedCategoryRef = _cache.selectedCategoryRef;
    final categories = _cache.categories ?? [];

    final items = categories.map(
      (category) {
        return CategoryDetailStatePickerItem(
          ref: category.id,
          name: category.formattedCategoryName,
          isSelected: category.id == selectedCategoryRef,
        );
      },
    ).toList();

    emit(state.copyWith(picker: CategoryDetailStatePicker(items: items)));
  }

  void _updateSelectedCategoryState() {
    final selectedCategory = _cache.selectedCategory;
    final selectedCategoryTotalAsk = _cache.selectedCategoryTotalAsk;

    final selectedCategoryState = selectedCategory != null
        ? CampaignCategoryDetailsViewModel.fromModel(
            selectedCategory,
            finalProposalsCount: selectedCategoryTotalAsk?.finalProposalsCount ?? 0,
            totalAsk: selectedCategoryTotalAsk?.totalAsk ?? MultiCurrencyAmount.zero(),
          )
        : null;

    final updatedState = state.copyWith(
      isLoading: selectedCategory == null || selectedCategoryTotalAsk == null,
      selectedCategoryDetails: Optional(selectedCategoryState),
      error: const Optional.empty(),
    );

    emit(updatedState);
  }

  void _watchCategoryTotalAsk(SignedDocumentRef ref) {
    unawaited(_selectedCategoryTotalAskSub?.cancel());
    _selectedCategoryTotalAskSub = _campaignService
        .watchCategoryTotalAsk(ref: ref)
        .distinct()
        .listen(_handleCategoryTotalAskChange);
  }
}
