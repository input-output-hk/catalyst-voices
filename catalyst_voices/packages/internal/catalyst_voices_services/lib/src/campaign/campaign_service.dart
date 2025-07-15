import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class CampaignService {
  const factory CampaignService(
    CampaignRepository campaignRepository,
    ProposalRepository documentRepository,
  ) = CampaignServiceImpl;

  Future<Campaign?> getActiveCampaign();

  Future<CampaignDetail> getActiveCampaignBrief();

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<CampaignTimeline> getCampaignTimeline();

  Future<CampaignPhase> getCampaignTimelineByStage(CampaignPhaseStage stage);

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;
  final ProposalRepository _proposalRepository;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._proposalRepository,
  );

  @override
  Future<Campaign?> getActiveCampaign() => getCampaign(id: F14Campaign.f14Ref.id);

  @override
  Future<CampaignDetail> getActiveCampaignBrief() async {
    final currentCampaign = await getActiveCampaign();
    if (currentCampaign == null) {
      throw StateError('No active campaign found');
    }
    final campaignProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
    );
    final totalAsk = _calculateTotalAsk(campaignProposals);

    return CampaignDetail.fromCampaign(currentCampaign, totalAsk);
  }

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final campaign = await _campaignRepository.getCampaign(id: id);

    return campaign;
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    final categories = await _campaignRepository.getCampaignCategories();
    final updatedCategories = <CampaignCategory>[];
    final proposalSubmissionStage =
        await getCampaignTimelineByStage(CampaignPhaseStage.proposalSubmission);

    for (final category in categories) {
      final categoryProposals = await _proposalRepository.getProposals(
        type: ProposalsFilterType.finals,
        categoryRef: category.selfRef,
      );
      final totalAsk = _calculateTotalAsk(categoryProposals);

      final updatedCategory = category.copyWith(
        totalAsk: totalAsk,
        proposalsCount: categoryProposals.length,
        submissionCloseDate: proposalSubmissionStage.timeline.to,
      );
      updatedCategories.add(updatedCategory);
    }
    return updatedCategories;
  }

  @override
  Future<CampaignTimeline> getCampaignTimeline() {
    return _campaignRepository.getCampaignTimeline();
  }

  @override
  Future<CampaignPhase> getCampaignTimelineByStage(CampaignPhaseStage stage) async {
    final timeline = await getCampaignTimeline();
    final timelineStage = timeline.phases.firstWhere(
      (element) => element.stage == stage,
      orElse: () => throw (StateError('Stage $stage not found')),
    );
    return timelineStage;
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    final category = await _campaignRepository.getCategory(ref);
    final categoryProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
      categoryRef: ref,
    );
    final proposalSubmissionStage =
        await getCampaignTimelineByStage(CampaignPhaseStage.proposalSubmission);
    final totalAsk = _calculateTotalAsk(categoryProposals);

    return category.copyWith(
      totalAsk: totalAsk,
      proposalsCount: categoryProposals.length,
      submissionCloseDate: proposalSubmissionStage.timeline.to,
    );
  }

  Coin _calculateTotalAsk(List<ProposalData> proposals) {
    var totalAskBalance = const Balance.zero();
    for (final proposal in proposals) {
      final fundsRequested = proposal.document.fundsRequested;
      final askBalance = Balance(coin: fundsRequested ?? const Coin(0));

      totalAskBalance += askBalance;
    }
    return totalAskBalance.coin;
  }
}
