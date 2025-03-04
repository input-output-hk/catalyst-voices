import 'package:equatable/equatable.dart';

final class DeletedProposalBuilderSignal extends ProposalBuilderSignal {
  const DeletedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

sealed class ProposalBuilderSignal extends Equatable {
  const ProposalBuilderSignal();
}
