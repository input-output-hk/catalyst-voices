import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ProposalsCubit, () {
    final proposal = Proposal(
      id: '1',
      title: 'Proposal 1',
      description: 'Description 1',
      category: '',
      updateDate: DateTime.now(),
      fundsRequested: const Coin(100000),
      status: ProposalStatus.draft,
      publish: ProposalPublish.draft,
      access: ProposalAccess.private,
      commentsCount: 0,
      sections: List.generate(3, (index) {
        return ProposalSection(
          id: 'f14/0_$index',
          name: 'Section_$index',
          steps: [
            ProposalSectionStep(
              id: 'f14/0_${index}_1',
              name: 'Topic 1',
              answer: index < 1 ? MarkdownString('Ans') : null,
            ),
          ],
        );
      }),
    );

    final pendingProposal = PendingProposal.fromProposal(
      proposal,
      campaignName: 'F14',
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
          proposals: [pendingProposal],
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
          proposals: [pendingProposal],
          favoriteProposals: const [],
        ),
        LoadedProposalsState(
          proposals: [pendingProposal],
          favoriteProposals: [pendingProposal],
        ),
        LoadedProposalsState(
          proposals: [pendingProposal],
          favoriteProposals: const [],
        ),
      ],
    );
  });
}

class _FakeProposalRepository extends Fake implements ProposalRepository {
  final List<Proposal> proposals;

  _FakeProposalRepository(this.proposals);

  @override
  Future<List<Proposal>> getDraftProposals({
    required String campaignId,
  }) async {
    return proposals;
  }
}
