import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('CampaignService');

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
    DocumentRepository documentRepository,
    ActiveCampaignObserver activeCampaignObserver,
    SyncManager syncManager,
  ) = CampaignServiceImpl;

  Stream<Campaign?> get watchActiveCampaign;

  Future<void> changeActiveCampaign(
    Campaign campaign, {
    bool sync,
  });

  Future<Campaign?> getActiveCampaign();

  Future<CampaignPhase> getActiveCampaignPhaseTimeline(CampaignPhaseType stage);

  Future<List<Campaign>> getAllCampaigns();

  Future<Campaign> getCampaign({required String id});

  Future<CampaignCategory> getCategory(DocumentParameters parameters);

  Future<CampaignCategoryTotalAsk> getCategoryTotalAsk({required SignedDocumentRef ref});

  Future<Campaign?> initActiveCampaign();

  Stream<CampaignTotalAsk> watchCampaignTotalAsk({required ProposalsTotalAskFilters filters});

  Stream<CampaignCategoryTotalAsk> watchCategoryTotalAsk({required SignedDocumentRef ref});
}

final class CampaignServiceImpl implements CampaignService {
  final CampaignRepository _campaignRepository;
  final ProposalRepository _proposalRepository;
  final DocumentRepository _documentRepository;
  final ActiveCampaignObserver _activeCampaignObserver;
  final SyncManager _syncManager;

  const CampaignServiceImpl(
    this._campaignRepository,
    this._proposalRepository,
    this._documentRepository,
    this._activeCampaignObserver,
    this._syncManager,
  );

  @override
  Stream<Campaign?> get watchActiveCampaign async* {
    if (_activeCampaignObserver.campaign == null) {
      await _fetchInitialActiveCampaign();
    }
    yield* _activeCampaignObserver.watchCampaign;
  }

  @override
  Future<void> changeActiveCampaign(
    Campaign campaign, {
    bool sync = true,
  }) async {
    final observedCampaignId = _activeCampaignObserver.campaign?.id;
    final observedCampaignIdChanged = observedCampaignId != campaign.id;
    _activeCampaignObserver.campaign = campaign;

    await _updateAppActiveCampaign(campaign);

    if (sync && observedCampaignIdChanged) {
      final activeRequestsForCancellation = {
        ..._syncManager.pendingRequests.whereType<CampaignSyncRequest>(),
        ..._syncManager.scheduledRequests.whereType<CampaignSyncRequest>(),
      };

      for (final request in activeRequestsForCancellation) {
        _syncManager.cancel(request);
      }

      _syncManager.queue(CampaignSyncRequest.periodic(campaign));
    }
  }

  @override
  Future<Campaign?> getActiveCampaign() async {
    final activeCampaign = _activeCampaignObserver.campaign;
    if (activeCampaign != null) {
      return activeCampaign;
    } else {
      return _fetchInitialActiveCampaign();
    }
  }

  @override
  Future<CampaignPhase> getActiveCampaignPhaseTimeline(CampaignPhaseType type) async {
    final campaign = await getActiveCampaign();
    if (campaign == null) {
      // TODO(dt-iohk): Add specialized exceptions here.
      // Later Campaign will by dynamic and there is no guarantee we do have active campaign.
      throw StateError('No active campaign found');
    }

    return campaign.getPhaseTimeline(type);
  }

  @override
  Future<List<Campaign>> getAllCampaigns() async {
    return _campaignRepository.getAllCampaigns();
  }

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    return _campaignRepository.getCampaign(id: id);
  }

  @override
  Future<CampaignCategory> getCategory(DocumentParameters parameters) async {
    final category = await _campaignRepository.getCategory(parameters);
    if (category == null) {
      throw NotFoundException(
        message: 'Did not find category with parameters $parameters',
      );
    }
    return category;
  }

  @override
  Future<CampaignCategoryTotalAsk> getCategoryTotalAsk({required SignedDocumentRef ref}) {
    return watchCategoryTotalAsk(ref: ref).first;
  }

  @override
  Future<Campaign?> initActiveCampaign() async {
    final campaign = await _fetchInitialActiveCampaign();

    await _updateAppActiveCampaign(campaign);

    _activeCampaignObserver.campaign = campaign;

    return campaign;
  }

  @override
  Stream<CampaignTotalAsk> watchCampaignTotalAsk({
    required ProposalsTotalAskFilters filters,
  }) async* {
    final campaignFilters = filters.campaign;
    if (campaignFilters == null) {
      throw StateError('Campaign filters are required to watch campaign total ask!');
    }

    yield* _proposalRepository
        .watchProposalTemplates(campaign: campaignFilters)
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
  Stream<CampaignCategoryTotalAsk> watchCategoryTotalAsk({required SignedDocumentRef ref}) async* {
    final campaign = await _getCampaignWithCategory(ref);
    if (campaign == null) {
      throw NotFoundException(
        message: 'Did not find campaign which contains the category with ref $ref',
      );
    }

    final filters = ProposalsTotalAskFilters(
      categoryId: ref.id,
      campaign: CampaignFilters.from(campaign),
    );

    yield* watchCampaignTotalAsk(
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

  // TODO(LynxLynxx): Call backend to get latest active campaign
  Future<Campaign?> _fetchInitialActiveCampaign() {
    return getCampaign(id: activeCampaignRef.id);
  }

  Future<Campaign?> _getCampaignWithCategory(SignedDocumentRef ref) async {
    final allCampaigns = await getAllCampaigns();
    return allCampaigns.firstWhereOrNull((campaign) => campaign.hasCategory(ref.id));
  }

  Future<void> _updateAppActiveCampaign(Campaign? campaign) async {
    final appActiveCampaignId = await _campaignRepository.getAppActiveCampaignId();
    if (appActiveCampaignId == campaign?.id) {
      return;
    }

    _logger.fine(
      'Updating active campaign from '
      '[$appActiveCampaignId] '
      'to '
      '[${campaign?.id}]!',
    );

    await _campaignRepository.updateAppActiveCampaignId(id: campaign?.id);
    await _documentRepository.removeAll(
      excludeTypes: [DocumentType.proposalTemplate],
      localDrafts: false,
    );
  }
}

extension on ProposalTemplate {
  MapEntry<DocumentRef, _ProposalTemplateCategoryAndMoneyFormat> toMapEntry() {
    final ref = metadata.id;
    final category = metadata.parameters.set.first;

    final currencySchema = requestedFunds;
    final moneyFormat = currencySchema != null
        ? MoneyFormat(currency: currencySchema.currency, moneyUnits: currencySchema.moneyUnits)
        : null;

    return MapEntry(ref, (category: category, moneyFormat: moneyFormat));
  }
}

extension on Campaign {
  CampaignPhase getPhaseTimeline(CampaignPhaseType type) {
    return timeline.phases.firstWhere(
      (element) => element.type == type,
      orElse: () => throw StateError('Campaign $id does not have $type phase'),
    );
  }
}
