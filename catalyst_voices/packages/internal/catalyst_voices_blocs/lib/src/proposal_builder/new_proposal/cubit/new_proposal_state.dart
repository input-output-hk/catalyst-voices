part of 'new_proposal_cubit.dart';

class NewProposalState extends Equatable {
  final String? title;
  final String? categoryId;
  final List<CampaignCategoryViewModel> categories;

  const NewProposalState({
    this.title,
    this.categoryId,
    this.categories = const [],
  });

  bool get isValid => title != null && title != '' && categoryId != null;

  @override
  List<Object?> get props => [title, categoryId, categories];

  NewProposalState copyWith({
    Optional<String>? title,
    Optional<String>? categoryId,
    List<CampaignCategoryViewModel>? categories,
  }) {
    return NewProposalState(
      title: title.dataOr(this.title),
      categoryId: categoryId.dataOr(this.categoryId),
      categories: categories ?? this.categories,
    );
  }
}
