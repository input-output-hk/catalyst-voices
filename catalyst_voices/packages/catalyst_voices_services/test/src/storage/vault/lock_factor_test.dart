import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:test/test.dart';

void main() {
  group('LockFactor', () {
    test('void lock serialization does work', () {
      // Given
      const lock = VoidLockFactor();

      // When
      final json = lock.toJson();
      final deserializedFactor = LockFactor.fromJson(json);

      // Then
      expect(deserializedFactor, isA<VoidLockFactor>());
    });

    test('description', () {
      // Given
      const lock = PasswordLockFactor('pass1234');

      // When
      final json = lock.toJson();
      final deserializedFactor = LockFactor.fromJson(json);

      // Then
      expect(deserializedFactor, isA<PasswordLockFactor>());
      expect(deserializedFactor.unlocks(lock), isTrue);
    });
  });

  group('VoidLockFactor', () {
    test('does not unlocks any other lock', () {
      // Given
      const lock = VoidLockFactor();
      const locks = <LockFactor>[
        VoidLockFactor(),
        PasswordLockFactor('pass1234'),
      ];

      // When
      final unlocks = locks.map((e) => lock.unlocks(e)).toList();

      // Then
      expect(unlocks, everyElement(false));
    });

    test('toJson result has type field', () {
      // Given
      const lock = VoidLockFactor();

      // When
      final json = lock.toJson();

      // Then
      expect(json.containsKey('type'), isTrue);
    });

    test('toString equals class name', () {
      // Given
      const lock = VoidLockFactor();

      // When
      final asString = lock.toString();

      // Then
      expect(asString, lock.runtimeType.toString());
    });
  });

  group('PasswordLockFactor', () {
    test('unlocks other PasswordLockFactor with matching data', () {
      // Given
      const lock = PasswordLockFactor('admin1234');
      const otherLock = PasswordLockFactor('admin1234');

      // When
      final unlocks = lock.unlocks(otherLock);

      // Then
      expect(unlocks, isTrue);
    });

    test('does not unlocks other PasswordLockFactor with different data', () {
      // Given
      const lock = PasswordLockFactor('admin1234');
      const otherLock = PasswordLockFactor('pass1234');

      // When
      final unlocks = lock.unlocks(otherLock);

      // Then
      expect(unlocks, isFalse);
    });

    test('does not unlocks other non PasswordLockFactor', () {
      // Given
      const lock = PasswordLockFactor('admin1234');
      const otherLock = VoidLockFactor();

      // When
      final unlocks = lock.unlocks(otherLock);

      // Then
      expect(unlocks, isFalse);
    });

    test('toJson result has type and data field', () {
      // Given
      const lock = PasswordLockFactor('admin1234');

      // When
      final json = lock.toJson();

      // Then
      expect(json.containsKey('type'), isTrue);
      expect(json.containsKey('data'), isTrue);
    });

    test('toString does not contain password', () {
      // Given
      const password = 'admin1234';
      const lock = PasswordLockFactor(password);

      // When
      final asString = lock.toString();

      // Then
      expect(asString, isNot(contains(password)));
    });
  });
}
