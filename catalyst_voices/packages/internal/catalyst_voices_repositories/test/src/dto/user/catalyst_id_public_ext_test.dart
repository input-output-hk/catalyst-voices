import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/dto/user/catalyst_id_public_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('decode', () {
    test('spaces are handled correctly', () {
      // Given
      const sourceUsername = 'First%20Last';
      const expectedUsername = 'First Last';
      const id = CatalystIDPublic(username: sourceUsername);

      // When
      final decodedId = id.decode();

      // Then
      expect(decodedId.username, expectedUsername);
    });

    test('diacritical characters are handled correctly', () {
      // Given
      const sourceUsername = 'First Ląst';
      const expectedUsername = 'First Ląst';
      const id = CatalystIDPublic(username: sourceUsername);

      // When
      final decodedId = id.decode();

      // Then
      expect(decodedId.username, expectedUsername);
    });

    test('diacritical characters with while spaces are handled correctly', () {
      // Given
      const sourceUsername = 'First%20Ląst';
      const expectedUsername = 'First Ląst';
      const id = CatalystIDPublic(username: sourceUsername);

      // When
      final decodedId = id.decode();

      // Then
      expect(decodedId.username, expectedUsername);
    });
  });
}
