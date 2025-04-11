import 'package:equatable/equatable.dart';

final class DeletedProposalBuilderSignal extends ProposalBuilderSignal {
  const DeletedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

sealed class ProposalBuilderSignal extends Equatable {
  const ProposalBuilderSignal();
}

final class ProposalSubmissionCloseDate extends ProposalBuilderSignal {
  final DateTime? date;

  const ProposalSubmissionCloseDate({required this.date});

  @override
  List<Object?> get props => [date];
}

final class PublishedProposalBuilderSignal extends ProposalBuilderSignal {
  const PublishedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

final class SubmittedProposalBuilderSignal extends ProposalBuilderSignal {
  const SubmittedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}
