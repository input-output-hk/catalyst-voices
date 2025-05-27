import 'package:equatable/equatable.dart';

enum CreateProposalStage {
  setTitle,
  selectCategory,
}

final class CreateProposalWithoutPreselectedCategoryStep extends ProposalCreationStep {
  final CreateProposalStage stage;

  const CreateProposalWithoutPreselectedCategoryStep({
    this.stage = CreateProposalStage.setTitle,
  });

  

  @override
  List<Object?> get props => [stage];
}

final class CreateProposalWithPreselectedCategoryStep extends ProposalCreationStep {
  const CreateProposalWithPreselectedCategoryStep();
}

sealed class ProposalCreationStep extends Equatable {
  const ProposalCreationStep();

  @override
  List<Object?> get props => [];
}
