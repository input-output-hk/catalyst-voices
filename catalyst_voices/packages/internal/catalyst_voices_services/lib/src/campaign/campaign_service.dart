import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/campaign/active_campaign_observer.dart';
import 'package:flutter/foundation.dart';

Campaign? _mockedActiveCampaign;

/// Overrides the current campaign returned by [CampaignService.getActiveCampaign].
/// Only for unit testing.
@visibleForTesting
//ignore: avoid_setters_without_getters
set mockedActiveCampaign(Campaign? campaign) {
  _mockedActiveCampaign = campaign;
}

/// CampaignService provides campaign-related functionality.
///
/// [CampaignRepository] is used to get the campaign data.
/// [ProposalRepository] is used to get specific information about proposals that are related to the campaign.
/// like total ask, proposals count, etc, with need to be calculated.
abstract interface class CampaignService {
  const factory CampaignService(
    CampaignRepository campaignRepository,
    ProposalRepository proposalRepository,
    ActiveCampaignObserver activeCampaignObserver,
  ) = CampaignServiceImpl;

  Stream<Campaign?> get watchActiveCampaign;

  Future<Campaign?> getActiveCampaign();

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignPhase> getCampaignPhaseTimeline(CampaignPhaseType stage);

  Future<CampaignCategory> getCategory(DocumentParameters parameters);
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;
  final ProposalRepository _proposalRepository;
  final ActiveCampaignObserver _activeCampaignObserver;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._proposalRepository,
    this._activeCampaignObserver,
  );

  @override
  Stream<Campaign?> get watchActiveCampaign => _activeCampaignObserver.watchCampaign;

  @override
  Future<Campaign?> getActiveCampaign() async {
    if (_activeCampaignObserver.campaign != null) {
      return _activeCampaignObserver.campaign;
    }
    // TODO(LynxLynxx): Call backend to get latest active campaign
    final campaign = _mockedActiveCampaign ?? await getCampaign(id: activeCampaignRef.id);
    _activeCampaignObserver.campaign = campaign;
    return campaign;
  }

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    final campaign = await _campaignRepository.getCampaign(id: id);
    final campaignProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
    );
    final proposalSubmissionTime = campaign
        .phaseStateTo(CampaignPhaseType.proposalSubmission)
        .phase
        .timeline
        .to;
    final totalAsk = _calculateTotalAsk(campaignProposals);
    final updatedCategories = await _updateCategories(
      campaign.categories,
      proposalSubmissionTime,
    );

    return campaign.copyWith(
      totalAsk: totalAsk,
      categories: updatedCategories,
    );
  }

  @override
  Future<CampaignPhase> getCampaignPhaseTimeline(CampaignPhaseType type) async {
    final campaign = await getActiveCampaign();
    if (campaign == null) {
      throw StateError('No active campaign found');
    }

    final timelineStage = campaign.timeline.phases.firstWhere(
      (element) => element.type == type,
      orElse: () => throw (StateError('Type $type not found')),
    );
    return timelineStage;
  }

  @override
  Future<CampaignCategory> getCategory(DocumentParameters parameters) async {
    final category = await _campaignRepository.getCategory(parameters);
    if (category == null) {
      throw NotFoundException(
        message: 'Did not find category with parameters $parameters',
      );
    }

    return _loadCampaignCategoryDetails(category);
  }

  MultiCurrencyAmount _calculateTotalAsk(List<ProposalData> proposals) {
    final totalAmount = MultiCurrencyAmount();
    for (final proposal in proposals) {
      final fundsRequested = proposal.document.fundsRequested;
      if (fundsRequested != null) {
        totalAmount.add(fundsRequested);
      }
    }
    return totalAmount;
  }

  Future<CampaignCategory> _loadCampaignCategoryDetails(CampaignCategory base) async {
    final categoryProposals = await _proposalRepository.getProposals(
      type: ProposalsFilterType.finals,
      categoryRef: base.selfRef,
    );
    final proposalSubmissionStage = await getCampaignPhaseTimeline(
      CampaignPhaseType.proposalSubmission,
    );
    final totalAsk = _calculateTotalAsk(categoryProposals);

    return base.copyWith(
      totalAsk: totalAsk,
      proposalsCount: categoryProposals.length,
      submissionCloseDate: proposalSubmissionStage.timeline.to,
    );
  }

  Future<List<CampaignCategory>> _updateCategories(
    List<CampaignCategory> categories,
    DateTime? proposalSubmissionTime,
  ) async {
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
        submissionCloseDate: proposalSubmissionTime,
      );
      updatedCategories.add(updatedCategory);
    }
    return updatedCategories;
  }
}
