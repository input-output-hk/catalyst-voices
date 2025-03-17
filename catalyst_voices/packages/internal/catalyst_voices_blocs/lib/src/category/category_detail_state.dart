import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class CategoryDetailState extends Equatable {
  final CampaignCategoryDetailsViewModel? category;
  final List<CampaignCategoryDetailsViewModel> categories;
  final bool isLoading;
  final LocalizedException? error;

  const CategoryDetailState({
    this.category,
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        category,
        categories,
        isLoading,
        error,
      ];

  CategoryDetailState copyWith({
    CampaignCategoryDetailsViewModel? category,
    List<CampaignCategoryDetailsViewModel>? categories,
    bool? isLoading,
    Optional<LocalizedException>? error,
  }) {
    return CategoryDetailState(
      category: category ?? this.category,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
    );
  }
}
