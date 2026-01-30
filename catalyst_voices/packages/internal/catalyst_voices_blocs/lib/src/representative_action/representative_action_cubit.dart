import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/representative_action/representative_action_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class RepresentativeActionCubit extends Cubit<RepresentativeActionState> {
  final VotingService _votingService;
  final CampaignService _campaignService;

  RepresnetativeActionCubitCache _cache = const RepresnetativeActionCubitCache();

  StreamSubscription<DateTime?>? _activeCampaignSub;
  StreamSubscription<AccountVotingRole?>? _activeVotingRoleSub;

  RepresentativeActionCubit(this._votingService, this._campaignService)
    : super(const RepresentativeActionState());

  @override
  Future<void> close() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = null;

    await super.close();
  }

  void init() {
    unawaited(_setupActiveCamapignTimelineSubscription());
    unawaited(_setupActiveVotingRoleSubscription());
  }

  void _handleActiveVotingRoleChange(AccountVotingRole? votingRole) {
    _cache = _cache.copyWith(votingRole: Optional(votingRole));

    _rebuildState();
  }

  void _handleCampaignTimelineChange(DateTime? votingSnapshotDate) {
    _cache = _cache.copyWith(
      votingSnapshotDate: Optional(votingSnapshotDate),
    );
    _rebuildState();
  }

  void _rebuildState() {
    emit(
      state.copyWith(
        votingSnapshotDate: _cache.votingSnapshotDate,
      ),
    );
  }

  Future<void> _setupActiveCamapignTimelineSubscription() async {
    await _activeCampaignSub?.cancel();
    _activeCampaignSub = _campaignService.watchActiveCampaign
        .map((event) => event?.timeline.votingSnapshotDate)
        .distinct()
        .listen(_handleCampaignTimelineChange);
  }

  Future<void> _setupActiveVotingRoleSubscription() async {
    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = _votingService.watchActiveVotingRole().distinct().listen(
      _handleActiveVotingRoleChange,
    );
  }
}
