import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/collaborators/collaborator_state.dart';
import 'package:equatable/equatable.dart';

/// View model representing proposal metadata in a view mode
final class ProposalViewMetadata extends Equatable {
  final Profile author;
  final Collaborators collaborators;
  final String? description;
  final ProposalPublish status;
  final DateTime? createdAt;
  final bool warningCreatedAt;
  final String? tag;
  final int? commentsCount;
  final Money? fundsRequested;
  final int? projectDuration;
  final int? milestoneCount;

  const ProposalViewMetadata({
    required this.author,
    required this.collaborators,
    this.description,
    required this.status,
    required this.createdAt,
    required this.warningCreatedAt,
    this.tag,
    required this.commentsCount,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  List<Object?> get props => [
    author,
    collaborators,
    description,
    status,
    createdAt,
    warningCreatedAt,
    tag,
    commentsCount,
    fundsRequested,
    projectDuration,
    milestoneCount,
  ];
}
