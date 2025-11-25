import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/collaborators/collaborator.dart';
import 'package:equatable/equatable.dart';

final class AcceptedCollaborators extends Collaborators {
  const AcceptedCollaborators(super.collaborators);
}

final class AllCollaborators extends Collaborators {
  const AllCollaborators(super.collaborators);
}

sealed class Collaborators extends Equatable {
  final List<Collaborator> collaborators;

  const Collaborators([this.collaborators = const []]);

  /// Filters collaborator by [activeAccountId].
  /// - Returns all [collaborators] if [activeAccountId] is [authorId] or one of [collaborators].
  /// - Returns collaborators with [CollaboratorInvitationStatus.accepted] status otherwise.
  factory Collaborators.filterByActiveAccount({
    required CatalystId? activeAccountId,
    required CatalystId? authorId,
    required List<Collaborator> collaborators,
  }) {
    if (activeAccountId != null && authorId != null && activeAccountId.isSameAs(authorId)) {
      return AllCollaborators(collaborators);
    }

    if (activeAccountId != null &&
        collaborators.any((e) => e.catalystId.isSameAs(activeAccountId))) {
      return AllCollaborators(collaborators);
    }

    return AcceptedCollaborators(
      collaborators.where((e) => e.status == CollaboratorInvitationStatus.accepted).toList(),
    );
  }

  @override
  List<Object?> get props => [collaborators];
}
