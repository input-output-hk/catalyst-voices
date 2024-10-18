import 'dart:convert';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:test/test.dart';

void main() {
  group(PasswordLockFactor, () {
    test('seed generates utf8 version of password', () {
      // Given
      const password = 'admin1234';
      const lock = PasswordLockFactor(password);
      final expected = utf8.encode(password);

      // When
      final seed = lock.seed;

      // Then
      expect(seed, expected);
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
