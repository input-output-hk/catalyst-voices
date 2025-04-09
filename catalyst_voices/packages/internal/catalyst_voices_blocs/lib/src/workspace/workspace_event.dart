import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class DeleteDraftProposalEvent extends WorkspaceEvent {
  final DraftRef ref;

  const DeleteDraftProposalEvent({required this.ref});

  @override
  List<Object?> get props => [ref];
}

final class ErrorLoadProposalsEvent extends WorkspaceEvent {
  final LocalizedException error;

  const ErrorLoadProposalsEvent(this.error);

  @override
  List<Object?> get props => [error];
}

final class ExportProposal extends WorkspaceEvent {
  final DocumentRef ref;
  final String prefix;

  const ExportProposal(this.ref, this.prefix);

  @override
  List<Object?> get props => [ref, prefix];
}

final class ForgetProposalEvent extends WorkspaceEvent {
  final DocumentRef ref;

  const ForgetProposalEvent(this.ref);

  @override
  List<Object?> get props => [ref];
}

final class GetTimelineItemsEvent extends WorkspaceEvent {
  const GetTimelineItemsEvent();
}

final class ImportProposalEvent extends WorkspaceEvent {
  final Uint8List proposalData;

  const ImportProposalEvent(this.proposalData);

  @override
  List<Object?> get props => proposalData;
}

final class LoadProposalsEvent extends WorkspaceEvent {
  final List<Proposal> proposals;

  const LoadProposalsEvent(this.proposals);

  @override
  List<Object?> get props => [proposals];
}

final class UnlockProposalEvent extends WorkspaceEvent {
  final DocumentRef ref;

  const UnlockProposalEvent(this.ref);

  @override
  List<Object?> get props => [ref];
}

final class WatchUserProposalsEvent extends WorkspaceEvent {
  const WatchUserProposalsEvent();
}

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object?> get props => [];
}
