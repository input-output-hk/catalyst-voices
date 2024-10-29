import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('json createAt to createdAt', () {
      // Given
      final createdAt = DateTime.timestamp();

      // When
      final json = {
        'createAt': createdAt.toIso8601String(),
        'updatedAt': DateTime.timestamp().toIso8601String(),
      };

      // Then
      final metadata = KeychainMetadata.fromJson(json);

      expect(metadata.createdAt, createdAt);
    });
  });

  group('Equality', () {
    test('same source dates equals', () {
      // Given
      final now = DateTime.now();

      // When
      final metadataOne = KeychainMetadata(createdAt: now, updatedAt: now);
      final metadataTwo = KeychainMetadata(createdAt: now, updatedAt: now);

      // Then
      expect(metadataOne, metadataTwo);
    });

    test('different source dates equals', () {
      // Given
      final now = DateTime.now();
      final isPast = now.subtract(const Duration(days: 1));

      // When
      final metadataOne = KeychainMetadata(createdAt: now, updatedAt: now);
      final metadataTwo = KeychainMetadata(
        createdAt: isPast,
        updatedAt: isPast,
      );

      // Then
      expect(metadataOne, isNot(metadataTwo));
    });
  });
}
