import 'dart:math';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  CategoryDetailCubit(
    this._campaignService,
  ) : super(const CategoryDetailState(isLoading: true));

  Future<void> getCategoryDetail(String categoryId) async {
    emit(state.copyWith(isLoading: true));

    final isSuccess = await Future.delayed(
      const Duration(seconds: 1),
      () => Random().nextBool(),
    );

    // TODO(LynxLynxx): get data from campaignService

    emit(
      state.copyWith(
        category: CampaignCategoryViewModel.dummy(id: categoryId),
        isLoading: false,
        error: isSuccess
            ? const Optional.empty()
            : const Optional.of(LocalizedUnknownException()),
      ),
    );
  }

  Future<void> getCategories() async {
    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
    }

    // TODO(LynxLynxx): get data from campaignService

    final categories = List.generate(
      6,
      (index) => CampaignCategoryViewModel.dummy(id: index.toString()),
    );

    emit(
      state.copyWith(
        isLoading: false,
        categories: categories,
        error: const Optional.empty(),
      ),
    );
  }
}
