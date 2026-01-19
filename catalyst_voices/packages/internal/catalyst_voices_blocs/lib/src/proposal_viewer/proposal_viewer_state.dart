import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class ProposalViewerState extends DocumentViewerState {
  final CollaboratorProposalState collaborator;
  final CommentsState comments;

  const ProposalViewerState({
    super.isLoading,
    super.data,
    super.error,
    super.readOnlyMode,
    this.collaborator = const NoneCollaboratorProposalState(),
    this.comments = const CommentsState(),
  });

  @override
  List<Object?> get props => [...super.props, collaborator, comments];

  @override
  ProposalViewerState copyWith({
    bool? isLoading,
    DocumentViewerData? data,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
    CollaboratorProposalState? collaborator,
    CommentsState? comments,
  }) {
    return ProposalViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error.dataOr(this.error),
      readOnlyMode: readOnlyMode ?? this.readOnlyMode,
      collaborator: collaborator ?? this.collaborator,
      comments: comments ?? this.comments,
    );
  }
}
