import 'package:equatable/equatable.dart';

final class DeletedProposalBuilderSignal extends ProposalBuilderSignal {
  const DeletedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

final class EmailNotVerifiedProposalBuilderSignal extends ProposalBuilderSignal {
  const EmailNotVerifiedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

final class MaxProposalsLimitReachedSignal extends ProposalBuilderSignal {
  final int currentSubmissions;
  final int maxSubmissions;
  final DateTime proposalSubmissionCloseDate;

  const MaxProposalsLimitReachedSignal({
    required this.proposalSubmissionCloseDate,
    required this.currentSubmissions,
    required this.maxSubmissions,
  });

  @override
  List<Object?> get props => [
        proposalSubmissionCloseDate,
        currentSubmissions,
        maxSubmissions,
      ];
}

sealed class ProposalBuilderSignal extends Equatable {
  const ProposalBuilderSignal();
}

final class ProposalSubmissionCloseDate extends ProposalBuilderSignal {
  final DateTime date;

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
