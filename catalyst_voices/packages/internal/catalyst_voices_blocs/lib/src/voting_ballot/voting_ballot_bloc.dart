import 'dart:async';
import 'dart:math';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/voting_ballot/voting_ballot_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';

final _logger = Logger('VotingBallotBloc');

typedef _VoteWithProposal = ({Vote vote, VoteProposal? proposal});

final class VotingBallotBloc extends Bloc<VotingBallotEvent, VotingBallotState>
    with BlocSignalEmitterMixin<VotingBallotSignal, VotingBallotState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final VotingBallotBuilder _ballotBuilder;
  final VotingService _votingService;

  var _cache = const VotingBallotCache();

  StreamSubscription<AccountVotingRole?>? _activeVotingRoleSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;
  StreamSubscription<Vote?>? _watchedCastedVotesSub;

  Timer? _phaseProgressTimer;

  VotingBallotBloc(
    this._userService,
    this._campaignService,
    this._ballotBuilder,
    this._votingService,
  ) : super(const VotingBallotState()) {
    on<UpdateVotingRoleEvent>(_updateVotingRole, transformer: uniqueEvents());
    on<UpdateVotingPhaseProgressEvent>(_updateVotingPhaseProgress, transformer: uniqueEvents());
    on<UpdateFundNumberEvent>(_updateFundNumber, transformer: uniqueEvents());
    on<UpdateFooterFromBallotBuilderEvent>(_updateFooterFromBallot, transformer: uniqueEvents());
    on<UpdateLastCastedVoteEvent>(_updateLastCastedVote, transformer: uniqueEvents());
    on<UpdateVoteTiles>(_updateTiles);
    on<UpdateVoteEvent>(_updateVote);
    on<RemoveVoteEvent>(_removeVote);
    on<CastVotesEvent>(_castVotes);
    on<ConfirmCastingVotesEvent>(_confirmCastingVotes);
    on<CancelCastingVotesEvent>(_cancelCastingVotes);
    on<CheckPasswordEvent>(_checkPassword);

    _activeVotingRoleSub = _votingService.watchActiveVotingRole().distinct().listen(
      _handleActiveVotingRoleChange,
    );

    _activeCampaignSub = _campaignService.watchActiveCampaign.listen(_handleCampaignChange);

    _ballotBuilder.addListener(_handleBallotBuilderChange);
    _handleBallotBuilderChange();

    _watchedCastedVotesSub = _votingService
        .watchedCastedVotes()
        .map((votes) => votes.lastOrNull)
        .listen(_handleLastCastedChange);
    _handleLastCastedChange(null);
  }

  @override
  Future<void> close() async {
    _ballotBuilder.removeListener(_handleBallotBuilderChange);

    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    _phaseProgressTimer?.cancel();
    _phaseProgressTimer = null;

    await _watchedCastedVotesSub?.cancel();
    _watchedCastedVotesSub = null;

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

  VotingPhaseProgressViewModel? _buildVotingPhase(Campaign? campaign) {
    final campaignVotingPhase = campaign?.phaseStateTo(CampaignPhaseType.communityVoting);
    final campaignStartDate = campaign?.startDate;

    if (campaignVotingPhase != null && campaignStartDate != null) {
      return VotingPhaseProgressViewModel.fromModel(
        state: campaignVotingPhase,
        campaignStartDate: campaignStartDate,
      );
    } else {
      return null;
    }
  }

  VotingPhaseProgressDetailsViewModel? _buildVotingPhaseDetails(Campaign? campaign) {
    final votingPhase = _buildVotingPhase(campaign);
    final now = DateTimeExt.now();
    return votingPhase?.progress(now);
  }

  void _cancelCastingVotes(CancelCastingVotesEvent event, Emitter<VotingBallotState> emit) {
    final footer = state.footer.copyWith(castingStep: const PreCastVotesStep());
    emit(state.copyWith(footer: footer));
    emitSignal(const HideBottomSheetSignal());
  }

  Future<void> _castVotes(
    CastVotesEvent event,
    Emitter<VotingBallotState> emit,
  ) async {
    try {
      final votingBallot = _ballotBuilder.build();
      // First cast votes then clear the ballot because when something fails in casting then we don't
      // want to clear the ballot and let the user try again.
      await _votingService.castVotes(votingBallot.votes);

      final footer = state.footer.copyWith(castingStep: const SuccessfullyCastVotesStep());
      // TODO(LynxxLynx): Remove this when integration with backend is fixed.
      // Move clear ballot below castVotes from service
      final randomBool = Random().nextBool();
      if (randomBool) {
        _ballotBuilder.clear();
        _cache = _cache.copyWith(votesProposals: {});
        final tiles = _buildTiles();
        emit(state.copyWith(tiles: tiles, footer: footer));
      } else {
        emit(
          state.copyWith(
            footer: footer.copyWith(castingStep: const FailedToCastVotesStep()),
          ),
        );
      }
    } catch (e, st) {
      _logger.severe('Error casting votes', e, st);
      final footer = state.footer.copyWith(castingStep: const FailedToCastVotesStep());
      emit(state.copyWith(footer: footer));
    }
  }

  Future<void> _checkPassword(CheckPasswordEvent event, Emitter<VotingBallotState> emit) async {
    const confirmPasswordStep = ConfirmPasswordStep(isLoading: true);
    const confirmPasswordFailed = ConfirmPasswordStep(
      exception: LocalizedUnlockPasswordException(),
    );
    final newFooter = state.footer.copyWith(castingStep: confirmPasswordStep);
    emit(state.copyWith(footer: newFooter));

    final keychain = _userService.user.activeAccount?.keychain;
    if (keychain == null) {
      emit(state.copyWith(footer: newFooter.copyWith(castingStep: confirmPasswordFailed)));
      return;
    }
    final unlock = await keychain.unlock(event.factor, dryRun: true);
    if (!unlock) {
      emit(state.copyWith(footer: newFooter.copyWith(castingStep: confirmPasswordFailed)));
      return;
    }

    add(const CastVotesEvent());
  }

  void _confirmCastingVotes(
    ConfirmCastingVotesEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final newFooter = state.footer.copyWith(castingStep: const ConfirmPasswordStep());
    emitSignal(const ShowBottomSheetSignal());
    emit(state.copyWith(footer: newFooter));
  }

  Future<Vote?> _getLastCastedVoteOn(DocumentRef proposal) async {
    return _votingService.getProposalLastCastedVote(proposal);
  }

  void _handleActiveVotingRoleChange(AccountVotingRole? votingRole) {
    add(UpdateVotingRoleEvent(votingRole));
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

    if (campaign != _cache.campaign) {
      _cache = _cache.copyWith(campaign: Optional(campaign));
      _updateVotingPhaseProgressTimer();
    }
  }

  void _handleLastCastedChange(Vote? vote) {
    add(UpdateLastCastedVoteEvent(vote?.createdAt));
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
    emit(state.copyWith(tiles: event.tiles, votesCount: _cache.votesCount));
  }

  Future<void> _updateVote(
    UpdateVoteEvent event,
    Emitter<VotingBallotState> emit,
  ) async {
    final proposalRef = event.proposal;
    final isProposalCached = _cache.votesProposals.containsKey(proposalRef);

    if (!isProposalCached) {
      final proposal = await _votingService.getVoteProposal(proposalRef);

      _cache = _cache.addProposal(proposal);
    }

    // If it has already voted in the ballot, when we don't need to do anything
    // because .voteOn will just update type with and keep it the same.
    final voteId = _ballotBuilder.hasVotedOn(proposalRef)
        ? null
        : await _getLastCastedVoteOn(proposalRef).then((vote) => vote?.id.id);

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
    final votingPhase = event.votingPhase;
    final votingProgress = state.votingProgress.copyWith(
      votingPhaseProgress: votingPhase?.votingPhaseProgress ?? 0,
      votingEndsIn: Optional(votingPhase?.votingPhaseEndsIn),
    );

    emit(state.copyWith(votingProgress: votingProgress));
  }

  void _updateVotingPhaseProgressTimer() {
    _phaseProgressTimer?.cancel();
    _phaseProgressTimer = null;

    final campaign = _cache.campaign;
    final votingPhase = _buildVotingPhaseDetails(campaign);
    add(UpdateVotingPhaseProgressEvent(votingPhase: votingPhase));

    if (votingPhase == null || votingPhase.status == CampaignPhaseStatus.post) {
      return;
    }

    _phaseProgressTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final updatedVotingPhase = _buildVotingPhaseDetails(campaign);

        add(UpdateVotingPhaseProgressEvent(votingPhase: updatedVotingPhase));

        if (updatedVotingPhase?.status == CampaignPhaseStatus.post) {
          timer.cancel();
        }
      },
    );
  }

  void _updateVotingRole(
    UpdateVotingRoleEvent event,
    Emitter<VotingBallotState> emit,
  ) {
    final votingPower = event.data;

    final amount = votingPower?.totalVotingPowerAmount ?? 0;
    final status = switch (votingPower) {
      AccountVotingRoleDelegator(:final votingPower) => votingPower.data?.status,
      AccountVotingRoleIndividual(:final votingPower) => votingPower.data?.status,
      AccountVotingRoleRepresentative(:final votingPower) => votingPower.data?.status,
      null => null,
    };

    final userSummary = VotingListUserSummaryData(
      amount: amount,
      status: status,
    );

    emit(state.copyWith(userSummary: userSummary));
  }
}
