import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ImportedProposalWorkspaceSignal extends WorkspaceSignal {
  final DocumentRef proposalRef;

  const ImportedProposalWorkspaceSignal({required this.proposalRef});

  @override
  List<Object?> get props => [proposalRef];
}

sealed class WorkspaceSignal extends Equatable {
  const WorkspaceSignal();
}
