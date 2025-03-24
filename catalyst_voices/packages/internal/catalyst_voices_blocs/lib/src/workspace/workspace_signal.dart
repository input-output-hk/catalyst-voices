import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DeletedDraftWorkspaceSignal extends WorkspaceSignal {
  const DeletedDraftWorkspaceSignal();

  @override
  List<Object?> get props => [];
}

final class ImportedProposalWorkspaceSignal extends WorkspaceSignal {
  final DocumentRef proposalRef;

  const ImportedProposalWorkspaceSignal({required this.proposalRef});

  @override
  List<Object?> get props => [proposalRef];
}

final class OpenProposalBuilderSignal extends WorkspaceSignal {
  final DocumentRef ref;

  const OpenProposalBuilderSignal({required this.ref});

  @override
  List<Object?> get props => [ref];
}

sealed class WorkspaceSignal extends Equatable {
  const WorkspaceSignal();
}