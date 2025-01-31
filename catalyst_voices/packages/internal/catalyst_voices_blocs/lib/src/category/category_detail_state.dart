part of 'category_detail_cubit.dart';

@immutable
sealed class CategoryDetailState extends Equatable {
  const CategoryDetailState();
}

final class CategoryDetailLoading extends CategoryDetailState {
  const CategoryDetailLoading();

  @override
  List<Object?> get props => [];
}

final class CategoryDetailData extends CategoryDetailState {
  final CampaignCategoryViewModel category;

  const CategoryDetailData({required this.category});

  @override
  List<Object?> get props => [];
}

final class CategoryDetailError extends CategoryDetailState {
  final LocalizedException error;

  const CategoryDetailError({required this.error});

  @override
  List<Object?> get props => [error];
}
