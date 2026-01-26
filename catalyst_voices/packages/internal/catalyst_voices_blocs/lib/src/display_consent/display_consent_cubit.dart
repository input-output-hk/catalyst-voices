import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/display_consent/display_consent_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class DisplayConsentCubit extends Cubit<DisplayConsentState> with BlocErrorEmitterMixin {
  final UserService _userService;
  final ProposalService _proposalService;

  DisplayConsentCubitCache _cache = const DisplayConsentCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<Page<ProposalBriefData>>? _proposalDisplayConsentSub;

  DisplayConsentCubit(this._userService, this._proposalService)
    : super(const DisplayConsentState());

  Future<void> changeDisplayConsent({
    required DocumentRef id,
    required CollaboratorDisplayConsentStatus displayConsentStatus,
  }) async {
    final collaboratorAction = displayConsentStatus.toCollaboratorAction();

    final indexOfProposalConsent = _cache.proposalsDisplayConsent.indexWhere(
      (proposal) => proposal.id == id,
    );

    if (indexOfProposalConsent == -1) {
      return;
    }

    final updatedProposalsDisplayConsent = List.of(_cache.proposalsDisplayConsent);

    updatedProposalsDisplayConsent[indexOfProposalConsent] =
        updatedProposalsDisplayConsent[indexOfProposalConsent].copyWith(
          lastDisplayConsentUpdate: Optional(DateTime.now()),
          status: displayConsentStatus,
        );

    emit(state.copyWith(items: updatedProposalsDisplayConsent));

    if (collaboratorAction != null) {
      try {
        if (id is! SignedDocumentRef) {
          throw ArgumentError(
            'Cannot send a collaborator action $collaboratorAction for a draft: $id',
          );
        }

        await _proposalService.submitCollaboratorProposalAction(
          proposalId: id,
          action: collaboratorAction,
        );
        _cache = _cache.copyWith(proposalsDisplayConsent: updatedProposalsDisplayConsent);
      } catch (e) {
        if (!isClosed) {
          emit(state.copyWith(items: _cache.proposalsDisplayConsent));

          emitError(LocalizedException.create(e));
        }
      }
    }
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _proposalDisplayConsentSub?.cancel();
    _proposalDisplayConsentSub = null;

    return super.close();
  }

  void init() {
    _setupActiveAccountIdSubscription();
    _setupProposalDisplayConsentSubscription();
  }

  void _handleActiveAccountIdChange(CatalystId? catalystId) {
    _cache = _cache.copyWith(activeAccountId: Optional(catalystId));

    _setupProposalDisplayConsentSubscription();
  }

  void _handleProposalDisplayConsentListChange(Page<ProposalBriefData> page) {
    final proposalsDisplayConsent = page.items
        .map(
          // If this handle was called then catalystId is not null because it was check at setup level
          (item) => CollaboratorProposalDisplayConsent.fromBrief(item, _cache.activeAccountId!),
        )
        .toList();

    _cache = _cache.copyWith(proposalsDisplayConsent: proposalsDisplayConsent);

    _rebuildState();
  }

  void _rebuildState() {
    emit(state.copyWith(items: _cache.proposalsDisplayConsent));
  }

  void _setupActiveAccountIdSubscription() {
    unawaited(_activeAccountIdSub?.cancel());
    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((event) => event?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  void _setupProposalDisplayConsentSubscription() {
    const signedProposalsPageRequest = PageRequest(page: 0, size: 999);

    unawaited(_proposalDisplayConsentSub?.cancel());
    final activeCatalystId = _cache.activeAccountId;
    final proposalDisplayConsentStream = activeCatalystId != null
        ? _proposalService.watchProposalsBriefPageV2(
            request: signedProposalsPageRequest,
            filters: CollaboratorProposalDisplayConsentFilter(activeCatalystId),
          )
        : Stream<Page<ProposalBriefData>>.value(const Page.empty());
    _proposalDisplayConsentSub = proposalDisplayConsentStream.distinct().listen(
      _handleProposalDisplayConsentListChange,
    );
  }
}
