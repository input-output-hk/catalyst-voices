import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:equatable/equatable.dart';

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal has been deleted.
final class DeletedProposalBuilderSignal extends ProposalBuilderSignal {
  const DeletedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the email is not verified.
final class EmailNotVerifiedProposalBuilderSignal extends ProposalBuilderSignal {
  const EmailNotVerifiedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal has been successfully forgot.
final class ForgotProposalSuccessBuilderSignal extends ProposalBuilderSignal {
  const ForgotProposalSuccessBuilderSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the max proposals limit has been reached.
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

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal has been successfully forgot.
final class NewProposalAndEmailNotVerifiedSignal extends ProposalBuilderSignal {
  const NewProposalAndEmailNotVerifiedSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal submission close date has been updated.
sealed class ProposalBuilderSignal extends Equatable {
  const ProposalBuilderSignal();
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal submission close date is
/// near to the current date.
final class ProposalSubmissionCloseDate extends ProposalBuilderSignal {
  final DateTime date;

  const ProposalSubmissionCloseDate({required this.date});

  @override
  List<Object?> get props => [date];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal has been published.
final class PublishedProposalBuilderSignal extends ProposalBuilderSignal {
  const PublishedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal was successfully published.
final class ShowPublishConfirmationSignal extends ProposalBuilderSignal {
  final String? proposalTitle;
  final int? currentIteration;
  final int nextIteration;
  final bool hasCollaborators;

  const ShowPublishConfirmationSignal({
    required this.proposalTitle,
    required this.currentIteration,
    required this.nextIteration,
    required this.hasCollaborators,
  });

  @override
  List<Object?> get props => [
    proposalTitle,
    currentIteration,
    nextIteration,
    hasCollaborators,
  ];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the user wants to submit the proposal.
final class ShowSubmitConfirmationSignal extends ProposalBuilderSignal {
  final String? proposalTitle;
  final int? currentIteration;
  final int nextIteration;
  final bool hasCollaborators;

  const ShowSubmitConfirmationSignal({
    required this.proposalTitle,
    required this.currentIteration,
    required this.nextIteration,
    required this.hasCollaborators,
  });

  @override
  List<Object?> get props => [
    proposalTitle,
    currentIteration,
    nextIteration,
    hasCollaborators,
  ];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal was successfully submitted.
final class SubmittedProposalBuilderSignal extends ProposalBuilderSignal {
  const SubmittedProposalBuilderSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalBuilderBloc]. Tells the UI that the proposal needs to be unlocked to be edited.
final class UnlockProposalSignal extends ProposalBuilderSignal {
  final String title;
  final int version;

  const UnlockProposalSignal({
    required this.title,
    required this.version,
  });

  @override
  List<Object?> get props => [title, version];
}
