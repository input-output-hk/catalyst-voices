import 'package:equatable/equatable.dart';

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}

final class LoadCurrentProposalEvent extends WorkspaceEvent {
  const LoadCurrentProposalEvent();

  @override
  List<Object?> get props => [];
}
