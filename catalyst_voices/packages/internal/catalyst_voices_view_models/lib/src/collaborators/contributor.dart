import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/collaborators/collaborator.dart';
import 'package:equatable/equatable.dart';

/// A collaborator on the proposal or the author.
final class Contributor extends Equatable {
  final CatalystId id;
  final ProposalsCollaborationStatus status;
  final bool isAuthor;
  final DateTime? createdAt;

  const Contributor({
    required this.id,
    required this.status,
    required this.isAuthor,
    this.createdAt,
  });

  factory Contributor.fromCollaborator(Collaborator collaborator, CatalystId? authorId) {
    return Contributor(
      id: collaborator.id,
      status: collaborator.status,
      isAuthor: authorId.isSameAs(collaborator.id),
      createdAt: collaborator.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, status, isAuthor, createdAt];
}
