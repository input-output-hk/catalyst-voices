import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/campaign/active_campaign_observer.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('CampaignService');

Campaign? _mockedActiveCampaign;

/// Overrides the current campaign returned by [CampaignService.getActiveCampaign].
/// Only for unit testing.
@visibleForTesting
//ignore: avoid_setters_without_getters
set mockedActiveCampaign(Campaign? campaign) {
  _mockedActiveCampaign = campaign;
}

typedef _ProposalTemplateCategoryAndMoneyFormat = ({
  SignedDocumentRef? category,
  MoneyFormat? moneyFormat,
});

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

  Future<CampaignCategoryTotalAsk> getCategoryTotalAsk({required SignedDocumentRef ref});

  Stream<CampaignTotalAsk> watchCampaignTotalAsk({required ProposalsTotalAskFilters filters});

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
  Future<CampaignCategory> getCategory(DocumentParameters parameters) async {
    final category = await _campaignRepository.getCategory(parameters);
    if (category == null) {
      throw NotFoundException(
        message: 'Did not find category with parameters $parameters',
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
    return watchCategoryTotalAsk(ref: ref).first;
  }

  @override
  Stream<CampaignTotalAsk> watchCampaignTotalAsk({required ProposalsTotalAskFilters filters}) {
    return _proposalRepository
        .watchProposalTemplates(campaign: filters.campaign ?? CampaignFilters.active())
        .map((templates) => templates.map((template) => template.toMapEntry()))
        .map(Map.fromEntries)
        .switchMap((templatesMoneyFormat) {
          // This could come from templates
          final nodeId = ProposalDocument.requestedFundsNodeId;

          return _campaignRepository
              .watchProposalsTotalTask(nodeId: nodeId, filters: filters)
              .map((totalAsk) => _calculateCampaignTotalAsk(templatesMoneyFormat, totalAsk));
        });
  }

  @override
  Stream<CampaignCategoryTotalAsk> watchCategoryTotalAsk({required SignedDocumentRef ref}) {
    final activeCampaign = _activeCampaignObserver.campaign;
    final campaignFilters = activeCampaign != null ? CampaignFilters.from(activeCampaign) : null;

    final filters = ProposalsTotalAskFilters(
      categoryId: ref.id,
      campaign: campaignFilters,
    );

    return watchCampaignTotalAsk(
      filters: filters,
    ).map((campaignTotalAsk) => campaignTotalAsk.categoryOrZero(ref));
  }

  CampaignTotalAsk _calculateCampaignTotalAsk(
    Map<DocumentRef, _ProposalTemplateCategoryAndMoneyFormat> templatesMoneyFormat,
    ProposalsTotalAsk totalAsk,
  ) {
    final categoriesAsks = <DocumentRef, CampaignCategoryTotalAsk>{};

    for (final entry in totalAsk.data.entries) {
      final templateRef = entry.key;
      final categoryRef = templatesMoneyFormat[templateRef]?.category;
      final moneyFormat = templatesMoneyFormat[templateRef]?.moneyFormat;

      if (categoryRef == null || moneyFormat == null) {
        if (categoryRef == null) _logger.info('Template[$templateRef] do not have category');
        if (moneyFormat == null) _logger.info('Template[$templateRef] do not have moneyFormat');
        continue;
      }

      final proposalTotalAsk = entry.value;
      final finalProposalsCount = proposalTotalAsk.finalProposalsCount;
      final money = Money.fromUnits(
        currency: moneyFormat.currency,
        amount: BigInt.from(proposalTotalAsk.totalAsk),
        moneyUnits: moneyFormat.moneyUnits,
      );

      final ask = CampaignCategoryTotalAsk(
        ref: categoryRef,
        finalProposalsCount: finalProposalsCount,
        money: [money],
      );

      categoriesAsks.update(categoryRef, (value) => value + ask, ifAbsent: () => ask);
    }

    return CampaignTotalAsk(categoriesAsks: Map.unmodifiable(categoriesAsks));
  }
}

extension on ProposalTemplate {
  MapEntry<DocumentRef, _ProposalTemplateCategoryAndMoneyFormat> toMapEntry() {
    final ref = metadata.id;
    final category = metadata.parameters?.set.first;

    final currencySchema = requestedFunds;
    final moneyFormat = currencySchema != null
        ? MoneyFormat(currency: currencySchema.currency, moneyUnits: currencySchema.moneyUnits)
        : null;

    return MapEntry(ref, (category: category, moneyFormat: moneyFormat));
  }
}
