import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/display_consent/display_consent_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class DisplayConsentCubit extends Cubit<DisplayConsentState> {
  final UserService _userService;
  final ProposalService _proposalService;

  DisplayConsentCubitCache _cache = const DisplayConsentCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<Page<ProposalBriefData>>? _proposalDisplayConsentSub;

  DisplayConsentCubit(this._userService, this._proposalService)
    : super(const DisplayConsentState());

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _proposalDisplayConsentSub?.cancel();
    _proposalDisplayConsentSub = null;

    return super.close();
  }

  Future<void> init() async {
    await _setupActiveAccountIdSubscription();
    await _setupProposalDisplayConsentSubscription();
  }

  void _handleActiveAccountIdChange(CatalystId? catalystId) {
    _cache = _cache.copyWith(activeAccountId: Optional(catalystId));

    unawaited(_setupProposalDisplayConsentSubscription());
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

  Future<void> _setupActiveAccountIdSubscription() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((event) => event?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  Future<void> _setupProposalDisplayConsentSubscription() async {
    const signedProposalsPageRequest = PageRequest(page: 0, size: 999);

    await _proposalDisplayConsentSub?.cancel();
    final activeCatalystId = _cache.activeAccountId;
    final proposalDisplayConsentStream = activeCatalystId != null
        ? _proposalService.watchProposalsBriefPageV2(
            request: signedProposalsPageRequest,
            filters: CollaboratorInvitationsProposalsFilter(activeCatalystId),
          )
        : Stream<Page<ProposalBriefData>>.value(const Page.empty());
    _proposalDisplayConsentSub = proposalDisplayConsentStream.distinct().listen(
      _handleProposalDisplayConsentListChange,
    );
  }
}
