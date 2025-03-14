import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Proposal baseProposal;

  setUpAll(() {
    baseProposal = Proposal(
      selfRef: SignedDocumentRef(
        id: const Uuid().v7(),
        version: const Uuid().v7(),
      ),
      category: 'Cardano Use Cases / MVP',
      title: 'Proposal Title that rocks the world',
      updateDate: DateTime.now().minusDays(2),
      fundsRequested: Coin.fromAda(100000),
      status: ProposalStatus.draft,
      publish: ProposalPublish.publishedDraft,
      commentsCount: 0,
      description: '',
      duration: 6,
      author: 'Alex Wells',
      versions: const [],
    );
  });

  group(ProposalPaginationItems, () {
    test('creates instance with default values', () {
      const pagination = ProposalPaginationItems<Proposal>();

      expect(pagination.pageKey, equals(0));
      expect(pagination.maxResults, equals(0));
      expect(pagination.items, isEmpty);
    });

    test('creates instance with custom values', () {
      final items = [baseProposal, baseProposal];
      final pagination = ProposalPaginationItems<Proposal>(
        pageKey: 1,
        maxResults: 10,
        items: items,
      );

      expect(pagination.pageKey, equals(1));
      expect(pagination.maxResults, equals(10));
      expect(pagination.items, equals(items));
    });

    test('copyWith creates new instance with updated values', () {
      final original = ProposalPaginationItems<Proposal>(
        pageKey: 1,
        maxResults: 10,
        items: [baseProposal],
      );

      final copied = original.copyWith(
        pageKey: 2,
        maxResults: 20,
        items: [baseProposal, baseProposal],
      );

      expect(copied.pageKey, equals(2));
      expect(copied.maxResults, equals(20));
      expect(copied.items.length, equals(2));
      expect(copied, isNot(same(original)));
    });

    test('equals works correctly', () {
      final pagination1 = ProposalPaginationItems<Proposal>(
        pageKey: 1,
        maxResults: 10,
        items: [baseProposal],
      );

      final pagination2 = ProposalPaginationItems<Proposal>(
        pageKey: 1,
        maxResults: 10,
        items: [baseProposal],
      );

      expect(pagination1, equals(pagination2));
    });
  });

  group('ProposalsSearchResult', () {
    test('creates instance with required values', () {
      final proposals = [baseProposal];
      final searchResult = ProposalsSearchResult(
        maxResults: 10,
        proposals: proposals,
      );

      expect(searchResult.maxResults, equals(10));
      expect(searchResult.proposals, equals(proposals));
    });

    test('equals works correctly', () {
      final proposals = [baseProposal];
      final result1 = ProposalsSearchResult(
        maxResults: 10,
        proposals: proposals,
      );

      final result2 = ProposalsSearchResult(
        maxResults: 10,
        proposals: proposals,
      );

      expect(result1, equals(result2));
    });
  });
}
