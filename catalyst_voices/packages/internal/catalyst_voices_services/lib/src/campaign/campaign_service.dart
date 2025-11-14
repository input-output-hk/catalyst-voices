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

  Future<CampaignTotalAsk> getCampaignTotalAsk({required CampaignFilters filters});

  Future<CampaignCategory> getCategory(SignedDocumentRef ref);

  Future<CampaignCategoryTotalAsk> getCategoryTotalAsk({required SignedDocumentRef ref});

  Stream<CampaignTotalAsk> watchCampaignTotalAsk({required CampaignFilters filters});

  Stream<CampaignCategoryTotalAsk> watchCategoryTotalAsk({required SignedDocumentRef ref});
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
    final proposalSubmissionTime = campaign
        .phaseStateTo(CampaignPhaseType.proposalSubmission)
        .phase
        .timeline
        .to;

    final updatedCategories = campaign.categories
        .map((e) => e.copyWith(submissionCloseDate: proposalSubmissionTime))
        .toList();

    return campaign.copyWith(
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
      orElse: () => throw StateError('Type $type not found'),
    );
    return timelineStage;
  }

  @override
  Future<CampaignTotalAsk> getCampaignTotalAsk({required CampaignFilters filters}) {
    // TODO(damian-molinski): implement it.
    return Future(() => const CampaignTotalAsk(categoriesAsks: {}));
  }

  @override
  Future<CampaignCategory> getCategory(SignedDocumentRef ref) async {
    final category = await _campaignRepository.getCategory(ref);
    if (category == null) {
      throw NotFoundException(
        message: 'Did not find category with ref $ref',
      );
    }

    final proposalSubmissionStage = await getCampaignPhaseTimeline(
      CampaignPhaseType.proposalSubmission,
    );

    return category.copyWith(
      submissionCloseDate: proposalSubmissionStage.timeline.to,
    );
  }

  @override
  Future<CampaignCategoryTotalAsk> getCategoryTotalAsk({required SignedDocumentRef ref}) {
    // TODO(damian-molinski): implement it.
    return Future(() => CampaignCategoryTotalAsk.zero(ref));
  }

  @override
  Stream<CampaignTotalAsk> watchCampaignTotalAsk({required CampaignFilters filters}) {
    // TODO(damian-molinski): implement it.
    return Stream.value(const CampaignTotalAsk(categoriesAsks: {}));
  }

  @override
  Stream<CampaignCategoryTotalAsk> watchCategoryTotalAsk({required SignedDocumentRef ref}) {
    return Stream.value(CampaignCategoryTotalAsk.zero(ref));
  }
}
