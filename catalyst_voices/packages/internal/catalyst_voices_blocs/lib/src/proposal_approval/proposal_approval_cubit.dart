import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposal_approval/proposal_approval_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final class ProposalApprovalCubit extends Cubit<ProposalApprovalState> with BlocErrorEmitterMixin {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalApprovalCubitCache _cache = const ProposalApprovalCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;
  StreamSubscription<List<UsersProposalOverview>>? _dataPageSub;

  ProposalApprovalCubit(this._userService, this._campaignService, this._proposalService)
    : super(const ProposalApprovalState());

  Future<Campaign?> get _campaign async {
    final cachedCampaign = _cache.campaign;
    if (cachedCampaign != null) {
      return cachedCampaign;
    }

    final campaign = await _campaignService.getActiveCampaign();
    _cache = _cache.copyWith(campaign: Optional(campaign));

    return campaign;
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _dataPageSub?.cancel();
    _dataPageSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    return super.close();
  }

  void init() {
    _setupActiveAccountIdSubscription();
    _setupActiveCampaignSubscription();
    _setupProposalsSubscription();
  }

  List<UsersProposalOverview> _filterDecideItems(
    List<UsersProposalOverview> items,
    CatalystId? activeAccountId,
  ) {
    return items.where((proposal) {
      final collaborator = proposal.collaborators.firstWhereOrNull(
        (collab) => activeAccountId.isSameAs(collab.id),
      );
      return collaborator != null && collaborator.status == ProposalsCollaborationStatus.pending;
    }).toList();
  }

  List<UsersProposalOverview> _filterFinalItems(
    List<UsersProposalOverview> items,
    CatalystId? activeAccountId,
  ) {
    return items.where((proposal) {
      final collaborator = proposal.collaborators.firstWhereOrNull(
        (collab) => activeAccountId.isSameAs(collab.id),
      );
      return collaborator != null && collaborator.status != ProposalsCollaborationStatus.pending;
    }).toList();
  }

  void _handleActiveAccountIdChange(CatalystId? catalystId) {
    _cache = _cache.copyWith(activeAccountId: Optional(catalystId));
    emit(state.copyWith(activeAccountId: Optional(catalystId)));
    _setupProposalsSubscription();
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_cache.campaign?.id == campaign?.id) {
      return;
    }

    _cache = _cache.copyWith(campaign: Optional(campaign));
    _setupProposalsSubscription();
  }

  void _handleProposalsChange(List<UsersProposalOverview> items) {
    _cache = _cache.copyWith(items: Optional(items));
    emit(
      state.copyWith(
        decideItems: _filterDecideItems(items, _cache.activeAccountId),
        finalItems: _filterFinalItems(items, _cache.activeAccountId),
      ),
    );
  }

  ProposalsFiltersV2 _proposalFilters() {
    final activeAccountId = _cache.activeAccountId;
    if (activeAccountId == null) {
      return const ProposalsFiltersV2();
    }

    return CollaboratorProposalApprovalsFilter(activeAccountId);
  }

  void _setupActiveAccountIdSubscription() {
    unawaited(_activeAccountIdSub?.cancel());
    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((event) => event?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  void _setupActiveCampaignSubscription() {
    unawaited(_activeCampaignSub?.cancel());

    _activeCampaignSub = _campaignService.watchActiveCampaign
        .distinct((previous, next) => previous?.id == next?.id)
        .listen(_handleActiveCampaignChange);
  }

  void _setupProposalsSubscription() {
    const pageRequest = PageRequest(page: 0, size: 999);
    final proposalsFilters = _proposalFilters();

    unawaited(_dataPageSub?.cancel());
    _dataPageSub = _proposalService
        .watchProposalsBriefPageV2(request: pageRequest, filters: proposalsFilters)
        .asyncMap((page) async {
          final activeCampaign = await _campaign;
          return page.items.map((brief) {
            return UsersProposalOverview.fromProposalBriefData(
              proposalData: brief,
              fromActiveCampaign: activeCampaign?.fundNumber == brief.fundNumber,
              activeAccountId: _cache.activeAccountId,
            );
          }).toList();
        })
        .distinct(listEquals)
        .listen(_handleProposalsChange);
  }
}
