import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A raw representation of a collaborator's action on a proposal.
/// This class encapsulates the action taken by a collaborator regarding a
/// proposal submission, linking the action to a specific proposal.
final class RawCollaboratorAction extends Equatable {
  /// Full ID of collaborator attached to [action].
  final CatalystId id;

  /// A reference to the proposal document this action pertains to.
  final SignedDocumentRef proposalId;

  /// The specific action taken by the collaborator.
  final ProposalSubmissionAction action;

  /// A reference to the action document.
  final SignedDocumentRef actionId;

  const RawCollaboratorAction({
    required this.id,
    required this.proposalId,
    required this.action,
    required this.actionId,
  });

  @override
  List<Object?> get props => [id, proposalId, action, actionId];
}

/// A collection of raw collaborator actions on proposals.
/// This class aggregates actions from multiple collaborators, indexed by their unique [CatalystId].
final class RawProposalCollaboratorsActions extends Equatable {
  /// Map of each collaborator, identified by [CatalystId] and their [RawCollaboratorAction].
  ///
  /// Note. [CatalystId] is a significant [CatalystId].
  /// To get full id use [RawCollaboratorAction.id].
  final Map<CatalystId, RawCollaboratorAction> data;

  const RawProposalCollaboratorsActions(this.data);

  @override
  List<Object?> get props => [data];
}
