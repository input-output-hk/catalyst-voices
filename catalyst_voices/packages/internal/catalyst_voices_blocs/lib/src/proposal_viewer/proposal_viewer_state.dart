import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class ProposalViewerState extends DocumentViewerState {
  final CollaboratorProposalState collaborator;

  const ProposalViewerState({
    super.isLoading,
    super.data,
    super.error,
    super.readOnlyMode,
    this.collaborator = const NoneCollaboratorProposalState(),
  });

  @override
  List<Object?> get props => [...super.props, collaborator];

  @override
  ProposalViewerState copyWith({
    bool? isLoading,
    DocumentViewData? data,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
    CollaboratorProposalState? collaborator,
  }) {
    return ProposalViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error.dataOr(this.error),
      readOnlyMode: readOnlyMode ?? this.readOnlyMode,
      collaborator: collaborator ?? this.collaborator,
    );
  }
}
