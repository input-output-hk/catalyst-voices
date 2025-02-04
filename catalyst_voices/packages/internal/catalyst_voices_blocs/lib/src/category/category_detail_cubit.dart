import 'dart:math';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  final DiscoveryCubit _discoveryCubit;
  CategoryDetailCubit(
    this._campaignService,
    this._discoveryCubit,
  ) : super(const CategoryDetailLoading());

  void loadCategoryDetail(CampaignCategoryViewModel category) {
    emit(CategoryDetailData(category: category, categories: state.categories));
  }

  Future<void> getCategoryDetail(String categoryId) async {
    if (state is! CategoryDetailLoading) {
      emit(const CategoryDetailLoading());
    }

    final isSuccess = await Future.delayed(
      const Duration(seconds: 2),
      () => Random().nextBool(),
    );

    if (isClosed) return;
    if (isSuccess) {
      emit(
        CategoryDetailData(
          category: CampaignCategoryViewModel.dummy(),
          categories: state.categories,
        ),
      );
    } else {
      emit(
        const CategoryDetailError(
          error: LocalizedUnknownException(),
        ),
      );
    }
  }

  Future<void> init(String categoryId) async {
    final discoveryCategory = _discoveryCubit.localCategory(categoryId);
    final categories = _discoveryCubit.state.campaignCategories.categories;
    if (discoveryCategory != null) {
      loadCategoryDetail(discoveryCategory);
    } else {
      await getCategoryDetail(categoryId);
    }

    if (categories.isNotEmpty) {
      emit(state.copyWith(categories: categories));
    } else {
      await getCategories();
    }
  }

  Future<void> getCategories() async {
    // TODO(LynxLynxx): use real service
    final categories = List.generate(
      6,
      (index) => CampaignCategoryViewModel.dummy(id: index.toString()),
    );
    emit(state.copyWith(categories: categories));
  }

  Future<void> changeCategory(String categoryId) async {
    final categories = state.categories;

    if (categories.isEmpty) {
      await getCategoryDetail(categoryId);
    } else {
      final category = categories.firstWhere((e) => e.id == categoryId);
      loadCategoryDetail(category);
    }
  }
}
