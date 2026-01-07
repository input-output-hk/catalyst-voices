import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
  final Range<int?>? titleLengthRange;
  final SignedDocumentRef? categoryRef;
  final NewProposalStateCategories categories;

  const NewProposalState({
    this.isLoading = false,
    this.isCreatingProposal = false,
    this.isAgreeToCategoryCriteria = false,
    this.isAgreeToNoFurtherCategoryChange = false,
    this.step = const CreateProposalWithoutPreselectedCategoryStep(),
    required this.title,
    this.titleLengthRange,
    this.categoryRef,
    this.categories = const NewProposalStateCategories(),
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
    titleLengthRange,
    categoryRef,
    categories,
  ];

  String? get selectedCategoryName => categories.selected?.formattedName;

  bool get _isAgreementValid => isAgreeToCategoryCriteria && isAgreeToNoFurtherCategoryChange;

  NewProposalState copyWith({
    bool? isLoading,
    bool? isCreatingProposal,
    bool? isMissingProposerRole,
    bool? isAgreeToCategoryCriteria,
    bool? isAgreeToNoFurtherCategoryChange,
    ProposalCreationStep? step,
    ProposalTitle? title,
    Optional<Range<int?>>? titleLengthRange,
    Optional<SignedDocumentRef>? categoryRef,
    NewProposalStateCategories? categories,
  }) {
    return NewProposalState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingProposal: isCreatingProposal ?? this.isCreatingProposal,
      isAgreeToCategoryCriteria: isAgreeToCategoryCriteria ?? this.isAgreeToCategoryCriteria,
      isAgreeToNoFurtherCategoryChange:
          isAgreeToNoFurtherCategoryChange ?? this.isAgreeToNoFurtherCategoryChange,
      step: step ?? this.step,
      title: title ?? this.title,
      titleLengthRange: titleLengthRange.dataOr(this.titleLengthRange),
      categoryRef: categoryRef.dataOr(this.categoryRef),
      categories: categories ?? this.categories,
    );
  }
}

final class NewProposalStateCategories extends Equatable {
  final List<CampaignCategoryDetailsViewModel>? categories;
  final SignedDocumentRef? selectedRef;

  const NewProposalStateCategories({
    this.categories,
    this.selectedRef,
  });

  @override
  List<Object?> get props => [
    categories,
    selectedRef,
  ];

  CampaignCategoryDetailsViewModel? get selected =>
      categories?.firstWhereOrNull((element) => element.ref.id == selectedRef?.id);

  NewProposalStateCategories copyWith({
    Optional<List<CampaignCategoryDetailsViewModel>>? categories,
    Optional<SignedDocumentRef>? selectedRef,
  }) {
    return NewProposalStateCategories(
      categories: categories.dataOr(this.categories),
      selectedRef: selectedRef.dataOr(this.selectedRef),
    );
  }
}
