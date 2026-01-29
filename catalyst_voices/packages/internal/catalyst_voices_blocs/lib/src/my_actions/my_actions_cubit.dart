import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/my_actions/my_actions_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class MyActionsCubit extends Cubit<MyActionsState>
    with BlocSignalEmitterMixin<MyActionsSignal, MyActionsState> {
  final ProposalService _proposalService;
  final CampaignService _campaignService;
  final UserService _userService;
  final VotingService _votingService;

  MyActionsCubitCache _cache = const MyActionsCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<AccountInvitesApprovalsCount?>? _invitesApprovalsCountSub;
  StreamSubscription<CampaignTimeline?>? _activeCampaignSub;
  StreamSubscription<AccountVotingRole?>? _activeVotingRoleSub;

  MyActionsCubit(
    this._proposalService,
    this._campaignService,
    this._userService,
    this._votingService,
  ) : super(const MyActionsState());

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _invitesApprovalsCountSub?.cancel();
    _invitesApprovalsCountSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = null;

    return super.close();
  }

  Future<void> init() async {
    await _setupActiveAccountIdSubscription();

    await _setupInvitesApprovalsCountSubscription();

    await _setupActiveCampaignSubscription();

    await _setupActiveVotingRoleSubscription();
  }

  void updatePageTab(ActionsPageTab tab) {
    _cache = _cache.copyWith(selectedTab: tab);
    _rebuildState();
    emitSignal(ChangeTabMyActionsSignal(tab));
  }

  List<ActionsCardType> _computeAvailableCards() {
    final baseCardTypes = ActionsCardType.valuesForTab(_cache.selectedTab);
    final accountVotingRole = _cache.accountVotingRole;

    final cards = <ActionsCardType>[];

    for (final cardType in baseCardTypes) {
      switch (cardType) {
        case DisplayConsentCardType():
          cards.add(cardType);

        case ProposalApprovalCardType():
          cards.add(cardType);

        case BecomeReviewerCardType():
          final closeDate = _cache.becomeReviewerCloseDate;
          if (closeDate == null || DateTimeExt.now().isBefore(closeDate)) {
            cards.add(const BecomeReviewerCardType());
          }

        case RepresentativeCardType():
          // TODO(LynxLynxx): Add correct logic
          final isRepresentative = accountVotingRole is AccountVotingRoleRepresentative;
          cards.add(RepresentativeCardType(isSet: isRepresentative));

        case VotingPowerDelegationCardType():
        // TODO(LynxLynxx): Add correct logic
      }
    }

    return cards;
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

  void _handleVotingRoleChange(AccountVotingRole? votingRole) {
    _cache = _cache.copyWith(
      accountVotingRole: Optional(votingRole),
    );

    _rebuildState();
  }

  void _rebuildState() {
    final actionCardsState = state.actionCardsState.copyWith(
      availableCards: _computeAvailableCards(),
      selectedTab: _cache.selectedTab,
    );

    emit(
      state.copyWith(
        displayConsentCount: _cache.displayConsentCount,
        finalProposalCount: _cache.finalProposalCount,
        proposalSubmissionCloseDate: Optional(_cache.proposalSubmissionCloseDate),
        becomeReviewerCloseDate: Optional(_cache.becomeReviewerCloseDate),
        actionCardsState: actionCardsState,
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

  Future<void> _setupActiveVotingRoleSubscription() async {
    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = _votingService.watchActiveVotingRole().distinct().listen(
      _handleVotingRoleChange,
    );
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
