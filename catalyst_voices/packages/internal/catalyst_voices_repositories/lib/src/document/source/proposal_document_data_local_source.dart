import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Specialized version of local documents source. Proposals often
/// require very specific logic and queries and its very hard and to
/// implement those queries in abstract way without know all logic related
/// just to proposals.
abstract interface class ProposalDocumentDataLocalSource {
  /// Retrieves a map of collaborators' actions for a given [proposalsRefs].
  ///
  /// The returned [Map] keys are the document IDs of the proposals, and the
  /// values are [RawProposalCollaboratorsActions] objects, which contain the
  /// actions taken by collaborators on that specific proposal.
  ///
  /// Is important to remember that if given [proposalsRefs] is exact([DocumentRef.isExact])
  /// this method will return [RawCollaboratorAction] for that ref exactly, or null
  /// otherwise. If ref is loose ([DocumentRef.isLoose]), method will return latest
  /// [RawCollaboratorAction] pointing to given [DocumentRef.id].
  ///
  /// This is useful for fetching collaborator data in bulk for multiple
  /// proposals at once.
  Future<Map<String, RawProposalCollaboratorsActions>> getCollaboratorsActions({
    required List<DocumentRef> proposalsRefs,
  });

  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  /// Retrieves titles for all versions of the specified proposals.
  ///
  /// This method extracts the title from each version of a proposal document by
  /// traversing the JSON content using the provided [nodeId].
  ///
  /// **Parameters:**
  /// - [proposalIds]: List of proposal IDs to fetch version titles for.
  /// - [nodeId]: The path in the document JSON to extract the title from.
  /// - [fromLocalDrafts]: Whether to fetch titles from local drafts or final versions.
  ///
  /// **Returns:**
  /// - [ProposalVersionsTitles]
  Future<ProposalVersionsTitles> getVersionsTitles({
    required List<String> proposalIds,
    required NodeId nodeId,
    bool fromLocalDrafts,
  });

  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  Stream<List<DocumentData>> watchProposalTemplates({
    required CampaignFilters campaign,
  });

  Stream<List<RawProposalBrief>> watchRawLocalDraftsProposalsBrief({
    required CatalystId author,
  });

  Stream<Page<RawProposalBrief>> watchRawProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });
}
