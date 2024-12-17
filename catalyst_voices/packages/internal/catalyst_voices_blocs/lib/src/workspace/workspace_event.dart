import 'package:equatable/equatable.dart';

sealed class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();
}

final class LoadProposalsEvent extends WorkspaceEvent {
  const LoadProposalsEvent();

  @override
  List<Object?> get props => [];
}
