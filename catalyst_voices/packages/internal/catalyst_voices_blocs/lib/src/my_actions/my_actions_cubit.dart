import 'dart:async';
import 'dart:developer';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/my_actions/my_actions_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class MyActionsCubit extends Cubit<MyActionsState>
    with BlocSignalEmitterMixin<MyActionsSignal, MyActionsState> {
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  final UserService _userService;

  MyActionsCubitCache _cache = const MyActionsCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<AccountInvitesApprovalsCount?>? _invitesApprovalsCountSub;
  StreamSubscription<CampaignTimeline?>? _activeCampaignSub;

  MyActionsCubit(this._proposalService, this._campaignService, this._userService)
    : super(const MyActionsState());

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _invitesApprovalsCountSub?.cancel();
    _invitesApprovalsCountSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    return super.close();
  }

  Future<void> init() async {
    await _setupActiveAccountIdSubscription();

    await _setupInvitesApprovalsCountSubscription();

    await _setupActiveCampaignSubscription();
  }

  void updatePageTab(ActionsPageTab tab) {
    _cache = _cache.copyWith(selectedTab: tab);
    emitSignal(ChangeTabMyActionsSignal(tab));
  }

  void _handleActiveAccountIdChange(CatalystId? catalystId) {
    _cache = _cache.copyWith(activeAccountId: Optional(catalystId));

    unawaited(_setupInvitesApprovalsCountSubscription());
  }

  void _handleCampaignTimelineChange(CampaignTimeline? timeline) {
    final proposalSubmissionCloseDate = timeline
        ?.phase(CampaignPhaseType.proposalSubmission)
        ?.timeline
        .to;
    final becomeReviewerCloseDate = timeline
        ?.phase(CampaignPhaseType.reviewRegistration)
        ?.timeline
        .to;

    log(becomeReviewerCloseDate.toString());
    _cache = _cache.copyWith(
      proposalSubmissionCloseDate: Optional(proposalSubmissionCloseDate),
      becomeReviewerCloseDate: Optional(becomeReviewerCloseDate),
    );
    _rebuildState();
  }

  void _handleInvitesApprovalsCountChange(AccountInvitesApprovalsCount? count) {
    _cache = _cache.copyWith(
      displayConsentCount: count?.invitesCount,
      finalProposalCount: count?.approvalsCount,
    );

    _rebuildState();
  }

  void _rebuildState() {
    emit(
      state.copyWith(
        displayConsentCount: _cache.displayConsentCount,
        finalProposalCount: _cache.finalProposalCount,
        proposalSubmissionCloseDate: Optional(_cache.proposalSubmissionCloseDate),
        becomeReviewerCloseDate: Optional(_cache.becomeReviewerCloseDate),
      ),
    );
  }

  Future<void> _setupActiveAccountIdSubscription() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((event) => event?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  Future<void> _setupActiveCampaignSubscription() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = _campaignService.watchActiveCampaign
        .map((event) => event?.timeline)
        .distinct()
        .listen(_handleCampaignTimelineChange);
  }

  Future<void> _setupInvitesApprovalsCountSubscription() async {
    await _invitesApprovalsCountSub?.cancel();
    final userCatalystId = _cache.activeAccountId;
    final invitesApprovalsCountStream = userCatalystId != null
        ? _proposalService.watchInvitesApprovalsCount(id: userCatalystId)
        : Stream<AccountInvitesApprovalsCount?>.value(null);
    _invitesApprovalsCountSub = invitesApprovalsCountStream.distinct().listen(
      _handleInvitesApprovalsCountChange,
    );
  }
}
