import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class NewProposalState extends Equatable {
  final ProposalTitle title;
  final String? categoryId;
  final List<CampaignCategoryDetailsViewModel> categories;

  const NewProposalState({
    required this.title,
    this.categoryId,
    this.categories = const [],
  });

  bool get isValid => title.isValid && categoryId != null;

  @override
  List<Object?> get props => [title, categoryId, categories];

  NewProposalState copyWith({
    ProposalTitle? title,
    Optional<String>? categoryId,
    List<CampaignCategoryDetailsViewModel>? categories,
  }) {
    return NewProposalState(
      title: title ?? this.title,
      categoryId: categoryId.dataOr(this.categoryId),
      categories: categories ?? this.categories,
    );
  }
}
