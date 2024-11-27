import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ProposalsCubit, () {
    final proposal = PendingProposal(
      id: '1',
      title: 'Proposal 1',
      description: 'Description 1',
      fund: 'F14',
      category: '',
      lastUpdateDate: DateTime.now(),
      fundsRequested: const Coin(100000),
      commentsCount: 0,
      completedSegments: 1,
      totalSegments: 3,
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'initial state is $LoadingProposalsState',
      build: () {
        return ProposalsCubit(
          proposalRepository: _FakeProposalRepository([]),
        );
      },
      verify: (cubit) {
        expect(cubit.state, equals(const LoadingProposalsState()));
      },
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'load emits $LoadedProposalsState with proposals',
      build: () {
        return ProposalsCubit(
          proposalRepository: _FakeProposalRepository([proposal]),
        );
      },
      act: (cubit) async => cubit.load(),
      expect: () => [
        LoadedProposalsState(
          proposals: [proposal],
          favoriteProposals: const [],
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'onFavoriteProposal / onUnfavoriteProposal adds/removes proposal from favorites',
      build: () {
        return ProposalsCubit(
          proposalRepository: _FakeProposalRepository([proposal]),
        );
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.onFavoriteProposal(proposal.id);
        await cubit.onUnfavoriteProposal(proposal.id);
      },
      expect: () => [
        LoadedProposalsState(
          proposals: [proposal],
          favoriteProposals: const [],
        ),
        LoadedProposalsState(
          proposals: [proposal],
          favoriteProposals: [proposal],
        ),
        LoadedProposalsState(
          proposals: [proposal],
          favoriteProposals: const [],
        ),
      ],
    );
  });
}

class _FakeProposalRepository extends Fake implements ProposalRepository {
  final List<PendingProposal> proposals;

  _FakeProposalRepository(this.proposals);

  @override
  Future<List<PendingProposal>> getDraftProposals() async {
    return proposals;
  }
}
