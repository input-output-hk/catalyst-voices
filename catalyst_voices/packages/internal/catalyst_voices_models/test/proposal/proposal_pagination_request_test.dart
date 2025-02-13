import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(ProposalPaginationRequest, () {
    test('creates instance with required and optional parameters', () {
      const request = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: 'lastId123',
        categoryId: 'category1',
        searchValue: 'search',
        stage: ProposalPublish.draft,
        usersProposals: true,
        usersFavorite: true,
      );

      expect(request.pageKey, equals(1));
      expect(request.pageSize, equals(10));
      expect(request.lastId, equals('lastId123'));
      expect(request.categoryId, equals('category1'));
      expect(request.searchValue, equals('search'));
      expect(request.stage, equals(ProposalPublish.draft));
      expect(request.usersProposals, isTrue);
      expect(request.usersFavorite, isTrue);
    });

    test('creates instance with default values for optional parameters', () {
      const request = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: null,
      );

      expect(request.categoryId, isNull);
      expect(request.searchValue, isNull);
      expect(request.stage, isNull);
      expect(request.usersProposals, isFalse);
      expect(request.usersFavorite, isFalse);
    });

    test('copyWith returns new instance with updated values', () {
      const original = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: 'lastId123',
        categoryId: 'category1',
      );

      final copied = original.copyWith(
        pageKey: 2,
        categoryId: 'category2',
        searchValue: 'newSearch',
        stage: ProposalPublish.published,
        usersProposals: true,
        usersFavorite: true,
      );

      expect(copied.pageKey, equals(2));
      expect(copied.pageSize, equals(10)); // Unchanged
      expect(copied.lastId, equals('lastId123')); // Unchanged
      expect(copied.categoryId, equals('category2'));
      expect(copied.searchValue, equals('newSearch'));
      expect(copied.stage, equals(ProposalPublish.published));
      expect(copied.usersProposals, isTrue);
      expect(copied.usersFavorite, isTrue);
    });

    test('props contains all properties', () {
      const request = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: 'lastId123',
        categoryId: 'category1',
        searchValue: 'search',
        stage: ProposalPublish.draft,
        usersProposals: true,
        usersFavorite: true,
      );

      expect(request.props, contains(request.categoryId));
      expect(request.props, contains(request.searchValue));
      expect(request.props, contains(request.stage));
      expect(request.props, contains(request.usersProposals));
      expect(request.props, contains(request.usersFavorite));
      expect(request.props, contains(request.pageKey));
      expect(request.props, contains(request.pageSize));
      expect(request.props, contains(request.lastId));
    });

    test('instances with same properties are equal', () {
      const request1 = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: 'lastId123',
        categoryId: 'category1',
      );

      const request2 = ProposalPaginationRequest(
        pageKey: 1,
        pageSize: 10,
        lastId: 'lastId123',
        categoryId: 'category1',
      );

      expect(request1, equals(request2));
    });
  });
}
