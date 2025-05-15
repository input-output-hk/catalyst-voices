import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class NewProposalState extends Equatable {
  final bool isLoading;
  final bool isCreatingProposal;
  final bool isMissingProposerRole;
  final ProposalTitle title;
  final SignedDocumentRef? categoryId;
  final List<CampaignCategoryDetailsViewModel> categories;

  const NewProposalState({
    this.isLoading = false,
    this.isCreatingProposal = false,
    this.isMissingProposerRole = false,
    required this.title,
    this.categoryId,
    this.categories = const [],
  });

  factory NewProposalState.loading() {
    return const NewProposalState(
      isLoading: true,
      title: ProposalTitle.pure(),
    );
  }

  bool get isValid => title.isValid && categoryId != null;

  @override
  List<Object?> get props => [
        isLoading,
        isCreatingProposal,
        isMissingProposerRole,
        title,
        categoryId,
        categories,
      ];

  NewProposalState copyWith({
    bool? isLoading,
    bool? isCreatingProposal,
    bool? isMissingProposerRole,
    ProposalTitle? title,
    Optional<SignedDocumentRef>? categoryId,
    List<CampaignCategoryDetailsViewModel>? categories,
  }) {
    return NewProposalState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingProposal: isCreatingProposal ?? this.isCreatingProposal,
      isMissingProposerRole: isMissingProposerRole ?? this.isMissingProposerRole,
      title: title ?? this.title,
      categoryId: categoryId.dataOr(this.categoryId),
      categories: categories ?? this.categories,
    );
  }
}
