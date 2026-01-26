import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class CategoryDetailState extends Equatable {
  final SignedDocumentRef? selectedCategoryRef;
  final CampaignCategoryDetailsViewModel? selectedCategoryDetails;
  final CategoryDetailStatePicker picker;
  final bool isLoading;
  final LocalizedException? error;

  const CategoryDetailState({
    this.selectedCategoryRef,
    this.selectedCategoryDetails,
    this.picker = const CategoryDetailStatePicker(),
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
    selectedCategoryRef,
    selectedCategoryDetails,
    picker,
    isLoading,
    error,
  ];

  CategoryDetailState copyWith({
    Optional<SignedDocumentRef>? selectedCategoryRef,
    Optional<CampaignCategoryDetailsViewModel>? selectedCategoryDetails,
    CategoryDetailStatePicker? picker,
    bool? isLoading,
    Optional<LocalizedException>? error,
  }) {
    return CategoryDetailState(
      selectedCategoryRef: selectedCategoryRef.dataOr(this.selectedCategoryRef),
      selectedCategoryDetails: selectedCategoryDetails.dataOr(this.selectedCategoryDetails),
      picker: picker ?? this.picker,
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
    );
  }
}

final class CategoryDetailStatePicker extends Equatable {
  final List<CategoryDetailStatePickerItem> items;

  const CategoryDetailStatePicker({
    this.items = const [],
  });

  @override
  List<Object?> get props => [items];
}

final class CategoryDetailStatePickerItem extends Equatable {
  final SignedDocumentRef ref;
  final String name;
  final bool isSelected;

  const CategoryDetailStatePickerItem({
    required this.ref,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [ref, name, isSelected];
}
