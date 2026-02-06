import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;
  final ProposalService _proposalService;
  final CampaignService _campaignService;

  VotingMockService(this._votingRepository, this._proposalService, this._campaignService);

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
    final proposal = await _proposalService.getProposal(id: proposalRef);
    final lastCastedVote = await getProposalLastCastedVote(proposalRef);
    // TODO(dt-iohk): consider to use campaign assigned to the proposal
    final campaign = await _campaignService.getActiveCampaign();

    final category = campaign!.categories.firstWhere(
      (category) => proposal.parameters.contains(category.id),
      orElse: () => throw NotFoundException(message: 'Category not found in ${campaign.id}'),
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
