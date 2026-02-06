import 'package:equatable/equatable.dart';

/// Represents the result of validating a collaborator's eligibility.
sealed class CollaboratorValidationResult extends Equatable {
  const CollaboratorValidationResult();

  /// Returns true if the collaborator is invalid.
  bool get isInvalid => !isValid;

  /// Returns true if the collaborator is valid.
  bool get isValid => this is ValidCollaborator;

  @override
  List<Object?> get props => [];
}

/// Indicates that the collaborator is missing the proposer role.
final class MissingProposerRole extends CollaboratorValidationResult {
  const MissingProposerRole();
}

/// Indicates that the collaborator is neither a proposer nor has a verified profile.
final class NotProposerAndNotVerified extends CollaboratorValidationResult {
  const NotProposerAndNotVerified();
}

/// Indicates that the collaborator does not have a verified profile.
final class NotVerifiedProfile extends CollaboratorValidationResult {
  const NotVerifiedProfile();
}

/// Indicates that the collaborator is valid and meets all requirements.
final class ValidCollaborator extends CollaboratorValidationResult {
  const ValidCollaborator();
}
