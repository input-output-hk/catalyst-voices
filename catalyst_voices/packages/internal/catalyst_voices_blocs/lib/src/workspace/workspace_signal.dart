import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ChangeTabWorkspaceSignal extends WorkspaceSignal {
  final WorkspacePageTab tab;

  const ChangeTabWorkspaceSignal(this.tab);

  @override
  List<Object?> get props => [tab];
}

final class DeletedDraftWorkspaceSignal extends WorkspaceSignal {
  const DeletedDraftWorkspaceSignal();
}

final class ForgetProposalSuccessWorkspaceSignal extends WorkspaceSignal {
  const ForgetProposalSuccessWorkspaceSignal();
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

final class SubmissionCloseDate extends WorkspaceSignal {
  final DateTime? date;

  const SubmissionCloseDate({required this.date});

  @override
  List<Object?> get props => [date];
}

sealed class WorkspaceSignal extends Equatable {
  const WorkspaceSignal();

  @override
  List<Object?> get props => [];
}
