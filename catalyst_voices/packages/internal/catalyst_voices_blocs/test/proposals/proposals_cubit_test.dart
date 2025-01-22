import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(ProposalsCubit, () {
    const proposalTemplate = DocumentSchema(
      jsonSchema: '',
      title: '',
      description: MarkdownData.empty,
      properties: [],
      order: [],
      propertiesSchema: '',
    );

    final proposalDocument = ProposalDocument(
      metadata: ProposalMetadata(
        id: const Uuid().v7(),
        version: const Uuid().v7(),
      ),
      document: const Document(
        schemaUrl: '',
        schema: proposalTemplate,
        properties: [],
      ),
    );

    final campaign = Campaign(
      id: 'F14',
      name: 'campaign',
      description: 'description',
      startDate: DateTime.now(),
      endDate: DateTime.now().plusDays(1),
      proposalsCount: 0,
      publish: CampaignPublish.published,
    );

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
      document: proposalDocument,
    );

    final pendingProposal = PendingProposal.fromProposal(
      proposal,
      campaignName: campaign.name,
    );

    late AdminToolsCubit adminToolsCubit;

    setUp(() {
      adminToolsCubit = AdminToolsCubit();
    });

    blocTest<ProposalsCubit, ProposalsState>(
      'initial state is $LoadingProposalsState',
      build: () {
        return ProposalsCubit(
          _FakeCampaignService(campaign),
          _FakeProposalService([]),
          adminToolsCubit,
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
          _FakeCampaignService(campaign),
          _FakeProposalService([proposal]),
          adminToolsCubit,
        );
      },
      act: (cubit) async => cubit.load(),
      expect: () => [
        const LoadingProposalsState(),
        LoadedProposalsState(
          proposals: [pendingProposal],
          favoriteProposals: const [],
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'admin tools override proposals in draft campaign state',
      build: () {
        return ProposalsCubit(
          _FakeCampaignService(campaign),
          _FakeProposalService([proposal]),
          adminToolsCubit,
        );
      },
      act: (cubit) async {
        adminToolsCubit.emit(
          const AdminToolsState(
            enabled: true,
            campaignStage: CampaignStage.draft,
          ),
        );
        return Future<void>.delayed(const Duration(microseconds: 50));
      },
      expect: () => [
        const LoadingProposalsState(),
        const LoadedProposalsState(
          proposals: [],
          favoriteProposals: [],
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'admin tools override proposals in live campaign state',
      build: () {
        return ProposalsCubit(
          _FakeCampaignService(campaign),
          _FakeProposalService([proposal]),
          adminToolsCubit,
        );
      },
      act: (cubit) async {
        adminToolsCubit.emit(
          const AdminToolsState(
            enabled: true,
            campaignStage: CampaignStage.live,
          ),
        );
        return Future<void>.delayed(const Duration(microseconds: 50));
      },
      expect: () => [
        const LoadingProposalsState(),
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
          _FakeCampaignService(campaign),
          _FakeProposalService([proposal]),
          adminToolsCubit,
        );
      },
      act: (cubit) async {
        await cubit.load();
        await cubit.onFavoriteProposal(proposal.id);
        await cubit.onUnfavoriteProposal(proposal.id);
      },
      expect: () => [
        const LoadingProposalsState(),
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

class _FakeCampaignService extends Fake implements CampaignService {
  final Campaign? _campaign;

  _FakeCampaignService(this._campaign);

  @override
  Future<Campaign?> getActiveCampaign() async {
    return _campaign;
  }
}

class _FakeProposalService extends Fake implements ProposalService {
  final List<Proposal> _proposals;

  _FakeProposalService(this._proposals);

  @override
  Future<List<Proposal>> getProposals({
    required String campaignId,
  }) async {
    return _proposals;
  }
}
