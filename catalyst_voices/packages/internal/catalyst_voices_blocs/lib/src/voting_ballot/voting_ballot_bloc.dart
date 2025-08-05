import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/voting_ballot/voting_ballot.dart';
import 'package:catalyst_voices_blocs/src/voting_ballot/voting_ballot_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';

typedef _VoteWithProposal = ({Vote vote, VoteProposal? proposal});

final class VotingBallotBloc extends Bloc<VotingBallotEvent, VotingBallotState> {
  final UserService _userService;
  final CampaignService _campaignService;

  final _ballotBuilder = VotingBallotBuilder();
  var _cache = const VotingBallotCache();

  StreamSubscription<VotingPower?>? _votingPowerSub;
  StreamSubscription<TimezonePreferences?>? _userTimezonePreferencesSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;

  Timer? _phaseProgressTimer;

  VotingBallotBloc(
    this._userService,
    this._campaignService,
  ) : super(const VotingBallotState()) {
    on<UpdateVotingPowerEvent>(_updateVotingPower, transformer: uniqueEvents());
    on<UpdateVotingPhaseProgressEvent>(_updateVotingPhaseProgress, transformer: uniqueEvents());
    on<UpdateFundNumberEvent>(_updateFundNumber, transformer: uniqueEvents());
    on<UpdateFundNumberEvent>(_updateFundNumber, transformer: uniqueEvents());
    on<UpdateFooterFromBallotBuilderEvent>(_updateFooterFromBallot, transformer: uniqueEvents());
    on<UpdateLastCastedVoteEvent>(_updateLastCastedVote, transformer: uniqueEvents());
    on<UpdateVoteTiles>(_updateTiles);

    _votingPowerSub = _userService.watchUser
        .map((user) {
          final activeAccount = user.activeAccount;
          if (activeAccount == null) {
            return null;
          }

          // TODO(damian-molinski): update using Account.
          return VotingPower(
            amount: 1000,
            status: VotingPowerStatus.confirmed,
            updatedAt: DateTime.now(),
          );
        })
        .distinct()
        .listen(_handleVotingPowerChange);

    _userTimezonePreferencesSub = _userService.watchUser
        .map((event) => event.settings.timezone)
        .distinct()
        .listen(_handleUserTimezonePrefChange);

    _activeCampaignSub = _campaignService.watchActiveCampaign.listen(_handleCampaignChange);

    // TODO(damian-molinski): watch service.
    _handleLastCastedChange(null);

    _handleBallotBuilderChange();
  }

  @override
  Future<void> close() {
    _votingPowerSub?.cancel();
    _votingPowerSub = null;

    _userTimezonePreferencesSub?.cancel();
    _userTimezonePreferencesSub = null;

    _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    _phaseProgressTimer?.cancel();
    _phaseProgressTimer = null;

    return super.close();
  }

  List<VotingListTileData> _buildTiles(List<_VoteWithProposal> data) {
    return data
        .groupListsBy((element) => element.proposal?.category)
        .entries
        .map(
          (entry) {
            final category = entry.key;
            if (category == null) {
              return null;
            }

            final votesTiles = entry.value
                .map(
                  (votesWithProposal) {
                    final (:vote, :proposal) = votesWithProposal;
                    if (proposal == null) {
                      return null;
                    }

                    return VotingListTileVoteData(
                      proposal: proposal.ref,
                      proposalTitle: proposal.title,
                      authorName: proposal.authorName,
                      vote: VoteButtonData.fromVotes(
                        currentDraft: vote,
                        lastCasted: proposal.lastCastedVote,
                      ),
                    );
                  },
                )
                .nonNulls
                .toList();

            return VotingListTileData(
              category: category.ref,
              categoryText: category.name,
              votes: votesTiles,
            );
          },
        )
        .nonNulls
        .toList();
  }

  void _calculatePhaseProgress() {
    final votingTimeline = _cache.votingTimeline;
    final timezone = _cache.preferredTimezone ?? TimezonePreferences.local;

    if (votingTimeline == null) {
      add(const UpdateVotingPhaseProgressEvent());
      return;
    }

    final effectiveVotingTimeline = timezone.applyToRange(votingTimeline);

    final start = effectiveVotingTimeline.from;
    final end = effectiveVotingTimeline.to;
    if (start == null || end == null) {
      add(const UpdateVotingPhaseProgressEvent());
      return;
    }

    final now = DateTimeExt.now(utc: timezone == TimezonePreferences.utc);

    final progress = _calculatePhaseProgressValue(start: start, end: end, now: now);
    final endsIn = _calculatePhaseProgressEndsDuration(start: start, end: end, now: now);

    add(UpdateVotingPhaseProgressEvent(votingPhaseProgress: progress, votingEndsIn: endsIn));
  }

  Duration? _calculatePhaseProgressEndsDuration({
    required DateTime start,
    required DateTime end,
    required DateTime now,
  }) {
    if (end.isBefore(start) || now.isBefore(start)) {
      return null;
    }

    if (now.isAfter(end)) {
      return Duration.zero;
    }

    return end.difference(now);
  }

  double _calculatePhaseProgressValue({
    required DateTime start,
    required DateTime end,
    required DateTime now,
  }) {
    if (end.isBefore(start) || now.isBefore(start)) {
      return 0;
    }

    if (now.isAfter(end)) {
      return 1;
    }

    final totalDuration = end.difference(start).inMilliseconds;

    // Handle the case where start and end are the same time.
    if (totalDuration == 0) {
      return 1;
    }

    final elapsedDuration = now.difference(start).inMilliseconds;
    final progress = elapsedDuration / totalDuration;
    return progress.clamp(0.0, 1.0);
  }

  void _handleBallotBuilderChange() {
    final canCastVotes = _ballotBuilder.length > 0;
    final showPendingVotesDisclaimer = _ballotBuilder.length > 0;

    final event = UpdateFooterFromBallotBuilderEvent(
      canCastVotes: canCastVotes,
      showPendingVotesDisclaimer: showPendingVotesDisclaimer,
    );

    add(event);
    _rebuildTilesAndSendEvent();
  }

  void _handleCampaignChange(Campaign? campaign) {
    add(UpdateFundNumberEvent(campaign?.fundNumber));

    final votingPhase = campaign?.timeline.phase(CampaignPhaseType.communityVoting);
    final votingTimeline = votingPhase?.timeline;

    if (votingTimeline != _cache.votingTimeline) {
      _cache = _cache.copyWith(votingTimeline: Optional(votingTimeline));
      _updateVotingPhaseProgressTimer();
    }
  }

  void _handleLastCastedChange(Vote? vote) {
    add(UpdateLastCastedVoteEvent(vote?.createdAt));
  }

  void _handleUserTimezonePrefChange(TimezonePreferences? value) {
    if (value != _cache.preferredTimezone) {
      _cache = _cache.copyWith(preferredTimezone: Optional(value));
      _updateVotingPhaseProgressTimer();
    }
  }

  void _handleVotingPowerChange(VotingPower? votingPower) {
    add(UpdateVotingPowerEvent(votingPower));
  }

  List<_VoteWithProposal> _mapVotesWithProposals(
    List<Vote> votes,
    Map<DocumentRef, VoteProposal> proposals,
  ) {
    return votes.map<_VoteWithProposal>(
      (vote) {
        final proposal = proposals[vote.proposal];
        return (vote: vote, proposal: proposal);
      },
    ).toList();
  }

  void _rebuildTilesAndSendEvent() {
    final votes = _ballotBuilder.votes;
    final proposals = _cache.votesProposals;

    final tilesData = _mapVotesWithProposals(votes, proposals);
    final tiles = _buildTiles(tilesData);

    assert(
      () {
        final votesCount = votes.length;
        final tilesVotesCount = tiles.fold(
          0,
          (previousValue, element) => previousValue + element.votes.length,
        );

        return votesCount == tilesVotesCount;
      }(),
      'Tiles have different votes count then votes itself. '
      'Make sure to add VoteProposal for every vote',
    );

    add(UpdateVoteTiles(tiles));
  }

  void _updateFooterFromBallot(
    UpdateFooterFromBallotBuilderEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final footer = state.footer.copyWith(
      canCastVotes: event.canCastVotes,
      showPendingVotesDisclaimer: event.showPendingVotesDisclaimer,
    );

    emit(state.copyWith(footer: footer));
  }

  void _updateFundNumber(
    UpdateFundNumberEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final votingProgress = state.votingProgress.copyWith(activeFundNumber: Optional(event.number));
    emit(state.copyWith(votingProgress: votingProgress));
  }

  void _updateLastCastedVote(
    UpdateLastCastedVoteEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final footer = state.footer.copyWith(lastCastedVoteAt: Optional(event.votedAt));

    emit(state.copyWith(footer: footer));
  }

  void _updateTiles(
    UpdateVoteTiles event,
    Emitter<VotingBallotState> emit,
  ) {
    emit(state.copyWith(tiles: event.tiles));
  }

  void _updateVotingPhaseProgress(
    UpdateVotingPhaseProgressEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final votingProgress = state.votingProgress.copyWith(
      votingPhaseProgress: event.votingPhaseProgress,
      votingEndsIn: Optional(event.votingEndsIn),
    );

    emit(state.copyWith(votingProgress: votingProgress));
  }

  void _updateVotingPhaseProgressTimer() {
    _phaseProgressTimer?.cancel();
    _phaseProgressTimer = null;

    if (_cache.votingTimeline == null) {
      add(const UpdateVotingPhaseProgressEvent());
      return;
    }

    _calculatePhaseProgress();

    _phaseProgressTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculatePhaseProgress(),
    );
  }

  void _updateVotingPower(
    UpdateVotingPowerEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final votingPower = event.data;

    final userSummary = VotingListUserSummaryData(
      amount: votingPower?.amount ?? 0,
      status: votingPower?.status,
    );
    emit(state.copyWith(userSummary: userSummary));
  }
}
