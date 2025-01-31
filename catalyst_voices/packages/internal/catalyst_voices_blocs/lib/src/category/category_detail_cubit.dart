import 'dart:math';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'category_detail_state.dart';

class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  CategoryDetailCubit(this._campaignService)
      : super(const CategoryDetailLoading());

  void loadCategoryDetail(CampaignCategoryViewModel category) {
    emit(CategoryDetailData(category: category));
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
}
