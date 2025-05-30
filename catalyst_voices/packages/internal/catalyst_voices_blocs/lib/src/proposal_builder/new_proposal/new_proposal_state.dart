import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class NewProposalState extends Equatable {
  final bool isLoading;
  final bool isCreatingProposal;
  final bool isAgreeToCategoryCriteria;
  final bool isAgreeToNoFurtherCategoryChange;
  final ProposalCreationStep step;
  final ProposalTitle title;
  final SignedDocumentRef? categoryRef;
  final List<CampaignCategoryDetailsViewModel> categories;

  const NewProposalState({
    this.isLoading = false,
    this.isCreatingProposal = false,
    this.isAgreeToCategoryCriteria = false,
    this.isAgreeToNoFurtherCategoryChange = false,
    this.step = const CreateProposalWithoutPreselectedCategoryStep(),
    required this.title,
    this.categoryRef,
    this.categories = const [],
  });

  factory NewProposalState.loading() {
    return const NewProposalState(
      isLoading: true,
      title: ProposalTitle.pure(),
    );
  }

  bool get isValid => title.isValid && categoryRef != null && _isAgreementValid;

  @override
  List<Object?> get props => [
        isLoading,
        isCreatingProposal,
        isAgreeToCategoryCriteria,
        isAgreeToNoFurtherCategoryChange,
        step,
        title,
        categoryRef,
        categories,
      ];
  String? get selectedCategoryName =>
      categories.firstWhereOrNull((e) => e.id == categoryRef)?.formattedName;

  bool get _isAgreementValid => isAgreeToCategoryCriteria && isAgreeToNoFurtherCategoryChange;

  NewProposalState copyWith({
    bool? isLoading,
    bool? isCreatingProposal,
    bool? isMissingProposerRole,
    bool? isAgreeToCategoryCriteria,
    bool? isAgreeToNoFurtherCategoryChange,
    ProposalCreationStep? step,
    ProposalTitle? title,
    Optional<SignedDocumentRef>? categoryRef,
    List<CampaignCategoryDetailsViewModel>? categories,
  }) {
    return NewProposalState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingProposal: isCreatingProposal ?? this.isCreatingProposal,
      isAgreeToCategoryCriteria: isAgreeToCategoryCriteria ?? this.isAgreeToCategoryCriteria,
      isAgreeToNoFurtherCategoryChange:
          isAgreeToNoFurtherCategoryChange ?? this.isAgreeToNoFurtherCategoryChange,
      step: step ?? this.step,
      title: title ?? this.title,
      categoryRef: categoryRef.dataOr(this.categoryRef),
      categories: categories ?? this.categories,
    );
  }
}
