import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  Campaign? _cacheCampaign;

  VotingMockService(this._votingRepository, this._proposalService, this._campaignService) {
    unawaited(_loadCampaign());
  }

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    await _votingRepository.castVotes(draftVotes);
  }

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) {
    return _votingRepository.getProposalLastCastedVote(proposalRef);
  }

  @override
  Future<VoteProposal> getVoteProposal(DocumentRef proposalRef) async {
    final proposal = await _proposalService.getProposal(ref: proposalRef);
    final lastCastedVote = await getProposalLastCastedVote(proposalRef);

    final category = _cacheCampaign!.categories.firstWhere(
      (category) => proposal.parameters.contains(category.selfRef),
      orElse: () => throw StateError('Category not found'),
    );

    return VoteProposal.fromData(
      proposal: proposal,
      category: category,
      lastCastedVote: lastCastedVote,
    );
  }

  @override
  Stream<List<Vote>> watchedCastedVotes() {
    return _votingRepository.watchCastedVotes;
  }

  Future<void> _loadCampaign() async {
    final campaign = await _campaignService.getActiveCampaign();
    _cacheCampaign = campaign;
  }
}

abstract interface class VotingService {
  factory VotingService(
    VotingRepository votingRepository,
    ProposalService proposalService,
    CampaignService campaignService,
  ) = VotingMockService;

  Future<void> castVotes(List<Vote> draftVotes);

  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef);

  Future<VoteProposal> getVoteProposal(DocumentRef proposalRef);

  Stream<List<Vote>> watchedCastedVotes();
}
