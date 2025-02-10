import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final List<ProposalViewModel> proposals;
  final List<CampaignCategoryViewModel> categories;
  final CampaignCategoryViewModel? selectedCategory;
  final bool isLoading;
  final LocalizedException? error;

  const ProposalsState({
    this.proposals = const [],
    this.categories = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  ProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    List<CampaignCategoryViewModel>? categories,
    CampaignCategoryViewModel? selectedCategory,
    bool? isLoading,
    Optional<LocalizedException>? error,
  }) {
    return ProposalsState(
      proposals: proposals ?? this.proposals,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
    );
  }

  @override
  List<Object?> get props => [
        proposals,
        categories,
        selectedCategory,
        isLoading,
        error,
      ];
}
