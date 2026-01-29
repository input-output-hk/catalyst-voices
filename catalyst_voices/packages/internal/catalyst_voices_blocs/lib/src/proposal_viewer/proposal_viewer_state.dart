import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

class ProposalViewerState extends DocumentViewerState<ProposalViewData>
    implements DocumentViewerStateWithComments {
  final CollaboratorProposalState collaborator;

  @override
  final CommentsState comments;

  const ProposalViewerState({
    super.isLoading,
    super.data = const ProposalViewData(),
    super.error,
    this.collaborator = const NoneCollaboratorProposalState(),
    this.comments = const CommentsState(),
  });

  @override
  List<Object?> get props => [...super.props, collaborator, comments];

  @override
  ProposalViewerState copyWith({
    bool? isLoading,
    ProposalViewData? data,
    Optional<LocalizedException>? error,
    bool? readOnlyMode,
    CollaboratorProposalState? collaborator,
    CommentsState? comments,
  }) {
    return ProposalViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error.dataOr(this.error),
      collaborator: collaborator ?? this.collaborator,
      comments: comments ?? this.comments,
    );
  }
}
