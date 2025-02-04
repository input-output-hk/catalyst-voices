import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

sealed class CategoryDetailState extends Equatable {
  final List<CampaignCategoryViewModel> categories;
  const CategoryDetailState({
    this.categories = const [],
  });

  CategoryDetailState copyWith({List<CampaignCategoryViewModel>? categories});

  @override
  List<Object?> get props => [categories];
}

final class CategoryDetailLoading extends CategoryDetailState {
  const CategoryDetailLoading({super.categories});

  @override
  CategoryDetailLoading copyWith({
    List<CampaignCategoryViewModel>? categories,
  }) {
    return CategoryDetailLoading(
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}

final class CategoryDetailData extends CategoryDetailState {
  final CampaignCategoryViewModel category;

  const CategoryDetailData({required this.category, super.categories});

  @override
  CategoryDetailData copyWith({
    List<CampaignCategoryViewModel>? categories,
    CampaignCategoryViewModel? category,
  }) {
    return CategoryDetailData(
      categories: categories ?? this.categories,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [...super.props, category];
}

final class CategoryDetailError extends CategoryDetailState {
  final LocalizedException error;

  const CategoryDetailError({required this.error, super.categories});

  @override
  CategoryDetailError copyWith({
    List<CampaignCategoryViewModel>? categories,
    LocalizedException? error,
  }) {
    return CategoryDetailError(
      categories: categories ?? this.categories,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [...super.props, error];
}
