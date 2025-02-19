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
      parentSchemaUrl: '',
      schemaSelfUrl: '',
      title: '',
      description: MarkdownData.empty,
      properties: [],
      order: [],
    );

    final proposalDocument = ProposalDocument(
      metadata: ProposalMetadata(
        id: const Uuid().v7(),
        version: const Uuid().v7(),
      ),
      document: const Document(
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
      version: 1,
      duration: 6,
      author: 'Alex Wells',
    );

    final proposalViewModel = ProposalViewModel.fromProposalAtStage(
      proposal: proposal,
      campaignName: campaign.name,
      campaignStage: CampaignStage.fromCampaign(campaign, DateTime.now()),
    );

    late ProposalsCubit proposalsCubit;

    setUp(() {
      proposalsCubit = ProposalsCubit(
        _FakeCampaignService(campaign),
        _FakeProposalService([proposal]),
      );
    });

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals loads user proposals correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            usersProposals: true,
            pageKey: 1,
            pageSize: 10,
            lastId: null,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        ProposalsState(
          userProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [proposalViewModel],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals loads favorite proposals correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
            usersFavorite: true,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        ProposalsState(
          favoriteProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [proposalViewModel],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getFavoritesList loads favorites ids correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getFavoritesList();
      },
      expect: () => [
        const ProposalsState(favoritesIds: ['1', '2']),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals loads draft proposals correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
            stage: ProposalPublish.draft,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        ProposalsState(
          draftProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [proposalViewModel],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals loads published proposals correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
            stage: ProposalPublish.published,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        ProposalsState(
          finalProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [proposalViewModel],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals loads all proposals correctly',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        ProposalsState(
          allProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [proposalViewModel],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals handles empty results correctly',
      build: () {
        return ProposalsCubit(
          _FakeCampaignService(campaign),
          _FakeProposalService([]),
        );
      },
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
          ),
        );
      },
      expect: () => [
        const ProposalsState(isLoading: true),
        const ProposalsState(
          allProposals: ProposalPaginationItems(
            pageKey: 1,
            maxResults: 10,
            items: [],
          ),
        ),
      ],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getProposals handles null campaign correctly',
      build: () {
        return ProposalsCubit(
          _FakeCampaignService(null),
          _FakeProposalService([proposal]),
        );
      },
      act: (cubit) async {
        await cubit.getProposals(
          const ProposalPaginationRequest(
            pageKey: 1,
            pageSize: 10,
            lastId: null,
          ),
        );
      },
      expect: () => <ProposalsState>[],
    );

    blocTest<ProposalsCubit, ProposalsState>(
      'getUserProposalsList updates user proposals ids',
      build: () => proposalsCubit,
      act: (cubit) async {
        await cubit.getUserProposalsList();
      },
      expect: () => [
        const ProposalsState(favoritesIds: ['1', '2']),
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
  Future<List<String>> getFavoritesProposalsIds() async {
    return ['1', '2'];
  }

  @override
  Future<ProposalPaginationItems<Proposal>> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    return ProposalPaginationItems(
      pageKey: request.pageKey,
      maxResults: 10,
      items: _proposals,
    );
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    return ['1', '2'];
  }
}
