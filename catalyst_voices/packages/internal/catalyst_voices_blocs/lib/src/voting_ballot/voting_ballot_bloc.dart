import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
  final VotingBallotBuilder _ballotBuilder;

  var _cache = const VotingBallotCache();

  StreamSubscription<VotingPower?>? _votingPowerSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;

  Timer? _phaseProgressTimer;

  VotingBallotBloc(
    this._userService,
    this._campaignService,
    this._ballotBuilder,
  ) : super(const VotingBallotState()) {
    on<UpdateVotingPowerEvent>(_updateVotingPower, transformer: uniqueEvents());
    on<UpdateVotingPhaseProgressEvent>(_updateVotingPhaseProgress, transformer: uniqueEvents());
    on<UpdateFundNumberEvent>(_updateFundNumber, transformer: uniqueEvents());
    on<UpdateFooterFromBallotBuilderEvent>(_updateFooterFromBallot, transformer: uniqueEvents());
    on<UpdateLastCastedVoteEvent>(_updateLastCastedVote, transformer: uniqueEvents());
    on<UpdateVoteTiles>(_updateTiles);
    on<UpdateVoteEvent>(_updateVote);
    on<RemoveVoteEvent>(_removeVote);
    on<CastVotesEvent>(_castVotes);

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

    _activeCampaignSub = _campaignService.watchActiveCampaign.listen(_handleCampaignChange);

    _ballotBuilder.addListener(_handleBallotBuilderChange);
    _handleBallotBuilderChange();

    // TODO(damian-molinski): watch VotingService.
    _handleLastCastedChange(null);
  }

  @override
  Future<void> close() {
    _ballotBuilder.removeListener(_handleBallotBuilderChange);

    _votingPowerSub?.cancel();
    _votingPowerSub = null;

    _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    _phaseProgressTimer?.cancel();
    _phaseProgressTimer = null;

    return super.close();
  }

  List<VotingListTileData> _buildTiles() {
    final votes = _ballotBuilder.votes;
    final proposals = _cache.votesProposals;

    final tilesData = _mapVotesWithProposals(votes, proposals);
    final tiles = _buildTilesFrom(tilesData);

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

    return tiles;
  }

  List<VotingListTileData> _buildTilesFrom(List<_VoteWithProposal> data) {
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

  ({double progress, Duration? endsIn}) _calculatePhaseProgress() {
    final votingTimeline = _cache.votingTimeline;

    if (votingTimeline == null) {
      return (progress: 0, endsIn: null);
    }

    final effectiveVotingTimeline = votingTimeline;

    final start = effectiveVotingTimeline.from;
    final end = effectiveVotingTimeline.to;
    if (start == null || end == null) {
      return (progress: 0, endsIn: null);
    }

    final now = DateTimeExt.now(utc: true);

    final progress = _calculatePhaseProgressValue(start: start, end: end, now: now);
    final endsIn = _calculatePhaseProgressEndsDuration(start: start, end: end, now: now);

    return (progress: progress, endsIn: endsIn);
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

  Future<void> _castVotes(
    CastVotesEvent event,
    Emitter<VotingBallotState> emit,
  ) async {
    final _ = _ballotBuilder.build();
    _ballotBuilder.clear();

    // TODO(damian-molinski): call voting service

    final tiles = _buildTiles();
    emit(state.copyWith(tiles: tiles));
  }

  // TODO(damian-molinski): call voting service.
  Future<Vote?> _getLastCastedVoteOn(DocumentRef proposal) async {
    return Vote(
      selfRef: SignedDocumentRef.generateFirstRef(),
      proposal: proposal,
      type: VoteType.yes,
    );
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
    final tiles = _buildTiles();

    add(UpdateVoteTiles(tiles));
  }

  void _removeVote(
    RemoveVoteEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    _cache = _cache.removeProposal(event.proposal);
    _ballotBuilder.removeVoteOn(event.proposal);
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

  Future<void> _updateVote(
    UpdateVoteEvent event,
    Emitter<VotingBallotState> emit,
  ) async {
    final proposalRef = event.proposal;
    final isProposalCached = _cache.votesProposals.containsKey(proposalRef);

    if (!isProposalCached) {
      // TODO(damian-molinski): call voting service and get
      final proposal = VoteProposal(
        ref: proposalRef,
        category: VoteProposalCategory(
          ref: SignedDocumentRef.generateFirstRef(),
          name: 'Dummy Category Name',
        ),
        title: 'Dummy Proposal Title',
        authorName: 'XYZ',
        lastCastedVote: Vote(
          selfRef: SignedDocumentRef.generateFirstRef(),
          proposal: proposalRef,
          type: VoteType.yes,
        ),
      );

      _cache = _cache.addProposal(proposal);
    }

    // If already has vote in ballot when we don't need to do anything
    // because .voteOn will just update type with and keep it the same.
    final voteId = _ballotBuilder.hasVotedOn(proposalRef)
        ? null
        : await _getLastCastedVoteOn(proposalRef).then((vote) => vote?.selfRef.id);

    _ballotBuilder.voteOn(
      proposal: proposalRef,
      type: event.type,
      voteId: voteId,
    );
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

    final (:progress, :endsIn) = _calculatePhaseProgress();

    add(UpdateVotingPhaseProgressEvent(votingPhaseProgress: progress, votingEndsIn: endsIn));

    if (progress == 1.0) {
      return;
    }

    _phaseProgressTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final (:progress, :endsIn) = _calculatePhaseProgress();

        add(UpdateVotingPhaseProgressEvent(votingPhaseProgress: progress, votingEndsIn: endsIn));

        if (progress == 1.0) {
          timer.cancel();
        }
      },
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
