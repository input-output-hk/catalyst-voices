import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Contains all optional features (comments, collaborators, etc.).
/// Mixins interact only with the fields they need.
///
/// The generic parameter T allows copyWith methods to return the concrete type,
/// eliminating the need for `as T` casts.
abstract base class DocumentViewerCache<T extends DocumentViewerCache<T>> extends Equatable {
  final DocumentRef? id;
  final CatalystId? activeAccountId;
  final DocumentParameters? documentParameters;

  // Optional features - only used by specific mixins
  final List<CommentWithReplies>? comments;
  final CommentTemplate? commentTemplate;
  final CollaboratorProposalState? collaboratorsState;

  const DocumentViewerCache({
    this.id,
    this.activeAccountId,
    this.documentParameters,
    this.comments,
    this.commentTemplate,
    this.collaboratorsState,
  });

  @override
  List<Object?> get props => [
    id,
    activeAccountId,
    documentParameters,
    comments,
    commentTemplate,
    collaboratorsState,
  ];

  T copyWith({
    Optional<DocumentRef>? id,
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentParameters>? documentParameters,
    Optional<List<CommentWithReplies>>? comments,
    Optional<CommentTemplate>? commentTemplate,
    CollaboratorProposalState? collaboratorsState,
  });
}
