part of 'campaign_categories_cubit.dart';

final class CampaignCategoriesState extends Equatable {
  final bool isLoading;
  final List<CampaignCategoryCardViewModel> categories;
  final LocalizedException? error;

  const CampaignCategoriesState({
    this.isLoading = false,
    this.categories = const [],
    this.error,
  });

  bool get showCategories =>
      !isLoading && categories.isNotEmpty && error == null;

  bool get showError => !isLoading && error != null;

  CampaignCategoriesState copyWith({
    bool? isLoading,
    List<CampaignCategoryCardViewModel>? categories,
    Optional<LocalizedException>? error,
  }) {
    return CampaignCategoriesState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      error: error.dataOr(this.error),
    );
  }

  CampaignCategoriesState loading() {
    return const CampaignCategoriesState(
      isLoading: true,
      categories: [],
      error: null,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        categories,
        error,
      ];
}
