import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

abstract interface class CampaignService {
  const factory CampaignService(
    CampaignRepository campaignRepository,
    ProposalRepository documentRepository,
  ) = CampaignServiceImpl;

  Future<Campaign?> getActiveCampaign();

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<List<CampaignCategory>> getCampaignCategories();

  Future<List<CampaignTimeline>> getCampaignTimeline();

  Future<CampaignTimeline> getCampaignTimelineByStage(CampaignTimelineStage stage);

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CurrentCampaign> getCurrentCampaign();
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;
  final ProposalRepository _proposalRepository;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._proposalRepository,
  );

  @override
  Future<Campaign?> getActiveCampaign() => getCampaign(id: 'F14');

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final campaignBase = await _campaignRepository.getCampaign(id: id);

    // TODO(damian-molinski): get proposalTemplateRef, document and map.

    final campaign = campaignBase.toCampaign();

    return campaign;
  }

  @override
  Future<List<CampaignCategory>> getCampaignCategories() async {
    final categories = await _campaignRepository.getCampaignCategories();
    final updatedCategories = <CampaignCategory>[];

    for (final category in categories) {
      final categoryProposals = await _proposalRepository.getProposals(
        type: ProposalsFilterType.finals,
        categoryRef: category.selfRef,
      );
      final totalAsk = _calculateTotalAsk(categoryProposals);

      final updatedCategory = category.copyWith(
        totalAsk: totalAsk,
        proposalsCount: categoryProposals.length,
      );
      updatedCategories.add(updatedCategory);
    }
    return updatedCategories;
  }

  @override
  Future<List<CampaignTimeline>> getCampaignTimeline() {
    return _campaignRepository.getCampaignTimeline();
  }

  @override
  Future<CampaignTimeline> getCampaignTimelineByStage(CampaignTimelineStage stage) async {
    final timeline = await getCampaignTimeline();
    final timelineStage = timeline.firstWhere(
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
    final totalAsk = _calculateTotalAsk(categoryProposals);

    return category.copyWith(
      totalAsk: totalAsk,
      proposalsCount: categoryProposals.length,
    );
  }

  @override
  Future<CurrentCampaign> getCurrentCampaign() async {
    final currentCampaign = await _campaignRepository.getCurrentCampaign();
    final campaignProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
    );
    final totalAsk = _calculateTotalAsk(campaignProposals);

    return currentCampaign.copyWith(totalAsk: totalAsk);
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
