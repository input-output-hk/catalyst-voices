import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class NewProposalState extends Equatable {
  final String? title;
  final String? categoryId;
  final List<CampaignCategoryDetailsViewModel> categories;

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
    List<CampaignCategoryDetailsViewModel>? categories,
  }) {
    return NewProposalState(
      title: title.dataOr(this.title),
      categoryId: categoryId.dataOr(this.categoryId),
      categories: categories ?? this.categories,
    );
  }
}
