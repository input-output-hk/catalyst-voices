import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/representatives/delegation_builder.dart';
import 'package:test/test.dart';

void main() {
  group(DelegationBuilder, () {
    late DelegationBuilder builder;

    setUp(() {
      CatalystIdFactory.registerDummyKeyFactory();
      builder = DelegationBuilder();
    });

    tearDown(() async {
      await builder.dispose();
    });

    test('initial state is empty', () {
      // Then
      expect(builder.count, 0);
      expect(builder.maxCount, 4);
      expect(builder.representatives, isEmpty);
    });

    test('add increases count and updates representatives', () {
      // Given
      final rep = _createRepresentative(username: 'rep1');

      // When
      builder.add(rep);

      // Then
      expect(builder.count, 1);
      expect(builder.representatives, [rep]);
    });

    test('add throws exception when max count reached', () {
      // Given
      for (var i = 0; i < builder.maxCount; i++) {
        builder.add(_createRepresentative(username: 'rep$i'));
      }

      // When & Then
      expect(
        () => builder.add(_createRepresentative(username: 'too_many')),
        throwsA(isA<MaxDelegationRepresentativesReachedException>()),
      );
    });

    test('remove decreases count and updates representatives', () {
      // Given
      final rep1 = _createRepresentative(username: 'rep1');
      final rep2 = _createRepresentative(username: 'rep2');

      // When
      builder
        ..add(rep1)
        ..add(rep2)
        ..remove(rep1);

      // Then
      expect(builder.count, 1);
      expect(builder.representatives, [rep2]);
    });

    test('clear removes all representatives', () {
      // Given
      final rep1 = _createRepresentative(username: 'rep1');
      final rep2 = _createRepresentative(username: 'rep2');

      // When
      builder
        ..add(rep1)
        ..add(rep2)
        ..clear();

      // Then
      expect(builder.count, 0);
      expect(builder.representatives, isEmpty);
    });

    test('watch emits updates', () async {
      // Given
      final rep1 = _createRepresentative(username: 'rep1');
      final rep2 = _createRepresentative(username: 'rep2');

      // Then
      final expectation = expectLater(
        builder.watch,
        emitsInOrder([
          isEmpty,
          [rep1],
          [rep1, rep2],
          [rep2],
          isEmpty,
        ]),
      );

      // When
      await Future<void>.delayed(Duration.zero);
      builder
        ..add(rep1)
        ..add(rep2)
        ..remove(rep1)
        ..clear();

      await expectation;
    });

    test('build returns correct Delegation', () async {
      // Given
      final delegatorId = CatalystIdFactory.create(username: 'delegator');
      final rep1 = _createRepresentative(username: 'rep1');
      final rep2 = _createRepresentative(username: 'rep2');
      builder
        ..add(rep1)
        ..add(rep2);

      // When
      final delegation = await builder.build(delegatorId: delegatorId);

      // Then
      expect(delegation.delegatorId, delegatorId);
      expect(delegation.choices, hasLength(2));
      expect(delegation.choices[0].representativeId, rep1.id);
      expect(delegation.choices[0].representativeProfileId, rep1.profileId);
      expect(delegation.choices[1].representativeId, rep2.id);
      expect(delegation.choices[1].representativeProfileId, rep2.profileId);
    });

    test('representatives returns unmodifiable list', () {
      // Given
      final rep = _createRepresentative(username: 'rep1');
      builder.add(rep);

      // When & Then
      expect(
        () => (builder.representatives as dynamic).add(_createRepresentative(username: 'rep2')),
        throwsUnsupportedError,
      );
    });
  });
}

Representative _createRepresentative({required String username}) {
  return Representative(
    id: CatalystIdFactory.create(username: username),
    profileId: SignedDocumentRef.generateFirstRef(),
    description: 'Description for $username',
  );
}
