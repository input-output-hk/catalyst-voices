import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ErrorLoadProposalsEvent extends WorkspaceEvent {
  final LocalizedException error;

  const ErrorLoadProposalsEvent(this.error);

  @override
  List<Object?> get props => [error];
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

final class WatchUserProposalsEvent extends WorkspaceEvent {
  const WatchUserProposalsEvent();

  @override
  List<Object?> get props => [];
}

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}
