import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/representative_action/representative_action_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class RepresentativeActionCubit extends Cubit<RepresentativeActionState> {
  final RepresentativesService _representativeService;
  final CampaignService _campaignService;
  final UserService _userService;

  RepresentativeActionCubitCache _cache = const RepresentativeActionCubitCache();

  StreamSubscription<DateTime?>? _activeCampaignSub;
  StreamSubscription<DocumentRef?>? _activeAccountRepresentativeDocumentIdSub;
  StreamSubscription<(bool, CatalystId?)>? _activeAccountSub;

  RepresentativeActionCubit(this._representativeService, this._campaignService, this._userService)
    : super(const RepresentativeActionState());

  @override
  Future<void> close() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _activeAccountRepresentativeDocumentIdSub?.cancel();
    _activeAccountRepresentativeDocumentIdSub = null;

    await _activeAccountSub?.cancel();
    _activeAccountSub = null;

    await super.close();
  }

  void init() {
    unawaited(_setupActiveCampaignTimelineSubscription());
    unawaited(_setupRepresentativeProfileIdSubscription());
    unawaited(_setupActiveAccountSubscription());
  }

  void _handleActiveAccountChanged(bool hasRepresentativeRole, CatalystId? catalystId) {
    final registrationStatus = RepresentativeRegistrationStatus.from(
      isRegistered: hasRepresentativeRole,
    );

    _cache = _cache.copyWith(
      registrationStatus: registrationStatus,
      activeAccountId: Optional(catalystId),
    );
    unawaited(_setupRepresentativeProfileIdSubscription());
    _rebuildState();
  }

  void _handleCampaignTimelineChange(DateTime? votingSnapshotDate) {
    _cache = _cache.copyWith(
      votingSnapshotDate: Optional(votingSnapshotDate),
    );
    _rebuildState();
  }

  void _handleRepresentativeProfileIdChange(DocumentRef? profileId) {
    _cache = _cache.copyWith(profileId: Optional(profileId));

    _rebuildState();
  }

  (bool, CatalystId?) _mapActiveAccount(Account? account) {
    final hasRepresentativeRole = account?.roles.contains(AccountRole.drep) ?? false;
    final catalystId = account?.catalystId;

    return (hasRepresentativeRole, catalystId);
  }

  void _rebuildState() {
    final representativeDocumentId = _cache.profileId;
    final registrationStatus = _cache.registrationStatus;

    final representativeSteps = RepresentativeActionStep.steps(
      registrationStatus: registrationStatus,
      representativeDocumentId: representativeDocumentId,
    );

    emit(
      state.copyWith(
        votingSnapshotDate: _cache.votingSnapshotDate,
        representativeActions: representativeSteps.representativeActions,
        additionalStep: Optional(representativeSteps.additionalStep),
        registrationStatus: Optional(registrationStatus),
      ),
    );
  }

  Future<void> _setupActiveAccountSubscription() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = _userService.watchUnlockedActiveAccount
        .map(_mapActiveAccount)
        .distinct()
        .listen((accountData) => _handleActiveAccountChanged(accountData.$1, accountData.$2));
  }

  Future<void> _setupActiveCampaignTimelineSubscription() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = _campaignService.watchActiveCampaign
        .map((event) => event?.timeline.votingSnapshotDate)
        .distinct()
        .listen(_handleCampaignTimelineChange);
  }

  Future<void> _setupRepresentativeProfileIdSubscription() async {
    final catalystId = _cache.activeAccountId;

    await _activeAccountRepresentativeDocumentIdSub?.cancel();
    final representativeProfileStream = catalystId != null
        ? _representativeService.watchRepresentative(representativeId: catalystId)
        : Stream<Representative?>.value(null);

    _activeAccountRepresentativeDocumentIdSub = representativeProfileStream
        .map((representative) => representative?.profileId)
        .distinct()
        .listen(
          _handleRepresentativeProfileIdChange,
        );
  }
}
